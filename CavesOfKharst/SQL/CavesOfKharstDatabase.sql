
-- START OF DDL --
-- To initialise the database and populate with game data. you may run the entire script now.
-- Once initialised, the database can be tested using the code below the DDL.
-- IMPORTANT NOTE: MySQL Workbench cannot handle any more than one section of this codebase run at a time
-- please only run one section at a time (DDL, TESTING PHASE 1 - PRE GAME, or TESTING PHASE 2 - IN GAME)
 
 
-- to find specific requirements use control + F with the following text:
-- both the DDL procedure definitions and their tests include these requirements.
-- 1. Player login, including lock out
-- 2. Player registration
-- 3. Laying out tiles on a game board
-- 4. Placing an item on a tile
-- 5. Player game play movement, i.e., moving a player to a “legal” tile
-- 6. Game play scoring. How do players gain and lose points
-- 7. Player game play acquiring inventory, e.g., picking up items off a tile and putting them in an inventory (bag?)
-- 8. Move an Item (NPC effect)
-- 9. Kill running games
-- 10. Add new players
-- 11. Update data of a player
-- 12. Delete a player


-- uncomment the line below and its pair beneath DDL to comment out the DDL section
-- /*

-- reset database
DROP DATABASE IF EXISTS temp;
CREATE DATABASE temp;
USE temp;
DROP DATABASE IF EXISTS caves_of_kharst;
CREATE DATABASE caves_of_kharst;
USE caves_of_kharst;
DROP DATABASE IF EXISTS temp;
-- event scheduler for game ticks
SET GLOBAL event_scheduler = ON;

-- PROCEDURES
-- create tables
DELIMITER //
DROP PROCEDURE IF EXISTS create_database //
CREATE PROCEDURE create_database()
BEGIN
	CREATE TABLE user_account (
		user_account_id bigint(19)   NOT NULL AUTO_INCREMENT PRIMARY KEY,
		email 			varchar(64)  NOT NULL UNIQUE,
		`password` 		varchar(64)  NOT NULL,
		`role` 			varchar(64)  NOT NULL DEFAULT 'player',
        failed_logins   int(10)      NOT NULL DEFAULT 0,
        lockout_time	timestamp(6)
	);

	CREATE TABLE game (
		game_id    	   int(10) 		NOT NULL AUTO_INCREMENT PRIMARY KEY,
		seed 	   	   int(10) 		NOT NULL,
		start_time 	   timestamp(6),
        cave_generated boolean 		NOT NULL DEFAULT FALSE,
        ended		   boolean		NOT NULL DEFAULT FALSE
	);

	CREATE TABLE room (
		room_id 	  int(10) 	  NOT NULL AUTO_INCREMENT PRIMARY KEY,
        `name` 		  varchar(64) NOT NULL UNIQUE,
		height  	  int(10) 	  NOT NULL,
		width   	  int(10) 	  NOT NULL,
        minimum_depth int(10) 	  NOT NULL
	);

	CREATE TABLE room_instance (
		room_instance_id bigint(19) NOT NULL AUTO_INCREMENT PRIMARY KEY,
		room_id 		 int(10)    NOT NULL,
		game_id 		 int(10),
		depth 			 int(10)    NOT NULL,
		CONSTRAINT fk_room_instance_room FOREIGN KEY (room_id) REFERENCES room (room_id),
		CONSTRAINT fk_room_instance_game FOREIGN KEY (game_id) REFERENCES game (game_id) ON DELETE CASCADE
	);

	CREATE TABLE room_doorway (
		room_id    int(10) NOT NULL,
		position_x int(10) NOT NULL,
		position_y int(10) NOT NULL,
		PRIMARY KEY (room_id, position_x, position_y),
		CONSTRAINT fk_room_doorway FOREIGN KEY (room_id) REFERENCES room(room_id) ON DELETE CASCADE
	);

	CREATE TABLE party (
		party_id	 	 	int(10)    NOT NULL AUTO_INCREMENT PRIMARY KEY,
		game_id 		 	int(10),
		room_instance_id 	bigint(19) NOT NULL,
        leader_character_id int(10),
        tick_count		 	bigint(19) NOT NULL DEFAULT 0,
		CONSTRAINT fk_party_game 		  FOREIGN KEY (game_id) 		 REFERENCES game (game_id) 					 ON DELETE CASCADE,
        CONSTRAINT fk_party_room_instance FOREIGN KEY (room_instance_id) REFERENCES room_instance (room_instance_id) ON DELETE CASCADE
	);

	CREATE TABLE player_character (
		player_character_id int(10)      NOT NULL AUTO_INCREMENT PRIMARY KEY,
		`name` 				varchar(64)  NOT NULL UNIQUE,
		health 				int(10) 	 NOT NULL,
		hue 				int(3) 		 NOT NULL,
		user_account_id 	bigint(19)   NOT NULL,
		party_id 			int(10),
        ready				bool		 NOT NULL DEFAULT FALSE,
		CONSTRAINT fk_player_character_user  FOREIGN KEY (user_account_id)  REFERENCES user_account (user_account_id) ON DELETE CASCADE,
		CONSTRAINT fk_player_character_party FOREIGN KEY (party_id) 		REFERENCES party (party_id)
	);

	-- Add party leader foreign key after player table is defined
	ALTER TABLE 	party
	ADD CONSTRAINT 	fk_party_leader
		FOREIGN KEY (leader_character_id)
		REFERENCES 	player_character(player_character_id)
		ON DELETE SET NULL;
    
	CREATE TABLE party_invite (
		party_invite_id 	 int(10)   AUTO_INCREMENT PRIMARY KEY,
		party_id 			 int(10)   NOT NULL,
		inviter_character_id int(10)   NOT NULL,
		invitee_character_id int(10)   NOT NULL,
		created_at 			 timestamp DEFAULT CURRENT_TIMESTAMP,
		CONSTRAINT fk_party_invite_party 		 FOREIGN KEY (party_id) 			REFERENCES party (party_id)						  ON DELETE CASCADE,
		CONSTRAINT fk_party_invite_inviter 		 FOREIGN KEY (inviter_character_id) REFERENCES player_character (player_character_id) ON DELETE CASCADE,
		CONSTRAINT fk_party_invite_invitee 		 FOREIGN KEY (invitee_character_id) REFERENCES player_character (player_character_id) ON DELETE CASCADE,
		-- don't allow duplicates
        CONSTRAINT uq_party_invite_party_invitee UNIQUE (party_id, invitee_character_id) 
    );

	CREATE TABLE party_scoreboard (
		party_id 			int(10) 	NOT NULL,
		player_character_id int(10) 	NOT NULL,
		player_name 		varchar(64) NOT NULL,
		score 				int(10) 	NOT NULL DEFAULT 0,
		PRIMARY KEY (party_id, player_character_id),
		CONSTRAINT fk_scoreboard_party 		  FOREIGN KEY (party_id) 			REFERENCES party (party_id) 					  ON DELETE CASCADE,
		CONSTRAINT fk_scoreboard_character_id FOREIGN KEY (player_character_id) REFERENCES player_character (player_character_id) ON DELETE CASCADE
	);

	CREATE TABLE inventory (
		inventory_id 		bigint(19)  NOT NULL AUTO_INCREMENT PRIMARY KEY,
		player_character_id int(10),
		`type` 		 		varchar(64) NOT NULL,
		CONSTRAINT fk_inventory_player_character FOREIGN KEY (player_character_id) REFERENCES player_character (player_character_id) ON DELETE CASCADE
	);

	CREATE TABLE structure (
		structure_id 	 int(10) 	  NOT NULL AUTO_INCREMENT PRIMARY KEY,
		`name` 		 	 varchar(64)  NOT NULL UNIQUE,
		`description`  	 varchar(255) NOT NULL,
		`type` 		 	 varchar(64)  NOT NULL
	);

	CREATE TABLE effect (
		effect_id 	  int(10) 	   NOT NULL AUTO_INCREMENT PRIMARY KEY,
		`name` 		  varchar(64)  NOT NULL UNIQUE,
		`description` varchar(255) NOT NULL,
		`type` 		  varchar(64)  NOT NULL,
		target_style  varchar(64)  NOT NULL,
		magnitude 	  int(10) 	   NOT NULL,
		`range` 	  int(10),
		duration 	  int(10)
	);

	CREATE TABLE npc (
		npc_id 		  int(10) 	   NOT NULL AUTO_INCREMENT PRIMARY KEY,
		`name` 		  varchar(64)  NOT NULL UNIQUE,
		`description` varchar(255) NOT NULL,
		`type` 		  varchar(64)  NOT NULL,
		effect_id     int(10),
		CONSTRAINT fk_npc_effect FOREIGN KEY (effect_id) REFERENCES effect (effect_id)
	);

	CREATE TABLE item (
		item_id 	  int(10) 	   NOT NULL AUTO_INCREMENT PRIMARY KEY,
		`name` 		  varchar(64)  NOT NULL UNIQUE,
		`description` varchar(255) NOT NULL,
        stack_size	  int(10) 	   NOT NULL DEFAULT 1,
		effect_id 	  int(10),
        point_value   int(10),
		`type` 		  ENUM("consumable", "quest", "coin", "key")  NOT NULL,
		CONSTRAINT fk_item_effect FOREIGN KEY (effect_id) REFERENCES effect (effect_id)
	);

	CREATE TABLE slot (
		slot_no 	 int(10) 	NOT NULL,
		inventory_id bigint(19) NOT NULL,
		item_id 	 int(10),
		quantity 	 int(10) 	NOT NULL,
		PRIMARY KEY (slot_no, inventory_id),
		CONSTRAINT fk_slot_inventory FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id) ON DELETE CASCADE,
		CONSTRAINT fk_slot_item 	 FOREIGN KEY (item_id) 		REFERENCES item (item_id)
	);

	CREATE TABLE spawn_table (
		spawn_table_id int(10) 	   NOT NULL AUTO_INCREMENT PRIMARY KEY,
		`name` 		   varchar(64) NOT NULL UNIQUE
	);

	CREATE TABLE tile (
		tile_id 	   int(10) 	   NOT NULL AUTO_INCREMENT PRIMARY KEY,
		`name` 		   varchar(64) NOT NULL UNIQUE,
		spawn_table_id int(10) 	   NOT NULL,
        -- make the symbol case sensitive by overwriting the collate
        symbol 		   char(1) 	   CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL UNIQUE, 
		CONSTRAINT fk_tile_spawn_table FOREIGN KEY (spawn_table_id) REFERENCES spawn_table (spawn_table_id)
	);

	CREATE TABLE tile_map_instance (
		tile_id    int(10) NOT NULL,
		room_id    int(10) NOT NULL,
		position_x int(10) NOT NULL,
		position_y int(10) NOT NULL,
		PRIMARY KEY (tile_id, room_id, position_x, position_y),
		CONSTRAINT fk_tile_map_instance_tile FOREIGN KEY (tile_id) REFERENCES tile (tile_id),
		CONSTRAINT fk_tile_map_instance_room FOREIGN KEY (room_id) REFERENCES room (room_id)
	);

	CREATE TABLE tile_game_instance (
		tile_instance_id bigint(19) NOT NULL AUTO_INCREMENT PRIMARY KEY,
		room_instance_id bigint(19) NOT NULL,
        tile_id 		 int(10) 	NOT NULL,
		position_x 		 int(5) 	NOT NULL,
		position_y 		 int(5) 	NOT NULL,
		CONSTRAINT fk_tile_game_instance_room_instance FOREIGN KEY (room_instance_id) REFERENCES room_instance (room_instance_id) ON DELETE CASCADE,
        CONSTRAINT fk_tile_game_instance_tile 		   FOREIGN KEY (tile_id) 		  REFERENCES tile (tile_id)
	);

	CREATE TABLE entity_instance (
		entity_instance_id 	bigint(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
		tile_instance_id   	bigint(19) NOT NULL,
		npc_id 			   	int(10),
		item_id 		   	int(10),
		quantity 		   	int(10),
		player_character_id int(10),
		structure_id 		int(10),
        inventory_id		bigint(19),
        destination_id		bigint(19),
		CONSTRAINT fk_entity_instance_tile_game_instance FOREIGN KEY (tile_instance_id)    REFERENCES tile_game_instance (tile_instance_id)  ON DELETE CASCADE,
		CONSTRAINT fk_entity_instance_npc 				 FOREIGN KEY (npc_id) 			   REFERENCES npc (npc_id),
		CONSTRAINT fk_entity_instance_item 				 FOREIGN KEY (item_id) 			   REFERENCES item (item_id),
		CONSTRAINT fk_entity_instance_player_character 	 FOREIGN KEY (player_character_id) REFERENCES player_character (player_character_id) ON DELETE CASCADE,
		CONSTRAINT fk_entity_instance_structure 		 FOREIGN KEY (structure_id) 	   REFERENCES structure (structure_id),
        CONSTRAINT fk_entity_instance_inventory		 	 FOREIGN KEY (inventory_id) 	   REFERENCES inventory (inventory_id),
        CONSTRAINT fk_entity_instance_destination		 FOREIGN KEY (destination_id) 	   REFERENCES room_instance (room_instance_id) 		 ON DELETE CASCADE
	);

	CREATE TABLE spawn_table_entry (
		spawn_table_entry_id int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
		spawn_table_id       int(10) NOT NULL,
		structure_id         int(10),
		npc_id               int(10),
		item_id              int(10),
        quantity			 int(10) DEFAULT 1,
		weight               int(10) NOT NULL DEFAULT 1,
	
		CONSTRAINT fk_spawn_table_entry_spawn_table FOREIGN KEY (spawn_table_id) REFERENCES spawn_table (spawn_table_id),
		CONSTRAINT fk_spawn_table_entry_structure 	FOREIGN KEY (structure_id) 	 REFERENCES structure (structure_id),
		CONSTRAINT fk_spawn_table_entry_npc 		FOREIGN KEY (npc_id) 		 REFERENCES npc (npc_id),
		CONSTRAINT fk_spawn_table_entry_item 		FOREIGN KEY (item_id) 	 	 REFERENCES item (item_id),
		
        -- validate one or no entity definition per entry
		CONSTRAINT chk_spawn_table_entry_one_entity
			CHECK (
				(structure_id IS NOT NULL) +
				(npc_id IS NOT NULL) +
				(item_id IS NOT NULL) IN (0, 1)
			),

		CONSTRAINT chk_spawn_table_entry_weight
			CHECK (weight > 0)
	);

	CREATE TABLE shop_item (
		shop_item_id int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
		structure_id int(10) NOT NULL,
		item_id 	 int(10) NOT NULL,
		quantity 	 int(10),
		CONSTRAINT fk_shop_item_structure FOREIGN KEY (structure_id) REFERENCES structure (structure_id),
		CONSTRAINT fk_shop_item_item 	  FOREIGN KEY (item_id) 	 REFERENCES item (item_id)
	);

	CREATE TABLE shop_item_cost (
		shop_item_cost_id int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
		shop_item_id 	  int(10) NOT NULL,
		item_id 		  int(10) NOT NULL,
		quantity 		  int(10) NOT NULL,
		CONSTRAINT fk_shop_item_cost_shop_item FOREIGN KEY (shop_item_id) REFERENCES shop_item (shop_item_id),
		CONSTRAINT fk_shop_item_cost_item 	   FOREIGN KEY (item_id) 	  REFERENCES item (item_id)
	);

	CREATE TABLE message (
		message_id 			  int(10) 	   NOT NULL AUTO_INCREMENT PRIMARY KEY,
        party_id			  int(10)	   NOT NULL,
		sender_character_id   int(10) 	   NOT NULL,
		contents 			  varchar(255) NOT NULL,
		sent_at		  	  	  timestamp(6) NOT NULL DEFAULT current_timestamp(6),
		CONSTRAINT fk_message_sender   FOREIGN KEY (sender_character_id)   REFERENCES player_character (player_character_id) ON DELETE CASCADE
	);

	CREATE TABLE entity_effect (
		entity_instance_id bigint(10) NOT NULL,
		effect_id 		   int(10) NOT NULL,
		start_time 		   timestamp(6) NOT NULL,
		PRIMARY KEY (entity_instance_id, effect_id, start_time),
		CONSTRAINT fk_entity_effect_instance FOREIGN KEY (entity_instance_id) REFERENCES entity_instance (entity_instance_id) ON DELETE CASCADE,
		CONSTRAINT fk_entity_effect_effect   FOREIGN KEY (effect_id) 		  REFERENCES effect (effect_id)
	);
END //

-- populate game data
DELIMITER //
DROP PROCEDURE IF EXISTS populate_game_data //
CREATE PROCEDURE populate_game_data()
BEGIN
	-- admin account
    INSERT INTO user_account(email, `password`, `role`) VALUES
    ("admin", "Admin123", "admin");
	-- ITEMS
    INSERT INTO item (`name`, `type`, `effect_id`, stack_size, point_value, `description`) VALUES
    -- coins
    ("Coin", "coin", NULL, 999999, 1, "Golden currency used to purchase goods."),
    -- keys
    ("Key",  "key", NULL, 5, 10, "A mysteriously pristine key"),
    -- gems
    ('Brilliant Teleport Gem', 	'consumable', NULL, 3, 50, 'Teleports the caster to a specific tile anywhere in the room.'),
    ('Brilliant Fireball Gem', 	'consumable', NULL, 3, 50, 'Launches a fireball at a specific tile anywhere in the room.'),
    ('Radiant Fireball Gem', 	'consumable', NULL, 3, 50, 'Casts fireball across the eight tiles surrounding the caster.'),
    ('Brilliant Healing Gem', 	'consumable', NULL, 3, 50, 'Restores the health of a single target anywhere in the room.');


    -- STRUCTURES
    INSERT INTO structure(`name`,`type`, description ) VALUES
    -- Lobby structures
    ("shop", 	 "shop", 	 "The shopkeeper looms over his wares, eager to make a deal."),
    ("stash", 	 "stash", 	 "Your enchanted chest, capable of storing many things."),
    ("wardrobe", "wardrobe", "A wardrobe containing an endless supply of robes and dyes."),
    ("rock",	 "obstacle", "A large rock stands in your way."),
    -- Cave Structures
    ("doorway",	 "doorway",  "A passage connecting this room to another.");
    
    
    -- NPCs
    INSERT INTO npc (`name`, `description`, `type`, effect_id) VALUES
    ("rat", "A small rodent you'd rather not step on", "passive", NULL);
    
    	-- Spawn tables
    INSERT INTO spawn_table (`name`) VALUES
    ("empty"),
    ("shop"),
    ("stash"),
    ("wardrobe"),
    ("rock"),
    ("rock_50"),
    ("coins_few"),
    ("loot1"),
    ("rat");
    
    -- Spawn tables entries
    
    -- shop
    INSERT INTO spawn_table_entry (spawn_table_id, structure_id, npc_id, item_id, quantity, weight) VALUES
    ((SELECT spawn_table_id FROM spawn_table WHERE `name` = "shop"),
		(SELECT structure_id   FROM structure   WHERE `name` = "shop"),
		NULL, NULL, NULL, 1),
	
    -- stash
	((SELECT spawn_table_id FROM spawn_table WHERE `name` = "stash"),
		(SELECT structure_id   FROM structure   WHERE `name` = "stash"),
		NULL, NULL, NULL, 1),
	
    -- wardrobe
	((SELECT spawn_table_id FROM spawn_table WHERE `name` = "wardrobe"),
		(SELECT structure_id   FROM structure   WHERE `name` = "wardrobe"),
		NULL, NULL, NULL, 1),
	
    -- Rock
	((SELECT spawn_table_id FROM spawn_table WHERE `name` = "rock"),
		(SELECT structure_id   FROM structure   WHERE `name` = "rock"),
		NULL, NULL, NULL, 1),
        
	-- Rock 50
	((SELECT spawn_table_id FROM spawn_table WHERE `name` = "rock_50"),
		(SELECT structure_id   FROM structure   WHERE `name` = "rock"),
		NULL, NULL, NULL, 1),
	((SELECT spawn_table_id FROM spawn_table WHERE `name` = "rock_50"),
		NULL, NULL, NULL, NULL, 1),
        
	-- coins_few
    ((SELECT spawn_table_id FROM spawn_table WHERE `name` = "coins_few"),
		NULL, NULL, 
		(SELECT item_id FROM item WHERE `name` = "Coin"),
		1, 3),
	((SELECT spawn_table_id FROM spawn_table WHERE `name` = "coins_few"),
		NULL, NULL, 
		(SELECT item_id FROM item WHERE `name` = "Coin"),
		3, 2),
	((SELECT spawn_table_id FROM spawn_table WHERE `name` = "coins_few"),
		NULL, NULL, 
		(SELECT item_id FROM item WHERE `name` = "Coin"),
		50, 1),
	
    -- loot1
	((SELECT spawn_table_id FROM spawn_table WHERE `name` = "loot1"),
        NULL, NULL,
        (SELECT item_id FROM item WHERE `name` = "Brilliant Teleport Gem"),
        1, 1),
    ((SELECT spawn_table_id FROM spawn_table WHERE `name` = "loot1"),
        NULL, NULL,
        (SELECT item_id FROM item WHERE `name` = "Brilliant Fireball Gem"),
        1, 1),
    ((SELECT spawn_table_id FROM spawn_table WHERE `name` = "loot1"),
        NULL, NULL,
        (SELECT item_id FROM item WHERE `name` = "Radiant Fireball Gem"),
        1, 1),
    ((SELECT spawn_table_id FROM spawn_table WHERE `name` = "loot1"),
        NULL, NULL,
        (SELECT item_id FROM item WHERE `name` = "Brilliant Healing Gem"),
        1, 1),
        
	-- rat
	((SELECT spawn_table_id FROM spawn_table WHERE `name` = "rat"),
        NULL, 
        (SELECT npc_id FROM npc WHERE `name` = "rat"),
        NULL,
        1, 1);
        
    -- Tiles
    INSERT INTO tile (`name`, spawn_table_id, symbol) VALUES
    -- empty
    ("floor", 	 (SELECT spawn_table_id FROM spawn_table WHERE `name` = "empty"), 	 "."),
    -- structures
    -- lobby
    ("shop", 	 (SELECT spawn_table_id FROM spawn_table WHERE `name` = "shop"), 	 "S"),
    ("stash", 	 (SELECT spawn_table_id FROM spawn_table WHERE `name` = "stash"), 	 "H"),
    ("wardrobe", (SELECT spawn_table_id FROM spawn_table WHERE `name` = "wardrobe"), "W"),
    -- cave
    ("doorway", (SELECT spawn_table_id  FROM spawn_table WHERE `name` = "empty"), 	 "D"),
    -- objects
    ("rock", 	 (SELECT spawn_table_id FROM spawn_table WHERE `name` = "rock"), 	 "R"),
    ("rock_50",  (SELECT spawn_table_id FROM spawn_table WHERE `name` = "rock_50"),  "r"),
    -- items
    ("coins_few",(SELECT spawn_table_id FROM spawn_table WHERE `name` = "coins_few"),"c"),
    ("loot1",	 (SELECT spawn_table_id FROM spawn_table WHERE `name` = "loot1"),	 "1"),
	-- npcs
    ("rat",	 	 (SELECT spawn_table_id FROM spawn_table WHERE `name` = "rat"),	 	 "!");

    -- ROOMS
    INSERT INTO room (`name`, height, width, minimum_depth) VALUES
    ("lobby", 	   7, 9, 0),
    ("crossroads", 7, 9, 0);
    
-- call layout interpreter to populate room data for each room
-- NO INDENTATION ALLOWED!!!
CALL game_populate_room_layout(
"lobby",
"....D..rr
r.c......
........H
S........
........W
r........
Rr.r...Rr"
);
CALL game_populate_room_layout(
"crossroads",
"RRrr..rrr
r1rr.!..1
rrr....r.
.........
.....r...
r...1...1
Rr.rD..Rr"
);

END //

/*
 __    __       _______. _______ .______              ___       ______   ______   ______    __    __  .__   __. .___________.
|  |  |  |     /       ||   ____||   _  \            /   \     /      | /      | /  __  \  |  |  |  | |  \ |  | |           |
|  |  |  |    |   (----`|  |__   |  |_)  |          /  ^  \   |  ,----'|  ,----'|  |  |  | |  |  |  | |   \|  | `---|  |----`
|  |  |  |     \   \    |   __|  |      /          /  /_\  \  |  |     |  |     |  |  |  | |  |  |  | |  . `  |     |  |     
|  `--'  | .----)   |   |  |____ |  |\  \----.    /  _____  \ |  `----.|  `----.|  `--'  | |  `--'  | |  |\   |     |  |     
 \______/  |_______/    |_______|| _| `._____|   /__/     \__\ \______| \______| \______/   \______/  |__| \__|     |__|     
                                                                                                                                                                                                                                                                                                                      
*/

-- USER ACCOUNT --

-- 2. Player registration
-- Register New Account
-- account_register
DELIMITER //
DROP PROCEDURE IF EXISTS account_register //
CREATE PROCEDURE account_register ( 
	IN email_in 		  VARCHAR(64), 
	IN password_in 		  VARCHAR(64), 
	IN administrator_flag BOOL
)
BEGIN
	INSERT INTO user_account (email, `password`, `role`) 
    VALUES (
		email_in, 
        password_in, 
        IF(administrator_flag, "admin", "player")
	);
END //
DELIMITER ; 


-- 1. Player login, including lock out
-- Log into Account
-- account_login
DELIMITER //
DROP PROCEDURE IF EXISTS account_login //
CREATE PROCEDURE account_login(
    IN email_in VARCHAR(64), 
    IN password_in VARCHAR(64)
)
BEGIN
    -- account exists, locked
    -- block
    IF EXISTS (
        SELECT 1
        FROM user_account
        WHERE email = email_in
            AND lockout_time IS NOT NULL
            AND NOW(6) < lockout_time + INTERVAL 5 MINUTE
    ) THEN
        SELECT 'locked' AS login_result;

    -- account exists, correct password
    ELSEIF EXISTS (
        SELECT 1
        FROM user_account
        WHERE email = email_in
            AND `password` = password_in
    ) THEN

        -- reset the failed login counter and lockout time
        UPDATE user_account
        SET failed_logins = 0,
            lockout_time = NULL
        WHERE email = email_in;

        SELECT user_account_id, email, `password`, `role`
        FROM user_account
        WHERE email = email_in;

    ELSE

        -- Incorrect credentials: increment the counter.
        UPDATE user_account
        SET failed_logins = failed_logins + 1
        WHERE email = email_in;

        -- Lock account on fifth failure.
        IF EXISTS (
            SELECT 1
            FROM user_account
            WHERE email = email_in
                AND failed_logins >= 5
        ) THEN
            CALL account_lockout(email_in);
            SELECT 'locked' AS login_result;
        ELSE
            SELECT 'invalid' AS login_result;
        END IF;

    END IF;


END //
DELIMITER ;



-- Lock out Account
-- account_lockout
DELIMITER //
DROP PROCEDURE IF EXISTS account_lockout //
CREATE PROCEDURE account_lockout (IN email_in VARCHAR(64))
BEGIN
	UPDATE user_account
    SET lockout_time = now(6)
    WHERE email = email_in;
END //
DELIMITER ;


-- 11. Update data of a player.
-- Update Account Email
-- account_update_email
DELIMITER //
DROP PROCEDURE IF EXISTS account_update_email //
CREATE PROCEDURE account_update_email (
	IN email_old VARCHAR(64), 
    IN email_new VARCHAR(64)
)
BEGIN
	UPDATE user_account
    SET email = email_new
    WHERE email = email_old;
END //
DELIMITER ;



-- Update Account Password
-- account_update_password
DELIMITER //
DROP PROCEDURE IF EXISTS account_update_password //
CREATE PROCEDURE account_update_password (IN email_in VARCHAR(64), IN password_new VARCHAR(64))
BEGIN
	UPDATE user_account
    SET `password` = password_new
    WHERE email = email_in;
END //
DELIMITER ;


-- 12. Delete a player.
-- Delete Account
-- account_delete
DELIMITER //
DROP PROCEDURE IF EXISTS account_delete //
CREATE PROCEDURE account_delete ( 
	IN email_in VARCHAR(64)
)
BEGIN
	DELETE FROM user_account
    WHERE email = email_in;
END //
DELIMITER ; 


/*
  ______  __    __       ___      .______          ___       ______ .___________. _______ .______      
 /      ||  |  |  |     /   \     |   _  \        /   \     /      ||           ||   ____||   _  \     
|  ,----'|  |__|  |    /  ^  \    |  |_)  |      /  ^  \   |  ,----'`---|  |----`|  |__   |  |_)  |    
|  |     |   __   |   /  /_\  \   |      /      /  /_\  \  |  |         |  |     |   __|  |      /     
|  `----.|  |  |  |  /  _____  \  |  |\  \----./  _____  \ |  `----.    |  |     |  |____ |  |\  \----.
 \______||__|  |__| /__/     \__\ | _| `._____/__/     \__\ \______|    |__|     |_______|| _| `._____|
*/

-- CHARACTER MANAGEMENT --

-- Get character data
-- character_get
DELIMITER //
DROP PROCEDURE IF EXISTS character_get //
CREATE PROCEDURE character_get(IN user_account_id_in BIGINT)
BEGIN
    SELECT player_character_id, `name`, health, hue
    FROM player_character
    WHERE user_account_id = user_account_id_in
    ORDER BY `name`;
END //
DELIMITER ;

-- get specific character id from name
-- character_find_by_name
DELIMITER //
DROP PROCEDURE IF EXISTS character_find_by_name //
CREATE PROCEDURE character_find_by_name (
    IN character_name_in VARCHAR(100)
)
BEGIN
    SELECT player_character_id
    FROM player_character
    WHERE `name` = character_name_in
    LIMIT 1;
END //
DELIMITER ;

-- Create Character
-- character_create
DELIMITER //
DROP PROCEDURE IF EXISTS character_create //
CREATE PROCEDURE character_create ( 
	IN name_in 			  VARCHAR(64), -- character name
    IN user_account_id_in BIGINT	   -- account id
)
BEGIN
	DECLARE character_id_new INT;
    
    -- create the character
    INSERT INTO player_character (
		`name`,
        health,
        hue,
        user_account_id
	)
    VALUES (
		name_in,
        5,
        floor(rand() * 256), -- random hue
        user_account_id_in
	);
    
	-- get the character id from the last insert
	SET character_id_new = last_insert_id();
    
    -- Create the inventories
    INSERT INTO inventory (
		player_character_id,
        `type`
	)
    VALUES
		(character_id_new, "carried"),
        (character_id_new, "stash");
END //
DELIMITER ; 



-- Play as Character 
-- character_play
DELIMITER //
DROP PROCEDURE IF EXISTS character_play //
CREATE PROCEDURE character_play (
	IN player_character_id_in INT
)
BEGIN
    DECLARE new_party_id INT;
	DECLARE new_room_instance_id BIGINT;
    DECLARE new_tile_instance_id BIGINT;

    -- Create a party and lobby
    CALL party_create(
		player_character_id_in,
        new_party_id
    );

    -- Get the lobby created for this party
    SELECT room_instance_id
    INTO new_room_instance_id
    FROM party
    WHERE party_id = new_party_id;

    -- get the character's starting tile
    SELECT tile_instance_id
    INTO new_tile_instance_id
    FROM tile_game_instance
	WHERE room_instance_id = new_room_instance_id
		AND position_x = 4
		AND position_y = 3;
    
    -- Place the character in the lobby
    INSERT INTO entity_instance (
        tile_instance_id,
        player_character_id
    )
    VALUES (
        new_tile_instance_id,
        player_character_id_in
    );
END //
DELIMITER ; 



-- Delete Character
-- character_delete
DELIMITER //
DROP PROCEDURE IF EXISTS character_delete //
CREATE PROCEDURE character_delete (
    IN player_character_id_in INT
)
BEGIN
    -- Remove the character from any room
    DELETE FROM entity_instance
    WHERE player_character_id = player_character_id_in;

    -- Delete the character
    DELETE FROM player_character
    WHERE player_character_id = player_character_id_in;
END //
DELIMITER ;



-- Edit Character Colour
-- character_update_colour
DELIMITER //
DROP PROCEDURE IF EXISTS character_update_colour //
CREATE PROCEDURE character_update_colour (
    IN player_character_id_in INT,
    IN hue_in INT
)
BEGIN
    UPDATE player_character
    SET hue = hue_in
    WHERE player_character_id = player_character_id_in;
END //
DELIMITER ;



-- Log Out Character
-- character_logout
DELIMITER //
DROP PROCEDURE IF EXISTS character_logout //
CREATE PROCEDURE character_logout (
    IN player_character_id_in INT
)
BEGIN
    DECLARE old_party_id INT DEFAULT NULL;
    DECLARE old_room_id BIGINT DEFAULT NULL;
    DECLARE old_game_id INT DEFAULT NULL;

    -- Find the character's current party.
    SELECT party_id
    INTO old_party_id
    FROM player_character
    WHERE player_character_id = player_character_id_in;

    IF old_party_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Character is not in a party';
    END IF;

    -- Get the party's room and game.
    SELECT
        p.room_instance_id,
        COALESCE(p.game_id, ri.game_id)
    INTO old_room_id, old_game_id
    FROM party AS p
    JOIN room_instance AS ri
        ON ri.room_instance_id = p.room_instance_id
    WHERE p.party_id = old_party_id;

    -- Remove the character from the world.
    DELETE FROM entity_instance
    WHERE player_character_id = player_character_id_in;

    -- Remove party membership without creating another lobby.
    UPDATE player_character
    SET party_id = NULL,
        ready = FALSE
    WHERE player_character_id = player_character_id_in;
    
	-- Transfer leadership if the departing character was leader.
	UPDATE party
	SET leader_character_id = (
		SELECT 	 player_character_id
		FROM 	 player_character
		WHERE 	 party_id = old_party_id
		ORDER BY player_character_id
		LIMIT 	 1
	)
	WHERE party_id = old_party_id
		AND leader_character_id = player_character_id_in;
    
    -- Delete the party and lobby if nobody remains.
    IF NOT EXISTS (
        SELECT 1
        FROM player_character
        WHERE party_id = old_party_id
    ) THEN
        DELETE FROM party
        WHERE party_id = old_party_id;

        DELETE FROM room_instance
        WHERE room_instance_id = old_room_id;

        IF old_game_id IS NOT NULL THEN
            DELETE FROM game
            WHERE game_id = old_game_id;
        END IF;
    END IF;
END //
DELIMITER ;

/*
.______      ___      .______     .___________.____    ____ 
|   _  \    /   \     |   _  \    |           |\   \  /   / 
|  |_)  |  /  ^  \    |  |_)  |   `---|  |----` \   \/   /  
|   ___/  /  /_\  \   |      /        |  |       \_    _/   
|  |     /  _____  \  |  |\  \----.   |  |         |  |     
| _|    /__/     \__\ | _| `._____|   |__|         |__|     
                                                            
*/

-- PARTY --

-- get party data
-- party_get
DELIMITER //
DROP PROCEDURE IF EXISTS party_get //
CREATE PROCEDURE party_get (
    IN player_character_id_in INT
)
BEGIN
    SELECT
        p.party_id,
        p.leader_character_id,
        p.game_id,
        p.room_instance_id,
        p.tick_count,
        pc.player_character_id,
        pc.`name` AS player_name,
        pc.health,
        pc.hue,
        pc.ready,
        pc.user_account_id
    FROM player_character pc
    JOIN party p
        ON p.party_id = pc.party_id
    WHERE p.party_id = (
        SELECT party_id
        FROM player_character
        WHERE player_character_id = player_character_id_in
    )
    ORDER BY pc.player_character_id;
END //
DELIMITER ;

-- Get invitations
-- party_invites_get
DELIMITER //
DROP PROCEDURE IF EXISTS party_invites_get //
CREATE PROCEDURE party_invites_get (
    IN player_character_id_in INT
)
BEGIN
    SELECT
        pi.party_id,
        pi.inviter_character_id,
        inviter.`name` AS inviter_name,
        invitee.`name` AS invitee_name
    FROM party_invite pi
    JOIN player_character inviter
        ON inviter.player_character_id = pi.inviter_character_id
    JOIN player_character invitee
        ON invitee.player_character_id = pi.invitee_character_id
    WHERE pi.invitee_character_id = player_character_id_in
    ORDER BY pi.party_id;
END //
DELIMITER ;


-- Create party
-- party_create
DELIMITER //
DROP PROCEDURE IF EXISTS party_create //
CREATE PROCEDURE party_create (
    IN  player_character_id_in INT,
    OUT party_id_out 		   INT
)
BEGIN
	DECLARE lobby_room_instance_id BIGINT;
    
	-- Generate lobby instance for this party
    CALL game_generate_room('lobby', NULL, 0, lobby_room_instance_id);

    -- Create the party linked to its lobby
    INSERT INTO party (game_id, room_instance_id) 
    VALUES (NULL, lobby_room_instance_id);

    -- Save the new party ID
    SET party_id_out = last_insert_id();
    
	-- Set the character as party leader
	UPDATE party
	SET leader_character_id = player_character_id_in
	WHERE party_id = party_id_out;
    
    -- Assign the character to the new party
    UPDATE player_character
    SET party_id = party_id_out,
        ready 	 = FALSE
    WHERE player_character_id = player_character_id_in;
END //
DELIMITER ;



-- Invite Player
-- party_invite
DELIMITER //
DROP PROCEDURE IF EXISTS party_invite //
CREATE PROCEDURE party_invite (
    IN party_id_in 			   INT,
    IN inviter_character_id_in INT,
	IN invitee_character_id_in INT
)
BEGIN
    INSERT INTO party_invite (
        party_id,
        inviter_character_id,
        invitee_character_id
    )
    SELECT
        party_id_in,
        inviter_character_id_in,
        invitee_character_id_in
    FROM player_character AS inviter
    JOIN player_character AS invitee
        ON invitee.player_character_id = invitee_character_id_in
    WHERE inviter.player_character_id = inviter_character_id_in
		AND inviter.party_id = party_id_in
		AND inviter_character_id_in <> invitee_character_id_in
	-- handle duplicate invites
    ON DUPLICATE KEY UPDATE
        inviter_character_id = VALUES(inviter_character_id);
END //
DELIMITER ;


-- 10. Add new players. 
-- Add Player to Party
-- party_add_player
-- NEED TRANSACTION
DELIMITER //
DROP PROCEDURE IF EXISTS party_add_player //
CREATE PROCEDURE party_add_player (
	IN party_id_in INT,
    IN player_character_id_in INT
)
BEGIN
    DECLARE old_party_id INT DEFAULT NULL;
    DECLARE old_room_id  BIGINT DEFAULT NULL;
    DECLARE old_game_id  INT DEFAULT NULL;
    DECLARE new_room_id  BIGINT DEFAULT NULL;

    DECLARE character_entity_id BIGINT DEFAULT NULL;
    DECLARE current_tile_id 	BIGINT DEFAULT NULL;
    DECLARE destination_tile_id BIGINT DEFAULT NULL;
    DECLARE current_room_name 	VARCHAR(64) DEFAULT NULL;
    DECLARE invitation_exists 	INT DEFAULT 0;

	-- Check that the destination party exists.
    IF NOT EXISTS (
        SELECT 1
        FROM party
        WHERE party_id = party_id_in
    ) THEN
		-- Throw error. need to handle with transaction later
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Destination party does not exist';
    END IF;
    
    -- Check that the character has an invitation.
    SELECT count(*)
    INTO invitation_exists
    FROM party_invite
    WHERE party_id = party_id_in
		AND invitee_character_id = player_character_id_in;

    IF invitation_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No invitation found for this character';
    END IF;
    
    -- Get the character's current party.
    SELECT party_id
    INTO old_party_id
    FROM player_character
    WHERE player_character_id = player_character_id_in;
	
    IF old_party_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Character does not belong to a party';
    END IF;
    
    -- Get the old room, game, and room name.
    SELECT
        p.room_instance_id,
        coalesce(p.game_id, ri.game_id),
        r.name
    INTO
        old_room_id,
        old_game_id,
        current_room_name
    FROM party AS p
    JOIN room_instance AS ri
        ON ri.room_instance_id = p.room_instance_id
    JOIN room AS r
        ON r.room_id = ri.room_id
    WHERE p.party_id = old_party_id;
    
    -- Find the character's current entity and tile.
    SELECT
        entity_instance_id,
        tile_instance_id
    INTO
        character_entity_id,
        current_tile_id
    FROM entity_instance
    WHERE player_character_id = player_character_id_in
    LIMIT 1;

    IF character_entity_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Character entity was not found in a room';
    END IF;
    
	-- Get the destination room.
    SELECT room_instance_id
    INTO new_room_id
    FROM party
    WHERE party_id = party_id_in;
    
    -- Find a tile in the lobby, preferring position (4,3).
    SELECT tile_instance_id
    INTO destination_tile_id
    FROM tile_game_instance
    WHERE room_instance_id = new_room_id
    ORDER BY
		(position_x = 4 AND position_y = 3) DESC,
        tile_instance_id
    LIMIT 1;
    
    IF destination_tile_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Destination room has no tiles';
    END IF;

    -- Inventory handling placeholders.
    IF lower(current_room_name) = 'lobby' THEN
		 -- TODO: Leaving a lobby: keep carried inventory unchanged.
         DO 0; -- this is a fun placeholder
    ELSE
		DO 0;
        -- TODO: Leaving a cave: call the future procedure to drop
        -- carried inventory onto the ground at current_tile_id.
        -- Stash inventory needs to persist.
    END IF;
    
    -- Remove the character from their old party.
    CALL party_remove_player(
        player_character_id_in,
        party_id_in
    );
    
    -- Move the character entity into the destination room.
    UPDATE entity_instance
    SET tile_instance_id = destination_tile_id
    WHERE entity_instance_id = character_entity_id;

    -- Update party membership and reset readiness.
    UPDATE player_character
    SET party_id = party_id_in,
		ready = FALSE
    WHERE player_character_id = player_character_id_in;

    -- Remove the accepted invitation.
    DELETE FROM party_invite
    WHERE party_id = party_id_in
	AND invitee_character_id = player_character_id_in;
    
    -- Clean up the old party if it is now empty.
IF old_party_id <> party_id_in
	AND NOT EXISTS (
       SELECT 1
       FROM player_character
       WHERE party_id = old_party_id
	)
	THEN
		DELETE FROM party
		WHERE party_id = old_party_id;

		-- Delete the old room and its tiles/entities.
		DELETE FROM room_instance
		WHERE room_instance_id = old_room_id;

		-- Delete the old game if one exists.
		IF old_game_id IS NOT NULL THEN
			DELETE FROM game
			WHERE game_id = old_game_id;
		END IF;
	END IF;
END //
DELIMITER ;



-- Delete Party
-- party_delete
DELIMITER //
DROP PROCEDURE IF EXISTS party_delete //
CREATE PROCEDURE party_delete (
    IN party_id_in INT
)
BEGIN
    DECLARE old_game_id INT;
    DECLARE old_room_instance_id BIGINT;

    -- Only delete parties with no players
    IF NOT EXISTS (
        SELECT 1
        FROM player_character
        WHERE party_id = party_id_in
    ) THEN

        -- Get the party's game and lobby
        SELECT game_id, room_instance_id
        INTO old_game_id, old_room_instance_id
        FROM party
        WHERE party_id = party_id_in;

        -- Delete the party
        DELETE FROM party
        WHERE party_id = party_id_in;

        -- Delete the lobby
        DELETE FROM room_instance
        WHERE room_instance_id = old_room_instance_id;

        -- Delete the game
        IF old_game_id IS NOT NULL THEN
            DELETE FROM game
            WHERE game_id = old_game_id;
        END IF;

    END IF;
END //
DELIMITER ;



-- Remove Player from Party
-- party_remove_player
DELIMITER //
DROP PROCEDURE IF EXISTS party_remove_player //
CREATE PROCEDURE party_remove_player (
    IN player_character_id_in INT,
    IN destination_party_id_in INT
)
BEGIN
	DECLARE old_party_empty   BOOLEAN DEFAULT FALSE;
	DECLARE old_party_id 	  INT DEFAULT NULL;
    DECLARE old_room_id 	  BIGINT DEFAULT NULL;
    DECLARE old_game_id 	  INT DEFAULT NULL;
    DECLARE current_room_name VARCHAR(64) DEFAULT NULL;
    
	DECLARE character_entity_id BIGINT DEFAULT NULL;
	DECLARE current_tile_id 	BIGINT DEFAULT NULL;
    
    -- Check that the character exists.
    IF NOT EXISTS (
        SELECT 1
        FROM player_character
        WHERE player_character_id = player_character_id_in
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Character does not exist';
    END IF;

    -- Get the character's current party.
    SELECT party_id
    INTO old_party_id
    FROM player_character
    WHERE player_character_id = player_character_id_in;

    IF old_party_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Character does not belong to a party';
    END IF;

	-- Check the destination party, if one was provided.
	IF destination_party_id_in IS NOT NULL
	   AND NOT EXISTS (
		   SELECT 1
		   FROM party
		   WHERE party_id = destination_party_id_in
	   )
	THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Destination party does not exist';
	END IF;

    -- Get the current room, game, and room name.
    SELECT
        p.room_instance_id,
        coalesce(p.game_id, ri.game_id),
        r.`name`
    INTO
        old_room_id,
        old_game_id,
        current_room_name
    FROM party AS p
    JOIN room_instance AS ri
        ON ri.room_instance_id = p.room_instance_id
    JOIN room AS r
        ON r.room_id = ri.room_id
    WHERE p.party_id = old_party_id;
    
    -- Find the character's entity and current tile.
	SELECT
		entity_instance_id,
		tile_instance_id
	INTO
		character_entity_id,
		current_tile_id
	FROM entity_instance
	WHERE player_character_id = player_character_id_in
	LIMIT 1;

	IF character_entity_id IS NULL THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Character entity was not found in a room';
	END IF;
    
    -- Debug stats
    /*
	SELECT
		player_character_id_in AS character_id,
		old_party_id 		   AS old_party_id,
		old_room_id 		   AS old_room_id,
		old_game_id 		   AS old_game_id,
		current_room_name 	   AS current_room_name,
		character_entity_id    AS character_entity_id,
		current_tile_id 	   AS current_tile_id;
	*/
    
    -- Remove the old entity only when starting a new solo lobby.
	IF destination_party_id_in IS NULL THEN
		DELETE FROM entity_instance
		WHERE player_character_id = player_character_id_in;
	END IF;
    
	-- Remove the character from their current party.
	UPDATE player_character
	SET party_id = NULL,
		ready = FALSE
	WHERE player_character_id = player_character_id_in;
    
    -- Transfer leadership if the leaving character was leader.
	UPDATE party
	SET leader_character_id = (
		SELECT player_character_id
		FROM player_character
		WHERE party_id = old_party_id
		ORDER BY player_character_id
		LIMIT 1
	)
	WHERE party_id = old_party_id
		AND leader_character_id = player_character_id_in;
    
    -- Check whether the old party has any remaining characters.
	SELECT NOT EXISTS (
		SELECT 1
		FROM player_character
		WHERE party_id = old_party_id
	)
	INTO old_party_empty;
    
    -- Clean up old party if empty.
	IF old_party_empty THEN
		DELETE FROM party WHERE party_id = old_party_id;

		-- Keep the old room temporarily when joining another party.
		IF destination_party_id_in IS NULL THEN
			DELETE FROM room_instance
			WHERE room_instance_id = old_room_id;

			IF old_game_id IS NOT NULL THEN
				DELETE FROM game WHERE game_id = old_game_id;
			END IF;
		END IF;
	END IF;
    
    -- If there is no destination, start a new solo lobby.
    IF destination_party_id_in IS NULL THEN
        CALL character_play(player_character_id_in);
    END IF;
END //
DELIMITER ;



-- Toggle player Ready
-- party_toggle_ready
DELIMITER //
DROP PROCEDURE IF EXISTS party_toggle_ready //
CREATE PROCEDURE party_toggle_ready (
    IN player_character_id_in INT
)
BEGIN
    DECLARE party_id_out INT;
    DECLARE ready_status BOOLEAN;
    DECLARE unready_count INT;

    -- Get the character's party and current ready status.
    SELECT party_id, ready
    INTO party_id_out, ready_status
    FROM player_character
    WHERE player_character_id = player_character_id_in;

    IF party_id_out IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Character is not in a party';
    END IF;

    -- Toggle the character's ready status.
    UPDATE player_character
    SET ready = NOT ready
    WHERE player_character_id = player_character_id_in;

    -- Check whether everyone in the party is ready.
    SELECT count(*)
    INTO unready_count
    FROM player_character
    WHERE party_id = party_id_out
      AND ready = FALSE;

    -- Start the game only when everyone is ready.
    IF unready_count = 0 THEN
        CALL game_start(party_id_out);
    END IF;
END //
DELIMITER ;



-- Start Game
-- party_start_game
DELIMITER //
DROP PROCEDURE IF EXISTS game_start //
CREATE PROCEDURE game_start (
    IN party_id_in INT
)
BEGIN
    DECLARE game_id_new INT;
    DECLARE lobby_room_id BIGINT;
    DECLARE unready_count INT;
    DECLARE party_game_id INT;

    -- Get the party's lobby and current game.
    SELECT room_instance_id, game_id
    INTO lobby_room_id, party_game_id
    FROM party
    WHERE party_id = party_id_in;

    -- Prevent starting the same party twice.
    IF party_game_id IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'This party already has a game';
    END IF;

    -- Confirm that every party member is ready.
    SELECT count(*)
    INTO unready_count
    FROM player_character
    WHERE party_id = party_id_in
      AND ready = FALSE;

    IF unready_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Not all party members are ready';
    END IF;

    -- Create the game with a start time 10 seconds ahead. now 3 seconds for testing.
    INSERT INTO game (
        seed,
        start_time
    )
    VALUES (
        floor(rand() * 2147483647),
        CURRENT_TIMESTAMP + INTERVAL 3 SECOND
    );

    SET game_id_new = last_insert_id();

    -- Assign the new game to the party.
    UPDATE party
    SET game_id = game_id_new
    WHERE party_id = party_id_in;
    
    -- unready all party members
    UPDATE player_character
	SET ready = FALSE
	WHERE party_id = party_id_in;
END //

DELIMITER ;



/*
  ______   ______   .___  ___. .___  ___.  __    __  .__   __.  __    ______     ___   .___________. __    ______   .__   __. 
 /      | /  __  \  |   \/   | |   \/   | |  |  |  | |  \ |  | |  |  /      |   /   \  |           ||  |  /  __  \  |  \ |  | 
|  ,----'|  |  |  | |  \  /  | |  \  /  | |  |  |  | |   \|  | |  | |  ,----'  /  ^  \ `---|  |----`|  | |  |  |  | |   \|  | 
|  |     |  |  |  | |  |\/|  | |  |\/|  | |  |  |  | |  . `  | |  | |  |      /  /_\  \    |  |     |  | |  |  |  | |  . `  | 
|  `----.|  `--'  | |  |  |  | |  |  |  | |  `--'  | |  |\   | |  | |  `----./  _____  \   |  |     |  | |  `--'  | |  |\   | 
 \______| \______/  |__|  |__| |__|  |__|  \______/  |__| \__| |__|  \______/__/     \__\  |__|     |__|  \______/  |__| \__| 
                                                                                                                              
*/

-- COMMUNICATION --
-- Send message
-- party_send_message
DELIMITER //
DROP PROCEDURE IF EXISTS party_send_message //
CREATE PROCEDURE party_send_message (
    IN player_character_id_in INT,
    IN contents_in VARCHAR(255)
)
BEGIN
	DECLARE current_party_id INT DEFAULT NULL;

    SELECT party_id
    INTO current_party_id
    FROM player_character
    WHERE player_character_id = player_character_id_in;

    IF current_party_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Character does not belong to a party';
    END IF;

    IF contents_in IS NULL OR trim(contents_in) = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Message cannot be empty';
    END IF;

    INSERT INTO message (
        party_id,
        sender_character_id,
        contents
    )
    VALUES (
        current_party_id,
        player_character_id_in,
        contents_in
    );
END //
DELIMITER ; 

-- Receive message
-- party_get_messages
DELIMITER //
DROP PROCEDURE IF EXISTS party_get_messages //
CREATE PROCEDURE party_get_messages (
	IN player_character_id_in INT
)
BEGIN
	DECLARE current_party_id INT DEFAULT NULL;
    
    SELECT party_id
    INTO current_party_id
    FROM player_character
    WHERE player_character_id = player_character_id_in;

    SELECT
        m.message_id,
        pc.name AS sender_name,
        m.contents,
        m.sent_at
    FROM message AS m
    JOIN player_character AS pc
        ON pc.player_character_id = m.sender_character_id
    WHERE m.party_id = current_party_id
    ORDER BY m.sent_at ASC, m.message_id ASC;
END //
DELIMITER ; 
/*
  _______      ___      .___  ___.  _______ .______    __          ___   ____    ____ 
 /  _____|    /   \     |   \/   | |   ____||   _  \  |  |        /   \  \   \  /   / 
|  |  __     /  ^  \    |  \  /  | |  |__   |  |_)  | |  |       /  ^  \  \   \/   /  
|  | |_ |   /  /_\  \   |  |\/|  | |   __|  |   ___/  |  |      /  /_\  \  \_    _/   
|  |__| |  /  _____  \  |  |  |  | |  |____ |  |      |  `----./  _____  \   |  |     
 \______| /__/     \__\ |__|  |__| |_______|| _|      |_______/__/     \__\  |__|     

*/

-- GAMEPLAY --

-- Get Room data
-- room_get
DELIMITER //
DROP PROCEDURE IF EXISTS room_get //
CREATE PROCEDURE room_get (
    IN player_character_id_in INT
)
BEGIN
    SELECT
        ri.room_instance_id,
        r.`name` AS room_name,
        r.width,
        r.height,
        ri.depth,

        ei.entity_instance_id,
        ei.player_character_id,
        pc.`name` AS character_name,
        pc.health,
        pc.hue,

        ei.item_id,
        i.`name` AS item_name,
        ei.quantity,

		s.`name` AS structure_name,

        ei.npc_id,
        ei.structure_id,
        ei.inventory_id,
        ei.destination_id,

        tgi.position_x,
        tgi.position_y

    FROM entity_instance AS player_entity
    JOIN tile_game_instance AS player_tile
        ON player_tile.tile_instance_id = player_entity.tile_instance_id
    JOIN room_instance AS ri
        ON ri.room_instance_id = player_tile.room_instance_id
    JOIN room AS r
        ON r.room_id = ri.room_id

    JOIN tile_game_instance AS tgi
        ON tgi.room_instance_id = ri.room_instance_id
    LEFT JOIN entity_instance AS ei
        ON ei.tile_instance_id = tgi.tile_instance_id
    LEFT JOIN player_character AS pc
        ON pc.player_character_id = ei.player_character_id
    LEFT JOIN item AS i
        ON i.item_id = ei.item_id
	LEFT JOIN structure AS s
		ON s.structure_id = ei.structure_id

    WHERE player_entity.player_character_id = player_character_id_in

    ORDER BY
        tgi.position_y,
        tgi.position_x,
        ei.entity_instance_id;
END //
DELIMITER ;

/*
 __  .__   __. ____    ____  _______ .__   __. .___________.  ______   .______     ____    ____ 
|  | |  \ |  | \   \  /   / |   ____||  \ |  | |           | /  __  \  |   _  \    \   \  /   / 
|  | |   \|  |  \   \/   /  |  |__   |   \|  | `---|  |----`|  |  |  | |  |_)  |    \   \/   /  
|  | |  . `  |   \      /   |   __|  |  . `  |     |  |     |  |  |  | |      /      \_    _/   
|  | |  |\   |    \    /    |  |____ |  |\   |     |  |     |  `--'  | |  |\  \----.   |  |     
|__| |__| \__|     \__/     |_______||__| \__|     |__|      \______/  | _| `._____|   |__|     
                                                                                                
*/
-- INVENTORY --

-- get inventory info
-- inventory_get
DELIMITER //
DROP PROCEDURE IF EXISTS inventory_get //
CREATE PROCEDURE inventory_get(
    IN player_character_id_in INT,
    IN inventory_type_in 	  VARCHAR(64)
)
BEGIN
    SELECT
        s.slot_no,
        i.`name` AS item_name,
        i.`description`,
        s.quantity,
        i.stack_size,
        i.point_value,
        i.`type` AS item_type
    FROM inventory AS inv
    JOIN slot AS s
        ON s.inventory_id = inv.inventory_id
    JOIN item AS i
        ON i.item_id = s.item_id
    WHERE inv.player_character_id = player_character_id_in
      AND inv.`type` = inventory_type_in
    ORDER BY s.slot_no;
END //
DELIMITER ;


-- Move Item in Inventory
-- inventory_move_item
-- TODO


-- Transfer Item between inventories
-- inventory_transfer_item
-- TODO


-- 7. Player game play acquiring inventory, e.g., picking up items off a tile and putting them in an inventory (bag?)
-- Pick up Item
-- item_pick_up
DELIMITER //
DROP PROCEDURE IF EXISTS item_pick_up //
CREATE PROCEDURE item_pick_up(
    IN player_character_id_in INT,
    IN entity_instance_id_in BIGINT
)
BEGIN
    DECLARE character_tile_id BIGINT;
    DECLARE carried_inventory_id BIGINT;
    DECLARE item_id_var INT;
    DECLARE item_quantity INT;
    DECLARE max_stack_size_var INT;
    DECLARE slot_no_var INT;
    DECLARE slot_quantity INT;
    DECLARE transfer_quantity INT;

    -- Find the character's tile
    SELECT tile_instance_id
    INTO character_tile_id
    FROM entity_instance
    WHERE player_character_id = player_character_id_in
    LIMIT 1;

    IF character_tile_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Character has no world entity';
    END IF;

    -- Find the ground item
    SELECT item_id, COALESCE(quantity, 1)
    INTO item_id_var, item_quantity
    FROM entity_instance
    WHERE entity_instance_id = entity_instance_id_in
      AND tile_instance_id = character_tile_id
      AND item_id IS NOT NULL;

    IF item_id_var IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Item is not on the character tile';
    END IF;

    -- Find the carried inventory and stack limit
    SELECT min(inventory_id)
    INTO carried_inventory_id
    FROM inventory
    WHERE player_character_id = player_character_id_in
      AND `type` = 'carried';

    SELECT stack_size
    INTO max_stack_size_var
    FROM item
    WHERE item_id = item_id_var;

    IF carried_inventory_id IS NULL OR max_stack_size_var IS NULL
       OR item_quantity <= 0 OR max_stack_size_var <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid inventory or item';
    END IF;

    -- loop to fill slots
    fill_stacks: WHILE item_quantity > 0 DO
        SELECT min(slot_no)
        INTO slot_no_var
        FROM slot
        WHERE inventory_id = carried_inventory_id
          AND item_id = item_id_var
          AND quantity < max_stack_size_var;
		
        -- no inventory slots left
        IF slot_no_var IS NULL THEN
            LEAVE fill_stacks;
        END IF;

        SELECT quantity
        INTO slot_quantity
        FROM slot
        WHERE inventory_id = carried_inventory_id
          AND slot_no = slot_no_var;

        SET transfer_quantity = least(
            item_quantity,
            max_stack_size_var - slot_quantity
        );

        UPDATE slot
        SET quantity = quantity + transfer_quantity
        WHERE inventory_id = carried_inventory_id
          AND slot_no = slot_no_var;

        SET item_quantity = item_quantity - transfer_quantity;
    END WHILE;

    -- Create new stacks
    WHILE item_quantity > 0 DO
        SELECT coalesce(max(slot_no), 0) + 1
        INTO slot_no_var
        FROM slot
        WHERE inventory_id = carried_inventory_id;

        SET transfer_quantity = least(item_quantity, max_stack_size_var);

        INSERT INTO slot (slot_no, inventory_id, item_id, quantity)
        VALUES (slot_no_var, carried_inventory_id, item_id_var, transfer_quantity);

        SET item_quantity = item_quantity - transfer_quantity;
    END WHILE;

    DELETE FROM entity_instance
    WHERE entity_instance_id = entity_instance_id_in;

    SELECT 'Picked up successfully' AS result;
END //
DELIMITER ;



-- Drop Item
-- inventory_drop
DELIMITER //
DROP PROCEDURE IF EXISTS inventory_drop //
CREATE PROCEDURE inventory_drop(
    IN player_character_id_in INT,
    IN slot_no_in INT
)
BEGIN
    DECLARE character_tile_id 	 BIGINT DEFAULT NULL;
    DECLARE carried_inventory_id BIGINT DEFAULT NULL;
    DECLARE item_id_var 		 INT DEFAULT NULL;
    DECLARE item_quantity 		 INT DEFAULT NULL;
    DECLARE entity_count 		 INT DEFAULT 0;

    -- get the character's world entity
    SELECT count(*)
    INTO entity_count
    FROM entity_instance
    WHERE player_character_id = player_character_id_in;

    IF entity_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Character has no world entity';
    END IF;

    SELECT tile_instance_id
    INTO character_tile_id
    FROM entity_instance
    WHERE player_character_id = player_character_id_in
    LIMIT 1;

    -- get the character's carried inventory
    SELECT min(inventory_id)
    INTO carried_inventory_id
    FROM inventory
    WHERE player_character_id = player_character_id_in
      AND `type` = 'carried';

    IF carried_inventory_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Carried inventory not found';
    END IF;

    -- get the item stack in the selected slot
    SELECT item_id, quantity
    INTO item_id_var, item_quantity
    FROM slot
    WHERE inventory_id = carried_inventory_id
      AND slot_no = slot_no_in;

    IF item_id_var IS NULL OR item_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid inventory slot';
    END IF;

    -- Create the ground item on the character's tile
    INSERT INTO entity_instance (
        tile_instance_id,
        item_id,
        quantity
    )
    VALUES (
        character_tile_id,
        item_id_var,
        item_quantity
    );

    -- Remove the entire inventory stack
    DELETE FROM slot
    WHERE inventory_id = carried_inventory_id
      AND slot_no = slot_no_in;

    SELECT 'Dropped successfully' AS result;
END //
DELIMITER ;

/*
.___  ___.   ______   ____    ____  _______ .___  ___.  _______ .__   __. .___________.
|   \/   |  /  __  \  \   \  /   / |   ____||   \/   | |   ____||  \ |  | |           |
|  \  /  | |  |  |  |  \   \/   /  |  |__   |  \  /  | |  |__   |   \|  | `---|  |----`
|  |\/|  | |  |  |  |   \      /   |   __|  |  |\/|  | |   __|  |  . `  |     |  |     
|  |  |  | |  `--'  |    \    /    |  |____ |  |  |  | |  |____ |  |\   |     |  |     
|__|  |__|  \______/      \__/     |_______||__|  |__| |_______||__| \__|     |__|     
*/

-- MOVEMENT --
-- 5. Player game play movement, i.e., moving a player to a “legal” tile. 
-- Move in direction
-- gameplay_move_in_direction
DELIMITER //
DROP PROCEDURE IF EXISTS gameplay_move_in_direction //
CREATE PROCEDURE gameplay_move_in_direction (
	IN player_character_id_in INT,
    IN direction_in			  CHAR(1)
)
BEGIN
	DECLARE current_tile_instance_id BIGINT DEFAULT NULL;
    DECLARE current_room_instance_id BIGINT DEFAULT NULL;
    DECLARE current_x 				 INT DEFAULT NULL;
    DECLARE current_y 				 INT DEFAULT NULL;
    DECLARE target_x 				 INT DEFAULT NULL;
    DECLARE target_y 				 INT DEFAULT NULL;
    DECLARE target_tile_instance_id  BIGINT DEFAULT NULL;
    
    DECLARE result_message VARCHAR(64) DEFAULT NULL;
    
    IF lower(direction_in) NOT IN ('w', 'a', 's', 'd') THEN
		SET result_message = 'Invalid direction';
    ELSE
        SELECT
            tgi.tile_instance_id,
            tgi.room_instance_id,
            tgi.position_x,
            tgi.position_y
        INTO
            current_tile_instance_id,
            current_room_instance_id,
            current_x,
            current_y
        FROM entity_instance AS ei
        JOIN tile_game_instance AS tgi
            ON tgi.tile_instance_id = ei.tile_instance_id
        WHERE ei.player_character_id = player_character_id_in
        LIMIT 1;

        IF current_tile_instance_id IS NULL THEN
            SET result_message = 'Character is not in a room';
        ELSE
            SET target_x = current_x;
            SET target_y = current_y;

            CASE lower(direction_in)
                WHEN 'w' THEN SET target_y = current_y - 1;
                WHEN 'a' THEN SET target_x = current_x - 1;
                WHEN 's' THEN SET target_y = current_y + 1;
                WHEN 'd' THEN SET target_x = current_x + 1;
            END CASE;

            SELECT tgi.tile_instance_id
            INTO target_tile_instance_id
            FROM tile_game_instance AS tgi
            WHERE tgi.room_instance_id = current_room_instance_id
				AND tgi.position_x = target_x
				AND tgi.position_y = target_y
            LIMIT 1;

            IF target_tile_instance_id IS NULL THEN
                SET result_message = 'Blocked';
            ELSEIF EXISTS (
				SELECT 1
				FROM entity_instance AS ei
				LEFT JOIN structure AS s
					ON s.structure_id = ei.structure_id
				WHERE ei.tile_instance_id = target_tile_instance_id
				  AND (
					  ei.npc_id IS NOT NULL
					  OR (
						  ei.structure_id IS NOT NULL
						  AND s.name <> 'doorway'
					  )
					  OR (
						  ei.player_character_id IS NOT NULL
						  AND NOT (
							  target_x = 4
							  AND target_y = 3
						  )
					  )
				  )
			) THEN
				SET result_message = 'Blocked';
            ELSE
                UPDATE entity_instance
                SET tile_instance_id = target_tile_instance_id
                WHERE player_character_id = player_character_id_in;

                SET result_message = 'Moved';
            END IF;
        END IF;
    END IF;

    SELECT result_message AS result;
END //
DELIMITER ; 

-- Navigate Doorway
-- gameplay_navigate_doorway
DELIMITER //
DROP PROCEDURE IF EXISTS gameplay_navigate_doorway //
CREATE PROCEDURE gameplay_navigate_doorway (
    IN player_character_id_in INT
)
BEGIN
    DECLARE current_room_instance_id BIGINT;
    DECLARE destination_room_instance_id BIGINT;
    DECLARE current_tile_instance_id BIGINT;
    DECLARE destination_tile_instance_id BIGINT;
    DECLARE doorway_structure_id INT;
    DECLARE destination_room_name VARCHAR(64);

    -- Get the doorway structure ID
    SELECT structure_id
    INTO doorway_structure_id
    FROM structure
    WHERE `name` = 'doorway';

    -- Get the character's current room and tile
    SELECT tgi.room_instance_id, tgi.tile_instance_id
    INTO current_room_instance_id, current_tile_instance_id
    FROM entity_instance ei
    JOIN tile_game_instance tgi
        ON tgi.tile_instance_id = ei.tile_instance_id
    WHERE ei.player_character_id = player_character_id_in;

    -- Find the destination room
    SELECT ei.destination_id
    INTO destination_room_instance_id
    FROM entity_instance ei
    WHERE ei.tile_instance_id = current_tile_instance_id
      AND ei.structure_id = doorway_structure_id;

    -- Find the destination room name
    SELECT r.name
    INTO destination_room_name
    FROM room_instance ri
    JOIN room r
        ON r.room_id = ri.room_id
    WHERE ri.room_instance_id = destination_room_instance_id;

    -- Find the reciprocal doorway tile
    SELECT tgi.tile_instance_id
    INTO destination_tile_instance_id
    FROM entity_instance ei
    JOIN tile_game_instance tgi
        ON tgi.tile_instance_id = ei.tile_instance_id
    WHERE tgi.room_instance_id = destination_room_instance_id
      AND ei.structure_id = doorway_structure_id
      AND ei.destination_id = current_room_instance_id;

    -- Tally the inventory score
    IF destination_room_name = 'lobby' THEN
        CALL score_tally(player_character_id_in, FALSE);
    ELSE
        CALL score_tally(player_character_id_in, TRUE);
    END IF;

    -- Move the character
    UPDATE entity_instance
    SET tile_instance_id = destination_tile_instance_id
    WHERE player_character_id = player_character_id_in;
END //
DELIMITER ;

-- INTERACTION --
-- Examine Item/Entity
-- gameplay_examime_entity

-- Cast Gem
-- gameplay_cast_gem

-- Unlock Door
-- gameplay_unlock_door

-- Unlock Chest
-- gameplay_unlock_chest

-- View Shop
-- shop_view

-- Purchase Shop Item
-- shop_purchase

/*
  _______      ___      .___  ___.  _______     _______ .__   __.   _______  __  .__   __.  _______ 
 /  _____|    /   \     |   \/   | |   ____|   |   ____||  \ |  |  /  _____||  | |  \ |  | |   ____|
|  |  __     /  ^  \    |  \  /  | |  |__      |  |__   |   \|  | |  |  __  |  | |   \|  | |  |__   
|  | |_ |   /  /_\  \   |  |\/|  | |   __|     |   __|  |  . `  | |  | |_ | |  | |  . `  | |   __|  
|  |__| |  /  _____  \  |  |  |  | |  |____    |  |____ |  |\   | |  |__| | |  | |  |\   | |  |____ 
 \______| /__/     \__\ |__|  |__| |_______|   |_______||__| \__|  \______| |__| |__| \__| |_______|
                                                                                                    
*/

-- GAME ENGINE --
-- Generate Cave
-- game_generate_cave

/*
DELIMITER //
DROP PROCEDURE IF EXISTS game_generate_cave //
CREATE PROCEDURE game_generate_cave (
    IN game_id_in INT
)
BEGIN
    DECLARE target_room_count INT DEFAULT 10;
    DECLARE min_rooms_per_pass INT DEFAULT 2;
    DECLARE max_rooms_per_pass INT DEFAULT 3;

    DECLARE rooms_generated INT DEFAULT 0;
    DECLARE current_depth INT DEFAULT 0;
    DECLARE rooms_this_pass INT;
    DECLARE remaining_rooms INT;

    DECLARE new_room_id BIGINT;
    DECLARE parent_room_id BIGINT;
    DECLARE room_name_out VARCHAR(64);

    DECLARE eligible_room_count INT;
    DECLARE available_parent_count INT;

    -- Store the rooms generated in the previous pass.
    -- These are the only rooms that new rooms may initially connect to.
    DROP TEMPORARY TABLE IF EXISTS cave_previous_pass;

    CREATE TEMPORARY TABLE cave_previous_pass (
        room_instance_id BIGINT PRIMARY KEY
    );

    -- Store the rooms generated in the current pass.
    DROP TEMPORARY TABLE IF EXISTS cave_current_pass;

    CREATE TEMPORARY TABLE cave_current_pass (
        room_instance_id BIGINT PRIMARY KEY
    );

    -- ------------------------------------------------------------
    -- Depth 0: Generate the entrance.
    -- ------------------------------------------------------------

    SELECT count(*)
    INTO eligible_room_count
    FROM room
    WHERE minimum_depth <= 0
      AND EXISTS (
          SELECT 1
          FROM room_doorway
          WHERE room_doorway.room_id = room.room_id
      );

    IF eligible_room_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No room template is available for the cave entrance';
    END IF;

    SELECT `name`
    INTO room_name_out
    FROM room
    WHERE minimum_depth <= 0
      AND EXISTS (
          SELECT 1
          FROM room_doorway
          WHERE room_doorway.room_id = room.room_id
      )
    ORDER BY rand()
    LIMIT 1;

    CALL game_generate_room(
        room_name_out,
        game_id_in,
        0,
        new_room_id
    );

    INSERT INTO cave_previous_pass (
        room_instance_id
    )
    VALUES (
        new_room_id
    );

    SET rooms_generated = 1;


END //

DELIMITER ;
*/
-- TODO - lets make a single room for testing.
DELIMITER //
DROP PROCEDURE IF EXISTS game_generate_cave //
CREATE PROCEDURE game_generate_cave (
    IN game_id_in INT,
    IN lobby_room_id_in BIGINT
)
BEGIN
    DECLARE cave_room_id BIGINT;
    DECLARE cave_room_name VARCHAR(64);

    -- Select a room that can be used as the cave entrance.
    -- It must be available at depth 0 and have at least one doorway.
    SELECT `name`
    INTO cave_room_name
    FROM room
    WHERE minimum_depth <= 0
    -- exclude lobby
    AND `name` <> 'lobby'
    AND EXISTS (
        SELECT 1
        FROM room_doorway
        WHERE room_doorway.room_id = room.room_id
    )
    ORDER BY rand()
    LIMIT 1;

    -- Generate the first cave room.
    CALL game_generate_room(
        cave_room_name,
        game_id_in,
        0,
        cave_room_id
    );

    -- Connect the cave entrance to the lobby.
    CALL game_connect_rooms(
        lobby_room_id_in,
        cave_room_id
    );
END //
DELIMITER ;

-- generate a doorway connection between rooms.
-- game_connect_rooms
DELIMITER //
DROP PROCEDURE IF EXISTS game_connect_rooms //
CREATE PROCEDURE game_connect_rooms (
    IN room_a_id INT,
    IN room_b_id INT
)
BEGIN
    DECLARE doorway_a_x INT;
    DECLARE doorway_a_y INT;
    DECLARE doorway_b_x INT;
    DECLARE doorway_b_y INT;
    DECLARE doorway_structure_id INT;

    -- Get the doorway structure
    SELECT structure_id INTO doorway_structure_id
    FROM structure
    WHERE `name` = 'doorway';

    -- Select an unused doorway position in room A
    SELECT rd.position_x, rd.position_y
    INTO doorway_a_x, doorway_a_y
    FROM room_doorway rd
    WHERE rd.room_id = (
        SELECT room_id
        FROM room_instance
        WHERE room_instance_id = room_a_id
    )
    AND NOT EXISTS (
        SELECT 1
        FROM entity_instance ei
        JOIN tile_game_instance tgi
            ON tgi.tile_instance_id = ei.tile_instance_id
        WHERE tgi.room_instance_id = room_a_id
        AND tgi.position_x = rd.position_x
        AND tgi.position_y = rd.position_y
        AND ei.structure_id = doorway_structure_id
    )
    ORDER BY rand()
    LIMIT 1;

    -- Select an unused doorway position in room B
    SELECT rd.position_x, rd.position_y
    INTO doorway_b_x, doorway_b_y
    FROM room_doorway rd
    WHERE rd.room_id = (
        SELECT room_id
        FROM room_instance
        WHERE room_instance_id = room_b_id
    )
    AND NOT EXISTS (
        SELECT 1
        FROM entity_instance ei
        JOIN tile_game_instance tgi
            ON tgi.tile_instance_id = ei.tile_instance_id
        WHERE tgi.room_instance_id = room_b_id
        AND tgi.position_x = rd.position_x
        AND tgi.position_y = rd.position_y
        AND ei.structure_id = doorway_structure_id
    )
    ORDER BY rand()
    LIMIT 1;

    -- Create doorway from room A to room B
    INSERT INTO entity_instance (
        tile_instance_id,
        structure_id,
        destination_id
    )
    SELECT
        tgi.tile_instance_id,
        doorway_structure_id,
        room_b_id
    FROM tile_game_instance tgi
    WHERE tgi.room_instance_id = room_a_id
    AND tgi.position_x = doorway_a_x
    AND tgi.position_y = doorway_a_y;

    -- Create doorway from room B to room A
    INSERT INTO entity_instance (
        tile_instance_id,
        structure_id,
        destination_id
    )
    SELECT
        tgi.tile_instance_id,
        doorway_structure_id,
        room_a_id
    FROM tile_game_instance tgi
    WHERE tgi.room_instance_id = room_b_id
    AND tgi.position_x = doorway_b_x
    AND tgi.position_y = doorway_b_y;
END //
DELIMITER ;

-- 3. Laying out tiles on a game board
-- Generate Room
-- game_generate_room
DELIMITER //
DROP PROCEDURE IF EXISTS game_generate_room //
CREATE PROCEDURE game_generate_room (
	IN room_name_in 		 VARCHAR(64),
    IN game_id_in 			 INT,
    IN depth_in 			 INT,
    OUT room_instance_id_out BIGINT
)
BEGIN
	DECLARE room_id_new INT;
    
	-- get room template from name
    SELECT room_id INTO room_id_new
    FROM room
    WHERE `name` = room_name_in;
    
    -- create new room
    INSERT INTO room_instance (
		room_id,
        game_id,
        depth
	) VALUES (
		room_id_new,
        game_id_in,
        depth_in
	);
    
    -- get the new room instance ID
    SET room_instance_id_out = last_insert_id();
    
    -- Copy the template tiles into the room instance
    INSERT INTO tile_game_instance (
        room_instance_id,
        tile_id,
        position_x,
        position_y
    )
    SELECT
        room_instance_id_out,
        tmi.tile_id,
        tmi.position_x,
        tmi.position_y
    FROM tile_map_instance AS tmi
    WHERE tmi.room_id = room_id_new;
    
    -- Populate the room with entities
    CALL game_populate_room_entities(room_instance_id_out);
END //
DELIMITER ; 


-- populate room layout table from ascii input
-- game_populate_room_layout
DELIMITER //
DROP PROCEDURE IF EXISTS game_populate_room_layout //
CREATE PROCEDURE game_populate_room_layout (
    IN room_name_in VARCHAR(64),
    IN layout_in TEXT
)
BEGIN
    DECLARE char_index INT DEFAULT 1;
    DECLARE position_x INT DEFAULT 0;
    DECLARE position_y INT DEFAULT 0;
    DECLARE layout_length INT;
    DECLARE current_char CHAR(1);
    DECLARE current_room_id INT;

    -- get the room template
    SELECT room_id INTO current_room_id
    FROM room
    WHERE `name` = room_name_in;

    -- get the length of the layout string
    SET layout_length = CHAR_LENGTH(layout_in);

    -- read each layout character
    WHILE char_index <= layout_length DO
        SET current_char = SUBSTRING(layout_in, char_index, 1);

        -- Detect new lines
        IF ASCII(current_char) IN (10, 13) THEN
            SET position_x = 0;
            SET position_y = position_y + 1;

        ELSEIF ASCII(current_char) IN (9, 32) THEN
            -- Ignore tabs and indentation spaces
            -- why don't you detect indentation properly :(
            SET position_x = position_x;

        ELSEIF current_char = 'D' THEN
            -- Place a floor tile beneath the doorway
            INSERT INTO tile_map_instance (
                tile_id,
                room_id,
                position_x,
                position_y
            )
            SELECT
                tile_id,
                current_room_id,
                position_x,
                position_y
            FROM tile
            WHERE symbol = '.';

            -- Record the doorway position
            INSERT INTO room_doorway (
                room_id,
                position_x,
                position_y
            )
            VALUES (
                current_room_id,
                position_x,
                position_y
            );

            SET position_x = position_x + 1;

        ELSE
            -- Insert the tile matching the symbol
            INSERT INTO tile_map_instance (
                tile_id,
                room_id,
                position_x,
                position_y
            )
            SELECT
                tile_id,
                current_room_id,
                position_x,
                position_y
            FROM tile
            WHERE symbol = current_char;

            SET position_x = position_x + 1;
        END IF;

        SET char_index = char_index + 1;
    END WHILE;
END //
DELIMITER ;

-- 4. Placing an item on a tile. 
-- populate room with entities based on spawn tables
-- game_populate_room_entities
DELIMITER //
DROP PROCEDURE IF EXISTS game_populate_room_entities //
CREATE PROCEDURE game_populate_room_entities (
	IN room_instance_id_in BIGINT
)
BEGIN
    DECLARE finished 				 BOOLEAN DEFAULT FALSE;
	-- tile variables
    DECLARE current_tile_instance_id BIGINT;
    DECLARE current_spawn_table_id 	 INT;
    -- entity variables
    DECLARE selected_structure_id 	 INT;
    DECLARE selected_npc_id 		 INT;
    DECLARE selected_item_id 		 INT;
    DECLARE selected_quantity 		 INT;
    DECLARE spawn_found BOOLEAN DEFAULT TRUE;
    
	-- Cursor to iterate through all tiles in the room
    DECLARE tile_cursor CURSOR FOR
        SELECT tgi.tile_instance_id, t.spawn_table_id
        FROM tile_game_instance AS tgi
        JOIN tile 				AS t
            ON t.tile_id = tgi.tile_id
        WHERE tgi.room_instance_id = room_instance_id_in;
	
    -- Detect when there are no more tiles to process
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET finished = TRUE;
        
	-- Start processing
	OPEN tile_cursor;
    tile_loop: LOOP
        -- Retrieve the next tile and its spawn table
        FETCH tile_cursor
        INTO current_tile_instance_id, current_spawn_table_id;

        -- Stop when every tile has been processed
        IF finished THEN
            LEAVE tile_loop;
        END IF;
        
        -- Reset the outcome before selecting for this tile
        SET selected_structure_id = NULL;
        SET selected_npc_id = NULL;
        SET selected_item_id = NULL;
        SET selected_quantity = NULL;
        SET spawn_found = TRUE;
		
        -- Nested begin for the empty handler
        BEGIN
			-- handle empty spawn tables
			DECLARE CONTINUE HANDLER FOR NOT FOUND
                SET spawn_found = FALSE;
			-- Select one weighted random outcome
			SELECT
				ste.structure_id,
				ste.npc_id,
				ste.item_id,
				ste.quantity
			INTO
				selected_structure_id,
				selected_npc_id,
				selected_item_id,
				selected_quantity
			FROM spawn_table_entry AS ste
			WHERE ste.spawn_table_id = current_spawn_table_id
			ORDER BY -log(1.0 - rand()) / ste.weight -- Math :(
			LIMIT 1;
        END;
        
        -- Create the entity unless the selected outcome is "nothing"
		IF spawn_found
			AND (
				selected_structure_id IS NOT NULL
				OR selected_npc_id 	  IS NOT NULL
				OR selected_item_id   IS NOT NULL
			) THEN
			INSERT INTO entity_instance (
				tile_instance_id,
				structure_id,
				npc_id,
				item_id,
				quantity
			)
			VALUES (
				current_tile_instance_id,
				selected_structure_id,
				selected_npc_id,
				selected_item_id,
				CASE
					WHEN selected_item_id IS NOT NULL
						THEN COALESCE(selected_quantity, 1)
					ELSE NULL
				END
			);
		END IF;
    END LOOP;

    CLOSE tile_cursor;
END //
DELIMITER ; 

-- Process game tick
-- game_process_tick

DELIMITER //
DROP PROCEDURE IF EXISTS game_process_tick //
CREATE PROCEDURE game_process_tick ()
BEGIN
    DECLARE finished 		BOOLEAN DEFAULT FALSE;
    DECLARE finished_ending BOOLEAN DEFAULT FALSE;
    DECLARE game_id_current INT;
    DECLARE lobby_room_id 	BIGINT;

	-- Get all games that have started and haven't generated caves yet
    DECLARE starting_games CURSOR FOR
        SELECT g.game_id, p.room_instance_id
        FROM game g
        JOIN party p
            ON p.game_id = g.game_id
        WHERE g.start_time <= CURRENT_TIMESTAMP
          AND g.cave_generated = FALSE;
	
    -- Get all games that have been running for 30 minutes and haven't ended yet
    DECLARE ending_games CURSOR FOR
		SELECT game_id
        FROM game
        WHERE start_time <= (current_timestamp() - INTERVAL 30 MINUTE)
			AND ended = FALSE;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET finished = TRUE;

    -- Increment party ticks
    UPDATE party
    SET tick_count = tick_count + 1; 

    -- Generate caves for games whose countdown has finished
    OPEN starting_games;

    game_loop: LOOP
        FETCH starting_games
        INTO game_id_current, lobby_room_id;

        IF finished THEN
            LEAVE game_loop;
        END IF;

        CALL game_generate_cave(
            game_id_current,
            lobby_room_id
        );
        
        UPDATE game
        SET cave_generated = TRUE
        WHERE game_id = game_id_current;
    END LOOP;
    CLOSE starting_games;
    
    -- loop through games and end them after 30 minutes
    BEGIN
        DECLARE CONTINUE HANDLER FOR NOT FOUND
            SET finished_ending = TRUE;
        OPEN ending_games;
        ending_loop: LOOP
            FETCH ending_games INTO game_id_current;
            IF finished_ending THEN
                LEAVE ending_loop;
            END IF;

            CALL game_end(game_id_current);
        END LOOP;

        CLOSE ending_games;
    END;
END //
DELIMITER ;

-- event for handling ticks
-- game_tick_event
DELIMITER //
DROP EVENT IF EXISTS game_tick_event //
CREATE EVENT game_tick_event
ON SCHEDULE EVERY 1 second
STARTS CURRENT_TIMESTAMP + INTERVAL 1 SECOND
ENABLE
DO
BEGIN
	CALL game_process_tick();

    -- Process NPCs
    -- every third tick
    IF mod((SELECT coalesce(max(tick_count), 0) FROM party), 3) = 0 THEN
		CALL npc_process_tick();
	END IF;

    -- TODO: Process timed effects


END //
DELIMITER ; 

-- 8. Move an Item (NPC effect). 
-- Process NPC behavior
-- game_process_npc


DELIMITER //
DROP PROCEDURE IF EXISTS npc_process_tick //
CREATE PROCEDURE npc_process_tick ()
BEGIN
    DECLARE finished INT DEFAULT FALSE;
    DECLARE npc_entity_id BIGINT;
    DECLARE current_tile_id BIGINT;
    DECLARE current_room_id BIGINT;
    DECLARE current_x INT;
    DECLARE current_y INT;
    DECLARE target_x INT;
    DECLARE target_y INT;
    DECLARE target_tile_id BIGINT;
    DECLARE direction INT;

    DECLARE npc_cursor CURSOR FOR
        SELECT
            ei.entity_instance_id,
            tgi.tile_instance_id,
            tgi.room_instance_id,
            tgi.position_x,
            tgi.position_y
        FROM entity_instance ei
        JOIN npc n
            ON n.npc_id = ei.npc_id
        JOIN tile_game_instance tgi
            ON tgi.tile_instance_id = ei.tile_instance_id
        WHERE n.type = 'passive';

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET finished = TRUE;

	-- cursor to loop through potential moves
    OPEN npc_cursor;
    npc_loop: LOOP
        FETCH npc_cursor
        INTO npc_entity_id, current_tile_id, current_room_id, current_x, current_y;

        IF finished THEN
            LEAVE npc_loop;
        END IF;
		-- pick a random direction
        SET direction = floor(rand() * 4);

        SET target_x = current_x;
        SET target_y = current_y;

        CASE direction
            WHEN 0 THEN SET target_y = current_y - 1;
            WHEN 1 THEN SET target_x = current_x - 1;
            WHEN 2 THEN SET target_y = current_y + 1;
            WHEN 3 THEN SET target_x = current_x + 1;
        END CASE;

        SELECT tgi.tile_instance_id
        INTO target_tile_id
        FROM tile_game_instance tgi
        WHERE tgi.room_instance_id = current_room_id
          AND tgi.position_x = target_x
          AND tgi.position_y = target_y
        LIMIT 1;

        IF target_tile_id IS NOT NULL
           AND NOT EXISTS (
               SELECT 1
               FROM entity_instance ei
               WHERE ei.tile_instance_id = target_tile_id
           )
        THEN
            UPDATE entity_instance
            SET tile_instance_id = target_tile_id
            WHERE entity_instance_id = npc_entity_id;
        END IF;
    END LOOP;
    CLOSE npc_cursor;
END //
DELIMITER ;

-- Process effects
-- game_process_effects

-- TODO


-- 9. Kill running games.
-- End game
-- game_end
DELIMITER //
DROP PROCEDURE IF EXISTS game_end //
CREATE PROCEDURE game_end (
    IN game_id_in INT
)
BEGIN
    -- Delete cave rooms
    DELETE FROM room_instance
    WHERE game_id = game_id_in
      AND room_instance_id NOT IN (
          SELECT room_instance_id
          FROM party
          WHERE game_id = game_id_in
      );

    -- Mark the game as ended
    UPDATE game
    SET ended = TRUE
    WHERE game_id = game_id_in;
END //
DELIMITER ;



/*
     _______.  ______   ______   .______       _______ 
    /       | /      | /  __  \  |   _  \     |   ____|
   |   (----`|  ,----'|  |  |  | |  |_)  |    |  |__   
    \   \    |  |     |  |  |  | |      /     |   __|  
.----)   |   |  `----.|  `--'  | |  |\  \----.|  |____ 
|_______/     \______| \______/  | _| `._____||_______|
                                                       
                                                  
*/
-- SCORE --
-- 6. Game play scoring. How do players gain and lose points?
-- Tally Score
-- score_tally
DELIMITER //
DROP PROCEDURE IF EXISTS score_tally //
CREATE PROCEDURE score_tally (
    IN player_character_id_in INT,
    IN entering_caves_in 	  BOOLEAN
)
BEGIN
    DECLARE party_id_current INT;
    DECLARE inventory_score  INT DEFAULT 0;

    SELECT party_id
    INTO party_id_current
    FROM player_character
    WHERE player_character_id = player_character_id_in;

    SELECT coalesce(sum(i.point_value * s.quantity), 0)
    INTO inventory_score
    FROM inventory inv
    JOIN slot s
        ON s.inventory_id = inv.inventory_id
    JOIN item i
        ON i.item_id = s.item_id
    WHERE inv.player_character_id = player_character_id_in
		AND i.point_value IS NOT NULL;

    INSERT INTO party_scoreboard (
        party_id,
        player_character_id,
        player_name,
        score
    )
    SELECT
        pc.party_id,
        pc.player_character_id,
        pc.name,
        0
    FROM player_character pc
    WHERE pc.player_character_id = player_character_id_in
    ON DUPLICATE KEY UPDATE
        player_name = VALUES(player_name);

    UPDATE party_scoreboard
    SET score = score + CASE
        WHEN entering_caves_in THEN -inventory_score
        ELSE inventory_score
    END
    WHERE party_id = party_id_current
		AND player_character_id = player_character_id_in;
END //
DELIMITER ;

-- get the party score
-- score_get
DELIMITER //
DROP PROCEDURE IF EXISTS score_get //
CREATE PROCEDURE score_get (
    IN player_character_id_in INT
)
BEGIN
    SELECT
        player_name,
        score
    FROM party_scoreboard
    WHERE party_id = (
        SELECT party_id
        FROM player_character
        WHERE player_character_id = player_character_id_in
    )
    ORDER BY score DESC;
END //
DELIMITER ;


/*
 _______   _______ .______    __    __    _______ 
|       \ |   ____||   _  \  |  |  |  |  /  _____|
|  .--.  ||  |__   |  |_)  | |  |  |  | |  |  __  
|  |  |  ||   __|  |   _  <  |  |  |  | |  | |_ | 
|  '--'  ||  |____ |  |_)  | |  `--'  | |  |__| | 
|_______/ |_______||______/   \______/   \______| 
                                                  
*/
-- DEBUG --
-- View Room
-- debug_view_room
DELIMITER //
DROP PROCEDURE IF EXISTS debug_view_room //
CREATE PROCEDURE debug_view_room (
    IN room_instance_id_in BIGINT
)
BEGIN
    SELECT
        tgi.position_x,
        tgi.position_y,
        t.`name` AS tile_name,
        t.symbol,
		-- write all entities in a single column
        group_concat(
            CASE
                WHEN pc.name IS NOT NULL
                    THEN concat('Character: ', pc.name)
                WHEN n.name IS NOT NULL
                    THEN concat('NPC: ', n.name)
                WHEN i.name IS NOT NULL
                    THEN concat('Item: ', i.name,' (x', COALESCE(ei.quantity, 1), ')')
                WHEN s.name IS NOT NULL
                    THEN concat('Structure: ', s.name)
                ELSE NULL
            END
            ORDER BY ei.entity_instance_id
            SEPARATOR ', '
        ) AS entities

    FROM tile_game_instance AS tgi
    
    JOIN tile AS t
        ON t.tile_id = tgi.tile_id
    LEFT JOIN entity_instance AS ei
        ON ei.tile_instance_id = tgi.tile_instance_id
    LEFT JOIN structure AS s
        ON s.structure_id = ei.structure_id
    LEFT JOIN npc AS n
        ON n.npc_id = ei.npc_id
    LEFT JOIN item AS i
        ON i.item_id = ei.item_id
    LEFT JOIN player_character AS pc
        ON pc.player_character_id = ei.player_character_id

    WHERE tgi.room_instance_id = room_instance_id_in

    GROUP BY
        tgi.tile_instance_id,
        tgi.position_x,
        tgi.position_y,
        t.`name`,
        t.symbol

    ORDER BY
        tgi.position_y,
        tgi.position_x;
END //
DELIMITER ;

/*
     ___       _______  .___  ___.  __  .__   __. 
    /   \     |       \ |   \/   | |  | |  \ |  | 
   /  ^  \    |  .--.  ||  \  /  | |  | |   \|  | 
  /  /_\  \   |  |  |  ||  |\/|  | |  | |  . `  | 
 /  _____  \  |  '--'  ||  |  |  | |  | |  |\   | 
/__/     \__\ |_______/ |__|  |__| |__| |__| \__| 
                                                  
*/

-- ADMINISTRATION --
-- View Games
-- admin_view_games

-- End Game
-- admin_end_game

-- View Accounts
-- admin_view_accounts

-- BLANK PROCEDURE
/*
DELIMITER //
DROP PROCEDURE IF EXISTS ___ //
CREATE PROCEDURE ___ (

)
BEGIN

END //
DELIMITER ; 
*/


-- call procedures
-- SETUP
-- create the database
CALL create_database();
-- populate the database()
CALL populate_game_data();

-- uncomment the line below and its pair above to comment out the DDL section
-- */

-- END OF DDL --

/*
.___________. _______     _______.___________. __  .__   __.   _______ 
|           ||   ____|   /       |           ||  | |  \ |  |  /  _____|
`---|  |----`|  |__     |   (----`---|  |----`|  | |   \|  | |  |  __  
    |  |     |   __|     \   \       |  |     |  | |  . `  | |  | |_ | 
    |  |     |  |____.----)   |      |  |     |  | |  |\   | |  |__| | 
    |__|     |_______|_______/       |__|     |__| |__| \__|  \______| 
*/

-- START OF TESTING PHASE 1 - PRE GAME --
-- please comment all previous code out and uncomment the following code up to PHASE 2 - IN GAME --
-- Or select the entirety of PHASE 1 - PRE GAME and run						 --

-- Once the Database has been initialised, run PHASE 1 of tests to test all database processes up to and including starting a game

-- comment the line below and its pair beneath PHASE 1 to enable PHASE 1
/*


-- TESTING --
-- ACCOUNT --

-- 2. Player registration
-- account_register(email, password, admin)
-- regular
CALL account_register("TestPlayer@kharst.game","Admin123", FALSE);
-- admin
CALL account_register("TestAdmin@kharst.game","Admin123", TRUE);
-- check
SELECT * FROM user_account;

-- 1. Player login, including lock out
-- account_login(email, password)
CALL account_login("TestPlayer@kharst.game", "Admin123");
-- wrong password
CALL account_login("TestPlayer@kharst.game", "wrongpassword");
-- no account
CALL account_login("wrongemail", "wrongpassword");

-- account_lockout(email)
CALL account_lockout("TestPlayer@kharst.game");
-- check account
SELECT * FROM user_account
WHERE email = "TestPlayer@kharst.game";
-- attempt login
CALL account_login("TestPlayer@kharst.game", "Admin123");
-- reset lockout
UPDATE user_account
SET lockout_time = NULL
WHERE email = "TestPlayer@kharst.game";


-- 11. Update data of a player
-- account_update_email(old_email, new_email)
CALL account_update_email("TestPlayer@kharst.game", "UpdatedPlayer@kharst.game");
-- check account
SELECT * FROM user_account
WHERE email = "UpdatedPlayer@kharst.game";

-- account update password(email, new password)
CALL account_update_password("UpdatedPlayer@kharst.game", "UpdatedPassword");
-- check account
SELECT * FROM user_account
WHERE email = "UpdatedPlayer@kharst.game";
-- attempt login with old credentials
CALL account_login("UpdatedPlayer@kharst.game", "Admin123");
-- attempt login with new credentials
CALL account_login("UpdatedPlayer@kharst.game", "UpdatedPassword");

-- 12. Delete a player
-- account_delete(email)
CALL account_delete("UpdatedPlayer@kharst.game");
-- check account
SELECT * FROM user_account
WHERE email = "UpdatedPlayer@kharst.game";
-- attempt login
CALL account_login("UpdatedPlayer@kharst.game", "UpdatedPassword");



-- CHARACTER --
SELECT user_account_id INTO @tadmin_account FROM user_account
WHERE email = "TestAdmin@kharst.game";

-- character_create(name, account ID, health, hue)
CALL character_create("Tadmin", @tadmin_account);

-- check character
-- SELECT * FROM player_character WHERE `name` = "Tadmin";

-- delete character
SELECT player_character_id INTO @character_id FROM player_character WHERE `name` = "Tadmin";
CALL character_delete(@character_id);

-- Confirm the character is gone
-- SELECT * FROM player_character WHERE `name` = "Tadmin";

-- create again to test
CALL character_create("Tadmin", @tadmin_account);

-- get character id
SELECT player_character_id INTO @tadmin_character FROM player_character WHERE `name` = "Tadmin";



-- CHARACTER PLAY
-- character_play(player_character_id_in)

-- 3. Laying out tiles on a game board
-- 4. Placing an item on a tile
CALL character_play(@tadmin_character);



-- PARTY --
-- New account
CALL account_register("TestPlayer@kharst.game", "Admin123", FALSE);
SELECT * FROM user_account;

-- New character
SELECT user_account_id INTO @tayer_account FROM user_account
WHERE email = "TestPlayer@kharst.game";
CALL character_create("Tayer", @tayer_account);

-- Get Tayer's character ID
SELECT player_character_id
INTO @tayer_character
FROM player_character
WHERE `name` = "Tayer";

-- Play game (creates Tayer's own party and lobby)
CALL character_play(@tayer_character);


-- Invite Tayer to Tadmin's party
SELECT party_id 
INTO @tadmin_party_id
FROM player_character
WHERE player_character_id = @tadmin_character;

CALL party_invite(
    @tadmin_party_id,
    @tadmin_character,
    @tayer_character
);

-- Check the invitation exists
-- SELECT * FROM party_invite;

-- Accept the invitation and join Tadmin's party
CALL party_add_player(
    @tadmin_party_id,
    @tayer_character
);

-- Check both characters' parties
-- SELECT player_character_id, `name`, party_id
-- FROM player_character
-- WHERE player_character_id IN (@character_1_id, @character_2_id);
-- Check the invitation was removed
-- SELECT * FROM party_invite;
-- Check the old party was deleted
-- SELECT * FROM party WHERE party_id = @old_party_id;
-- Check the old lobby was deleted
-- SELECT * FROM room_instance WHERE room_instance_id = @old_room_id;
-- Check the old game was deleted (if it had one)
-- SELECT * FROM game WHERE game_id = @old_game_id;

-- communication
CALL party_send_message(
    @tadmin_character,
    'Greetings Tayer!'
);
-- party_get_messages(character id)
CALL party_get_messages(@tayer_character);

-- Get Tayer's character ID, party, and room
SELECT
    pc.player_character_id,
    pc.party_id,
    p.room_instance_id
INTO
    @character_1_id,
    @party_id,
    @tayer_room_id
FROM player_character AS pc
JOIN party AS p
    ON p.party_id = pc.party_id
WHERE pc.`name` = 'Tayer';

-- CALL debug_view_room(@tayer_room_id);

-- party_remove_player( player_character_id, Destination party id)
CALL party_remove_player(@tayer_character, Null);

SELECT player_character_id, name, party_id, ready
FROM player_character
WHERE `name` = 'Tayer';

-- Get Tayer's new data
SELECT
    pc.player_character_id,
    pc.party_id,
    p.room_instance_id
INTO
    @tayer_id,
    @party_id,
    @tayer_room_id
FROM player_character AS pc
JOIN party AS p
    ON p.party_id = pc.party_id
WHERE pc.`name` = 'Tayer';

-- view tayer's new room
-- CALL debug_view_room(@tayer_room_id);

-- check parties
-- SELECT player_character_id, `name`, party_id FROM player_character;

-- check new party messages
CALL party_get_messages(@tayer_id);


-- 5. Player game play movement, i.e., moving a player to a “legal” tile
-- movement
-- invalid input
CALL gameplay_move_in_direction(@tayer_id, 'q');
-- move right
-- CALL debug_view_room(@tayer_room_id);
CALL gameplay_move_in_direction(@tayer_id, 'd');
-- debug_view_room(@tayer_room_id);

CALL gameplay_move_in_direction(@tayer_id, 's');
CALL gameplay_move_in_direction(@tayer_id, 's');
CALL gameplay_move_in_direction(@tayer_id, 's');
-- blocked by wall
CALL gameplay_move_in_direction(@tayer_id, 's');
-- CALL debug_view_room(@tayer_room_id);

CALL gameplay_move_in_direction(@tayer_id, 'd');
-- blocked by rock
CALL gameplay_move_in_direction(@tayer_id, 'd');
CALL debug_view_room(@tayer_room_id);

-- INVENTORY
-- move to coins
CALL gameplay_move_in_direction(@tayer_id, 'w');
CALL gameplay_move_in_direction(@tayer_id, 'w');
CALL gameplay_move_in_direction(@tayer_id, 'w');
CALL gameplay_move_in_direction(@tayer_id, 'w');
CALL gameplay_move_in_direction(@tayer_id, 'w');
CALL gameplay_move_in_direction(@tayer_id, 'a');
CALL gameplay_move_in_direction(@tayer_id, 'a');
CALL gameplay_move_in_direction(@tayer_id, 'a');
CALL gameplay_move_in_direction(@tayer_id, 'a');

-- get coins from tayer's lobby
SELECT ei.entity_instance_id
INTO @coins
FROM entity_instance AS ei
JOIN entity_instance AS player
    ON player.player_character_id = @tayer_id
WHERE player.tile_instance_id = ei.tile_instance_id
  AND ei.item_id IS NOT NULL
LIMIT 1;


-- 7. Player game play acquiring inventory, e.g., picking up items off a tile and putting them in an inventory (bag?)
-- pick up coins
-- item_pick_up(player_character_id_in, entity_instance_id_in)
-- CALL debug_view_room(@tayer_room_id);
CALL item_pick_up(@tayer_id, @coins);

CALL inventory_get(@tayer_id, 'carried');
CALL inventory_get(@tayer_id, 'stash');

CALL inventory_drop(@tayer_id, 1);

CALL gameplay_move_in_direction(@tayer_id, 'd');
CALL gameplay_move_in_direction(@tayer_id, 'd');
CALL gameplay_move_in_direction(@tayer_id, 's');
CALL gameplay_move_in_direction(@tayer_id, 's');

-- 10. Add new players
-- Invite Tadmin to Tayer's party
SELECT party_id
INTO @tayer_party_id
FROM player_character
WHERE player_character_id = @tayer_character;

CALL party_invite(
    @tayer_party_id,
    @tayer_character,
    @tadmin_character
);

CALL party_add_player(
    @tayer_party_id,
    @tadmin_character
);

CALL gameplay_move_in_direction(@tayer_character, 's');
CALL gameplay_move_in_direction(@tayer_character, 'w');
CALL gameplay_move_in_direction(@tadmin_character, 's');

CALL character_logout(@tayer_character);

CALL account_login("TestPlayer@kharst.game", "Admin123");
CALL character_play(@tayer_character);

-- Get Tayer's character ID
SELECT player_character_id
INTO @tayer_character
FROM player_character
WHERE `name` = "Tayer";

-- Invite Tayer to Tadmin's party
SELECT party_id 
INTO @tadmin_party_id
FROM player_character
WHERE player_character_id = @tadmin_character;

CALL party_invite(
    @tadmin_party_id,
    @tadmin_character,
    @tayer_character
);

-- Check the invitation exists
-- SELECT * FROM party_invite;

-- Accept the invitation and join Tadmin's party
CALL party_add_player(
    @tadmin_party_id,
    @tayer_character
);

CALL room_get(@tadmin_character);
CALL party_toggle_ready(@tadmin_character);
CALL party_toggle_ready(@tayer_character);

CALL debug_view_room(@tayer_room_id);
DO sleep(4);
CALL debug_view_room(@tayer_room_id);



-- comment the line below and its pair above to enable PHASE 1
*/

-- END OF TESTING PHASE 1 - PRE GAME --

/*
 __  .__   __.      _______      ___      .___  ___.  _______ 
|  | |  \ |  |     /  _____|    /   \     |   \/   | |   ____|
|  | |   \|  |    |  |  __     /  ^  \    |  \  /  | |  |__   
|  | |  . `  |    |  | |_ |   /  /_\  \   |  |\/|  | |   __|  
|  | |  |\   |    |  |__| |  /  _____  \  |  |  |  | |  |____ 
|__| |__| \__|     \______| /__/     \__\ |__|  |__| |_______|
                                                              
*/

-- please comment all previous code out and uncomment the following code up to PHASE 2 - IN GAME --
-- Or select the entirety of PHASE 2 - IN GAME and run 						 --

-- Once PHASE 1 has concluded, a game will have started
-- in-game tests such as score, and npc movemnet are validated in PHASE 2



-- comment the line below and its pair beneath PHASE 2 to enable PHASE 2
-- make sure to recomment PHASE 1
/*

-- TESTING 2
-- GAME HAS STARTED

-- move to doorway
CALL gameplay_move_in_direction(@tadmin_character, 'd');
CALL gameplay_move_in_direction(@tayer_character, 'w');
CALL gameplay_move_in_direction(@tayer_character, 'w');
CALL gameplay_move_in_direction(@tayer_character, 'w');
-- navigate doorway
CALL gameplay_navigate_doorway(@tayer_character);

-- get tayer's new room data
CALL room_get(@tayer_character);

-- get a reference to the item
SELECT ei.entity_instance_id
INTO @item_id

FROM entity_instance AS player_entity
JOIN tile_game_instance AS player_tile
	ON player_tile.tile_instance_id = player_entity.tile_instance_id

JOIN tile_game_instance AS tgi
	ON tgi.room_instance_id = player_tile.room_instance_id
 JOIN entity_instance AS ei
	ON ei.tile_instance_id = tgi.tile_instance_id
LEFT JOIN player_character AS pc
	ON pc.player_character_id = ei.player_character_id
LEFT JOIN item AS i
	ON i.item_id = ei.item_id

WHERE player_entity.player_character_id = @tayer_character
AND tgi.position_x = 4
AND tgi.position_y = 5
ORDER BY entity_instance_id ASC
LIMIT 1;

-- 8. Move an Item (NPC effect)
-- wait for npc to move
DO sleep(4);
-- look at room to see npc movemnt compared to the previous room_get
CALL room_get(@tayer_character);

-- move to item
CALL gameplay_move_in_direction(@tayer_character, 'w');
-- pick up item
CALL item_pick_up(@tayer_character, @item_id);
-- move back to door
CALL gameplay_move_in_direction(@tayer_character, 's');
-- navigate doorway back to lobby
CALL gameplay_navigate_doorway(@tayer_character);

-- 6. Game play scoring. How do players gain and lose points
-- returning to the lobby has awarded points, check them now
CALL score_get(@tayer_character);
-- return to th cave
CALL gameplay_navigate_doorway(@tayer_character);
-- entering to the cave has taken points, check them now
CALL score_get(@tayer_character);
-- points are back to zero
-- back to the lobby
CALL gameplay_navigate_doorway(@tayer_character);
-- the gem we picked up was worth 50 points
CALL score_get(@tayer_character); 

-- get the party_id
SELECT party_id
INTO @tayer_party_id
FROM player_character
WHERE player_character_id = @tayer_character;

-- get the game id from the party id
SELECT game_id
INTO @game_id
FROM party
WHERE party_id = @tayer_party_id;

-- 9. Kill running games
-- kill the game
CALL game_end(@game_id)

-- see the doorway into the caves gone
CALL room_get(@tayer_character);

-- comment the line below and its pair above to enable PHASE 2
*/
