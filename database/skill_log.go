package database

import (
	"fmt"
	"log"
	"os"
	"strconv"
	"sync"
	"time"

	null "gopkg.in/guregu/null.v3"
)

var SkillLoggingEnabled = skillLogEnabledDefault()

func skillLogEnabledDefault() bool {
	v := os.Getenv("SKILL_LOG_ENABLED")
	if v == "" {
		return true // on by default
	}
	b, err := strconv.ParseBool(v)
	if err != nil {
		log.Printf("skill_log: invalid SKILL_LOG_ENABLED value %q, defaulting to true", v)
		return true
	}
	return b
}

var (
	lastSkillCastTime = make(map[string]time.Time)
	wpeDetectionCount = make(map[string]int)
	lastSkillMutex    sync.Mutex
	wpeThreshold      = 750 // ms — suspicious cast delay
	wpeMaxViolations  = 3
)

func logSkillCast(character *Character, skillID int) {
	if !SkillLoggingEnabled {
		return
	}

	now := time.Now()

	lastSkillMutex.Lock()
	defer lastSkillMutex.Unlock()

	lastTime, exists := lastSkillCastTime[character.Name]
	lastSkillCastTime[character.Name] = now

	if !exists {
		return // no baseline yet — first cast is never a violation
	}

	delayMs := float64(now.Sub(lastTime).Microseconds()) / 1000
	if delayMs >= float64(wpeThreshold) {
		return // cast speed is fine
	}

	wpeDetectionCount[character.Name]++
	violations := wpeDetectionCount[character.Name]

	os.MkdirAll("logs", os.ModePerm)

	if wpeLogFile, err := os.OpenFile("logs/wpe_detected.txt",
		os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644); err == nil {
		fmt.Fprintf(wpeLogFile, "%s - WPE DETECTED: Character: %s | Skill: %d | Delay: %.3f ms | Violations: %d/%d\n",
			now.Format("2006-01-02 15:04:05.000"), character.Name, skillID, delayMs, violations, wpeMaxViolations)
		wpeLogFile.Close()
	}

	log.Printf("WPE DETECTED: %s skill %d delay %.3f ms (violation %d/%d)",
		character.Name, skillID, delayMs, violations, wpeMaxViolations)

	if violations >= wpeMaxViolations {
		cheatBan(character)
		delete(wpeDetectionCount, character.Name)
		delete(lastSkillCastTime, character.Name)
	}
}

func cheatBan(character *Character) {
	user, err := FindUserByID(character.UserID)
	if err != nil || user == nil {
		return
	}
	user.UserType = 0
	user.DisabledUntil = null.NewTime(time.Now().Add(time.Hour*24*30), true)
	user.Update()

	if sock := GetSocket(character.UserID); sock != nil {
		sock.Conn.Close()
	}

	log.Printf("AUTO-BAN: %s banned for packet injection (WPE)", character.Name)
}
