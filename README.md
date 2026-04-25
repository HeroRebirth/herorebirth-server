## Hero Rebirth
An open source, educational server emulator for Hero Online, built on top of the Dragon Legend / Trinity 2022 foundation with ongoing improvements and refinements.

## Improvements
- PostgreSQL driver replaced with MySQL
- Config variables live in a `.env` file with fallback defaults

### Requirements
* [Go](https://go.dev/doc/install) >= 1.11
* [MariaDB](https://mariadb.org/download/)
* [Redis](https://redis.io/downloads/) - Optional
  
## Game Systems
- **Character Classes**: All base classes
- **3 Forms**: Normal, Divine (1st reborn), Darkness (2nd reborn)
- **Combat**: PvE, PvP, damage calculations, elemental types, status effects
- **Inventory**: 450 slots, upgrade system, gem sockets, **item** fusion
- **Skills**: Active & passive, cooldown-based, skill books & upgrades
- **Pets**: Stats, leveling, combat mode, taming
- **Social**: Party, guilds, PvP duels, Wars
- **Guilds**: Creation, member management, roles (Leader, Sub-Leader, Member), announcements, guild wars
- **Economy**: NPC shops, player trading, consignment board
- **World**: Maps, NPCs, mobs, dungeons
- **Anti-Cheat**: Slot exploit detection & logging — See [AntiSlotExploit](AntiSlotExploit/) for exploit logs

**NOTE: all user passwords are stored as SHA256**

### Environment
Copy `.env.example` to `.env` and fill in your values.

### Installation
Source code can be compiled by `go build` command, and the output can be used to start serving directly or the binarys released in the repo.

**Docker:**
A prepared Docker setup is available for quick deployment. Simply run:
```bash
docker-compose up -d 
```
See `docker-compose.yml` for details.

### Admin Commands
A full list of in-game admin slash commands and examples is available in [ADMIN_COMMANDS.md](ADMIN_COMMANDS.md).

## Contributing

Contributions, bug reports, and feature requests are welcome. Please ensure:
- Code follows Go idioms and best practices
- Database schema changes include migrations
- Anti-cheat logging is preserved

## License

See [LICENSE](LICENSE) file.

### Credits
- Dragon Legend team — original emulator foundation
- Trinity — base source (2022)
- Special thanks to Shenanigans 
- All contributors who have helped improve and maintain this project