package database

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"time"

	"hero-emulator/config"
	"hero-emulator/logging"
	"hero-emulator/utils"

	_ "github.com/go-sql-driver/mysql"
	gorp "gopkg.in/gorp.v1"
)

var (
	DROP_LIFETIME     = time.Duration(30) * time.Second
	FREEDROP_LIFETIME = time.Duration(3) * time.Second
	DROP_RATE         = utils.ParseFloat("10.0")
	DEFAULT_DROP_RATE = utils.ParseFloat("10.0")
	EXP_RATE          = utils.ParseFloat("500.0")
	DEFAULT_EXP_RATE  = utils.ParseFloat("500.0")
)

var (
	db                      *gorp.DbMap
	Init                    = make(chan bool, 1)
	GetFromRegister         func(int, int16, uint16) interface{}
	RemoveFromRegister      func(*Character)
	RemovePetFromRegister   func(c *Character)
	FindCharacterByPseudoID func(server int, ID uint16) *Character

	AccUpgrades    []byte
	ArmorUpgrades  []byte
	WeaponUpgrades []byte
	plusRates      = []int{800, 900, 950, 980, 990, 996, 999}
	logger         = logging.Logger
)

func InitDB() error {

	var (
		cfg         = config.Default
		ip          = cfg.Database.IP
		port        = cfg.Database.Port
		user        = cfg.Database.User
		pass        = cfg.Database.Password
		dbname      = cfg.Database.Name
		maxIdle     = cfg.Database.ConnMaxIdle
		maxOpen     = cfg.Database.ConnMaxOpen
		maxLifetime = cfg.Database.ConnMaxLifetime
		debug       = cfg.Database.Debug
		err         error
		conn        *sql.DB
	)

	conn, err = sql.Open("mysql", fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8mb4&parseTime=true", user, pass, ip, port, dbname))
	if err != nil {
		return fmt.Errorf("Database connection error: %s", err.Error())
	}

	conn.SetMaxIdleConns(maxIdle)
	conn.SetMaxOpenConns(maxOpen)
	conn.SetConnMaxLifetime(time.Duration(maxLifetime) * time.Second)

	if err = conn.Ping(); err != nil {
		return fmt.Errorf("Database connection error: %s", err.Error())
	}

	db = &gorp.DbMap{Db: conn, Dialect: gorp.MySQLDialect{Engine: "InnoDB", Encoding: "UTF8MB4"}}
	db.AddTableWithName(PetExpInfo{}, "pet_exp_table")
	db.AddTableWithName(ExpInfo{}, "exp_table")
	db.AddTableWithName(NpcPosition{}, "npc_pos_table").SetKeys(false, "id")
	db.AddTableWithName(Item{}, "items").SetKeys(false, "id")
	db.AddTableWithName(SkillInfo{}, "skill_definitions").SetKeys(false, "id")
	db.AddTableWithName(Production{}, "productions")
	db.AddTableWithName(CraftItem{}, "craft_items")
	db.AddTableWithName(Stackable{}, "stackables")
	db.AddTableWithName(Gambling{}, "gambling")
	db.AddTableWithName(JobPassive{}, "job_passives")
	db.AddTableWithName(SavePoint{}, "save_points")
	db.AddTableWithName(HaxCode{}, "hax_codes")
	db.AddTableWithName(ItemMelting{}, "item_meltings")
	db.AddTableWithName(Gate{}, "gates")
	db.AddTableWithName(DropInfo{}, "drops").SetKeys(false, "id")
	db.AddTableWithName(HtItem{}, "ht_shop").SetKeys(false, "id")
	db.AddTableWithName(NPCScript{}, "npc_scripts")
	db.AddTableWithName(Fusion{}, "advanced_fusion")
	db.AddTableWithName(Pet{}, "pets").SetKeys(false, "id")
	db.AddTableWithName(NPC{}, "npc_table").SetKeys(false, "id")
	db.AddTableWithName(BuffIcon{}, "buff_icons")
	db.AddTableWithName(BuffInfection{}, "buff_infections").SetKeys(false, "id")
	db.AddTableWithName(Shop{}, "shop_table").SetKeys(false, "id")
	db.AddTableWithName(ShopItem{}, "shop_items").SetKeys(false, "type")
	db.AddTableWithName(RelicLog{}, "relic_log")
	db.AddTableWithName(RelicLog{}, "item_set")
	db.AddTableWithName(Rank{}, "reborn_system").SetKeys(false, "id")
	db.AddTableWithName(ItemJudgement{}, "item_judgement")
	db.AddTableWithName(FiveClan{}, "fiveclan_war").SetKeys(false, "id")

	db.AddTableWithName(AI{}, "ai").SetKeys(true, "id")
	db.AddTableWithName(AiBuff{}, "ai_buffs").SetKeys(false, "id")
	db.AddTableWithName(Character{}, "characters").SetKeys(true, "id")
	db.AddTableWithName(Buff{}, "characters_buffs").SetKeys(false, "id", "character_id")
	db.AddTableWithName(ConsignmentItem{}, "consignment").SetKeys(false, "id")
	db.AddTableWithName(Guild{}, "guilds").SetKeys(true, "id")
	db.AddTableWithName(InventorySlot{}, "items_characters").SetKeys(true, "id")
	db.AddTableWithName(Relic{}, "relics")
	db.AddTableWithName(Server{}, "servers").SetKeys(true, "id")
	db.AddTableWithName(Skills{}, "skills").SetKeys(false, "id")
	db.AddTableWithName(Stat{}, "stats").SetKeys(false, "id")
	db.AddTableWithName(User{}, "users").SetKeys(true, "id")

	if debug {
		db.TraceOn("[gorp]", log.New(os.Stdout, "myapp:", log.Lmicroseconds))
	}

	if err = resetDB(); err != nil {
		return err
	}

	if err = getAll(); err != nil {
		return err
	}

	Init <- err == nil
	return nil
}

func resetDB() error {

	query := `update characters set is_active = false, is_online = false`
	if _, err := db.Exec(query); err != nil {
		if err == sql.ErrNoRows {
			return nil
		}
		return fmt.Errorf("Reset DB error: %s", err.Error())
	}

	query = `update users set ip = ?, server = 0`
	if _, err := db.Exec(query, ""); err != nil {
		if err == sql.ErrNoRows {
			return nil
		}
		return fmt.Errorf("Reset DB error: %s", err.Error())
	}

	return nil
}

func getAll() error {

	callBacks := []func() error{getAllDrops, getScripts, getHaxCodes, getHTItems, getProductions, getCraftItem, getAdvancedFusions, getItemMeltings, getGates,
		getStackables, getAllItems, getSkillInfos, getGamblingItems, getJobPassives, getItemJudgements, getItemSet, getBuffIcons, getBuffInfections, getExps, getAllSavePoints,
		getRelics, getRelicLog, GetAllPetExps, GetAllPets, getAllShops, getAllShopItems}

	for _, cb := range callBacks {
		if err := cb(); err != nil {
			return err
		}
	}

	return nil
}
