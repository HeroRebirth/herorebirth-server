# Admin Slash Commands

All commands are entered in the in-game chat. Commands are case-insensitive.

## Role Hierarchy

| Level | Role | Description |
|-------|------|-------------|
| 0 | BANNED | Banned user |
| 1 | COMMON | Regular player |
| 2 | GA | Game Assistant |
| 3 | GAL | Gallery / Senior GA |
| 4 | GM | Game Master |
| 5 | HGM | Head Game Master |
| 6 | VIP | VIP player |

---

## GAL Commands (Role ≥ 3)

### `/announce <message>`
Broadcast a server-wide announcement to all online players.

```
/announce Server maintenance in 30 minutes!
```

---

### `/shout`
Send a server-wide shout (requires a shout item in inventory).

```
/shout
```

---

### `/event <message>`
Broadcast an event notice to all online players.

```
/event Double EXP event starts now!
```

---

### `/mob <position_id>`
Spawn a single mob from a position ID at your current location and announce it.

```
/mob 1042
```

---

### `/mute <character_name>`
Prevent a player from using chat.

```
/mute BadPlayer
```

---

### `/unmute <character_name>`
Restore a player's ability to chat.

```
/unmute BadPlayer
```

---

### `/inv <0|1>`
Toggle your invisibility. `1` = invisible, `0` = visible.

```
/inv 1
/inv 0
```

---

### `/kick <character_name>`
Disconnect a player from the server.

```
/kick ToxicUser
```

---

### `/summon <character_name>`
Teleport a player to your current location.

```
/summon PlayerName
```

---

### `/tp <x> <y>`
Teleport yourself to the given coordinates on your current map.

```
/tp 320 415
```

---

### `/tpp <character_name>`
Teleport yourself to another player's location.

```
/tpp PlayerName
```

---

### `/droplog`
Display today's relic drop log with timestamps.

```
/droplog
```

---

### `/online`
List all online players with their current map and server.

```
/online
```

---

### `/main`
Start a 60-second server maintenance countdown and then shut down.

```
/main
```

---

## GM Commands (Role ≥ 4)

### `/item <item_id> [quantity] [character_id]`
Give an item to yourself or to another character by ID. Omit `character_id` to give to yourself.

```
/item 15900001
/item 11000001 5
/item 11000001 10 12345
```

---

### `/discitem <item_id> [quantity] [item_type] [judge_stat] [character_id]`
Give a discriminated (statted) item. `item_type` and `judge_stat` control additional item properties.

```
/discitem 11000001 1 0 0
/discitem 11000001 1 0 3 12345
```

---

### `/rank <rank_id>`
Set your current character's honor rank.

```
/rank 5
```

---

### `/divine`
Instantly max your character's level (adds maximum EXP), changes class to 21, and teleports to map 14.

```
/divine
```

---

### `/exp <amount> [character_id]`
Add experience to yourself or to another character by ID.

```
/exp 1000000
/exp 5000000 12345
```

---

### `/petexp <amount>`
Add experience to your equipped pet (slot 0x0A).

```
/petexp 500000
```

---

### `/map <map_id> [character_name]`
Teleport yourself or another character to the specified map.

```
/map 14
/map 229 PlayerName
```

---

### `/buff <infection_id> <duration>`
Apply a buff or debuff to your character.

```
/buff 10101 300
```

---

### `/cash <username> <amount>`
Add NCash (premium currency) to a user account.

```
/cash playeruser 5000
```

---

### `/addguild <guild_id> [character_name]`
Add yourself or another character to a guild. Use `-1` as `guild_id` to remove from guild.

```
/addguild 7
/addguild 7 PlayerName
/addguild -1 PlayerName
```

---

### `/findguild <guild_name>`
Look up a guild by name and return its ID.

```
/findguild WarriorsClan
```

---

### `/dungeon`
Teleport yourself to the dungeon map (map 243, coordinates 377, 246).

```
/dungeon
```

---

### `/charinfo <character_name>`
Display detailed information about a character: level, EXP, gold, current location, etc.

```
/charinfo PlayerName
```

---

### `/ban <user_id> <hours>`
Ban a user for the specified number of hours.

```
/ban 9001 24
/ban 9001 720
```

---

### `/uid <character_name>`
Get the user ID associated with a character name.

```
/uid PlayerName
```

---

### `/uuid <username>`
Get the UUID associated with a username.

```
/uuid playeruser
```

---

### `/upgrade <slot_id> <code> [count]`
Apply an upgrade code to the item in the specified inventory slot. `count` defaults to 1.

```
/upgrade 0 800
/upgrade 2 950 5
```

Upgrade success rate codes:

| Code | Success Rate |
|------|-------------|
| 800  | 80% |
| 900  | 90% |
| 950  | 95% |
| 980  | 98% |
| 990  | 99% |
| 996  | 99.6% |
| 999  | 99.9% |

---

### `/speed <multiplier>`
Set your movement speed multiplier.

```
/speed 2
/speed 5
```

---

## HGM Commands (Role ≥ 5)

### `/deleteitemslot <slot_id> [character_name]`
Delete the item in an inventory slot for yourself or another character.

```
/deleteitemslot 3
/deleteitemslot 3 PlayerName
```

---

### `/class <character_id> <class_type>`
Change a character's class.

```
/class 12345 4
```

---

### `/gold <amount>`
Add gold to your current character.

```
/gold 1000000
```

---

### `/exprate <multiplier> <duration_minutes>`
Set a temporary EXP rate multiplier for the entire server. Resets automatically after the duration.

```
/exprate 2 60
/exprate 3 30
```

---

### `/droprate <multiplier> <duration_minutes>`
Set a temporary drop rate multiplier for the entire server. Resets automatically after the duration.

```
/droprate 2 60
/droprate 5 15
```

---

### `/refresh <type>`
Reload game data from the database without restarting the server.

Available types:

| Type | What It Reloads |
|------|----------------|
| `items` | Item definitions |
| `scripts` | Game scripts |
| `htshop` | HT shop items |
| `buffinf` | Buff/debuff info |
| `advancedfusions` | Advanced fusion recipes |
| `gamblings` | Gambling data |
| `craftitems` | Craft item data |
| `productions` | Production recipes |
| `drops` | Drop tables |
| `shopitems` | NPC shop items |
| `npc` | NPC definitions |
| `exp` | EXP tables |
| `users` | User data |
| `npcpos` | NPC position data |
| `all` | Everything above |

```
/refresh drops
/refresh all
```

---

### `/addmobs <npc_id> <count>`
Spawn multiple mobs of the given NPC ID at your current location.

```
/addmobs 10450 5
/addmobs 10001 10
```

---

### `/resetallmobs`
Reset all mobs on the server back to their original spawn positions.

```
/resetallmobs
```

---

### `/relic <item_id> [character_id]`
Give a relic item to yourself or to another character.

```
/relic 19000001
/relic 19000001 12345
```

---

### `/greatwar <duration_seconds>`
Start a Great War (faction war) for the given duration in seconds.

```
/greatwar 3600
```

---

### `/factionwar`
Prepare and start a faction war.

```
/factionwar
```

---

### `/autogreatwar`
Schedule the Great War to auto-start every 5 hours.

```
/autogreatwar
```

---

### `/autofactionwar`
Schedule the faction war to auto-start every 5 hours.

```
/autofactionwar
```

---

### `/name <character_id> <new_name>`
Change a character's name by their character ID.

```
/name 12345 NewName
```

---

### `/role <character_id> <user_type>`
Change a character's user role/type.

```
/role 12345 3
```

Role values: `0` = Banned, `1` = Common, `2` = GA, `3` = GAL, `4` = GM, `5` = HGM, `6` = VIP

---

### `/logskills`
Toggle the WPE / skill-spam detection system on or off. When active, all skill casts are monitored for suspiciously fast timing. Players who cast below the threshold repeatedly are auto-banned and logged to `logs/wpe_detected.txt`. The system starts enabled by default (controlled by `SKILL_LOG_ENABLED` in `.env`).

```
/logskills
```

---

### `/skillpoint <character_name> <amount>`
Add skill points to a character.

```
/skillpoint PlayerName 50
```

---

### `/type <character_id> <type>`
Set a character's internal type flag.

```
/type 12345 2
```

---

## Special / Any Role

### `/number <guess>`
Submit a guess for the dungeon number guessing game. Requires `DungeonLevel >= 2` to participate.

```
/number 42
```
