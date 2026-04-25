package config

import (
	"log"
	"os"
	"strconv"

	"github.com/joho/godotenv"
)

var Default *config

func init() {
	godotenv.Load() // load .env if present; no-op if file doesn't exist
	Default = &config{
		Database: Database{
			Driver:          envStr("DB_DRIVER", "mysql"),
			IP:              envStr("DB_HOST", "localhost"),
			Port:            envInt("DB_PORT", 3306),
			User:            envStr("DB_USER", "root"),
			Password:        envStr("DB_PASSWORD", "root"),
			Name:            envStr("DB_NAME", "herorebirth"),
			ConnMaxIdle:     envInt("DB_CONN_MAX_IDLE", 500),
			ConnMaxOpen:     envInt("DB_CONN_MAX_OPEN", 300),
			ConnMaxLifetime: envInt("DB_CONN_MAX_LIFETIME", 50),
			Debug:           envBool("DB_DEBUG", false),
			SSLMode:         envStr("DB_SSL_MODE", "disable"),
		},
		Server: Server{
			IP:   envStr("SERVER_IP", "127.0.0.1"),
			Port: envInt("SERVER_PORT", 5310),
		},
	}
}

func envStr(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}

func envInt(key string, fallback int) int {
	v := os.Getenv(key)
	if v == "" {
		return fallback
	}
	n, err := strconv.Atoi(v)
	if err != nil {
		log.Fatalf("config: invalid value for %s: %v", key, err)
	}
	return n
}

func envBool(key string, fallback bool) bool {
	v := os.Getenv(key)
	if v == "" {
		return fallback
	}
	b, err := strconv.ParseBool(v)
	if err != nil {
		log.Fatalf("config: invalid value for %s: %v", key, err)
	}
	return b
}
