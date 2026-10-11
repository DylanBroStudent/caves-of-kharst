
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
        lockout_time	timestamp(6)
	);

	CREATE TABLE game (
		game_id    int(10) 		NOT NULL AUTO_INCREMENT PRIMARY KEY,
		seed 	   int(10) 		NOT NULL,
		start_time timestamp(6)
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

	CREATE TABLE party (
		party_id	 	 int(10)    NOT NULL AUTO_INCREMENT PRIMARY KEY,
		game_id 		 int(10),
		room_instance_id bigint(19) NOT NULL,
        tick_count		 bigint(19) NOT NULL DEFAULT 0,
		CONSTRAINT fk_party_game 		  FOREIGN KEY (game_id) 		 REFERENCES game (game_id) 					 ON DELETE CASCADE,
		CONSTRAINT fk_party_room_instance FOREIGN KEY (room_instance_id) REFERENCES room_instance (room_instance_id) ON DELETE CASCADE
	);

	CREATE TABLE player_character (
		player_character_id int(10)      NOT NULL AUTO_INCREMENT PRIMARY KEY,
		`name` 				varchar(64)  NOT NULL UNIQUE,
		health 				int(10) 	 NOT NULL,
		hue 				int(3) 		 NOT NULL,
		user_account_id 	bigint(19)   NOT NULL,
		party_id 			int(10)      ,
        ready				bool		 NOT NULL DEFAULT FALSE,
		CONSTRAINT fk_player_character_user  FOREIGN KEY (user_account_id)  REFERENCES user_account (user_account_id) ON DELETE CASCADE,
		CONSTRAINT fk_player_character_party FOREIGN KEY (party_id) 		REFERENCES party (party_id)
	);

	CREATE TABLE party_invite (
		party_invite_id 	 INT AUTO_INCREMENT PRIMARY KEY,
		party_id 			 INT NOT NULL,
		inviter_character_id INT NOT NULL,
		invitee_character_id INT NOT NULL,
		created_at 			 TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		CONSTRAINT fk_party_invite_party 		 FOREIGN KEY (party_id) 			REFERENCES party (party_id)						  ON DELETE CASCADE,
		CONSTRAINT fk_party_invite_inviter 		 FOREIGN KEY (inviter_character_id) REFERENCES player_character (player_character_id) ON DELETE CASCADE,
		CONSTRAINT fk_party_invite_invitee 		 FOREIGN KEY (invitee_character_id) REFERENCES player_character (player_character_id) ON DELETE CASCADE,
		-- don't allow duplicates
        CONSTRAINT uq_party_invite_party_invitee UNIQUE (party_id, invitee_character_id) 
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
		effect_id     int(10) 	   NOT NULL,
		CONSTRAINT fk_npc_effect FOREIGN KEY (effect_id) REFERENCES effect (effect_id)
	);

	CREATE TABLE item (
		item_id 	  int(10) 	   NOT NULL AUTO_INCREMENT PRIMARY KEY,
		`name` 		  varchar(64)  NOT NULL UNIQUE,
		`description` varchar(255) NOT NULL,
		`type` 		  varchar(64)  NOT NULL,
		effect_id 	  int(10),
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

-- populate test data
DELIMITER //
DROP PROCEDURE IF EXISTS populate_test_data //
CREATE PROCEDURE populate_test_data()
BEGIN
	-- test accounts
	INSERT INTO user_account (email, `password`, `role`) VALUES 
    ('redwin@kharst.game'	  , 'Admin123', 'admin'),
    ('greenwacke@kharst.game' , 'Admin123', 'player'),
    ('blueppereel@kharst.game', 'Admin123', 'player');
END //

-- populate game data
DELIMITER //
DROP PROCEDURE IF EXISTS populate_game_data //
CREATE PROCEDURE populate_game_data()
BEGIN
    -- rooms
    INSERT INTO room (`name`, height, width, minimum_depth) VALUES
    ("lobby", 7, 9, 0);
    -- Structures
    INSERT INTO structure(`name`, description, `type`) VALUES
    -- Lobby structures
    ("shop", "The shopkeeper looms over his wares, eager to make a deal.", 'shop'),
    ("stash", "Your enchanted chest, capable of storing many things.", "stash"),
    ("wardrobe", "A wardrobe containing an endless supply of robes and dyes.", "wardrobe"),
    ("rock","A large rock stands in your way.","obstacle");
    -- Spawn tables
    INSERT INTO spawn_table (`name`) VALUES
    ("empty"),
    ("shop"),
    ("stash"),
    ("wardrobe"),
    ("rock"),
    ("rock_50");
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
      NULL, NULL, NULL, NULL, 1);
	
    -- Tiles
    INSERT INTO tile (`name`, spawn_table_id, symbol) VALUES
    ("floor", 	 (SELECT spawn_table_id FROM spawn_table WHERE `name` = "empty"), 	 "."),
    ("shop", 	 (SELECT spawn_table_id FROM spawn_table WHERE `name` = "shop"), 	 "S"),
    ("stash", 	 (SELECT spawn_table_id FROM spawn_table WHERE `name` = "stash"), 	 "H"),
    ("wardrobe", (SELECT spawn_table_id FROM spawn_table WHERE `name` = "wardrobe"), "W"),
    ("rock", 	 (SELECT spawn_table_id FROM spawn_table WHERE `name` = "rock"), 	 "R"),
    ("rock_50",  (SELECT spawn_table_id FROM spawn_table WHERE `name` = "rock_50"),  "r");
    
-- call layout interpreter to populate room data
-- NO INDENTATION ALLOWED!!!
CALL game_populate_room_layout(
"lobby",
".......rr
r........
........H
S........
........W
r........
Rr.r...Rr"
);
END //

-- ACCOUNT MANAGEMENT --
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

-- Log into Account
-- account_login
DELIMITER //
DROP PROCEDURE IF EXISTS account_login //
CREATE PROCEDURE account_login(IN email_in VARCHAR(64), IN password_in VARCHAR(64))
BEGIN
	SELECT * 
    FROM user_account
	WHERE email = email_in 
    AND `password` = password_in
    AND (
		lockout_time IS NULL
		OR now() >= lockout_time + INTERVAL 5 MINUTE);
END //
DELIMITER ;

-- Lock out Account
-- account_lockout
DELIMITER //
DROP PROCEDURE IF EXISTS account_lockout //
CREATE PROCEDURE account_lockout (IN email_in VARCHAR(64))
BEGIN
	UPDATE user_account
    SET lockout_time = now()
    WHERE email = email_in;
END //
DELIMITER ;

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


-- CHARACTER MANAGEMENT --
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
        type
	)
    VALUES
		(character_id_new, "carried"),
        (character_id_new, "Storage");
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


-- PARTY --
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
    ON DUPLICATE KEY UPDATE
        inviter_character_id = VALUES(inviter_character_id);
END //
DELIMITER ;

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
        COALESCE(p.game_id, ri.game_id),
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
        COALESCE(p.game_id, ri.game_id),
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


-- Start Game
-- party_start_game



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

-- GAMEPLAY --
-- INVENTORY --
-- Move Item in Inventory
-- inventory_move_item

-- Transfer Item between inventories
-- inventory_transfer_item

-- Pick up Item
-- inventory_pickup

-- Drop Item
-- inventory_drop


-- MOVEMENT --
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
				WHERE ei.tile_instance_id = target_tile_instance_id
				  AND (
					  ei.npc_id IS NOT NULL
					  OR ei.structure_id IS NOT NULL
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

-- GAME ENGINE --
-- Generate Cave
-- game_generate_cave

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
    IN layout_in 	TEXT
)
BEGIN
	DECLARE char_index 		INT DEFAULT 1;
	DECLARE position_x 		INT DEFAULT 0;
    DECLARE position_y 		INT DEFAULT 0;
    DECLARE layout_length 	INT;
    DECLARE current_char 	CHAR(1);
    DECLARE current_room_id INT;
    
    -- get the room template
    SELECT room_id INTO current_room_id
    FROM room
    WHERE `name` = room_name_in;
    
    -- get the length of the layout string
    SET layout_length = char_length(layout_in);
    
    -- read each layout character
    WHILE char_index <= layout_length DO
		SET current_char = substring(layout_in, char_index, 1);
        
			-- Detect new lines
			IF ASCII(current_char) IN (10, 13) THEN
				SET position_x = 0;
				SET position_y = position_y + 1;
			ELSEIF ASCII(current_char) IN (9, 32) THEN
				-- Ignore tabs and indentation spaces
				SET position_x = position_x;
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

			-- increment room position
            SET position_x = position_x + 1;
        END IF;
        
		-- increment string index
        SET char_index = char_index + 1;
    END WHILE;
    
END //
DELIMITER ; 

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
    
	-- set up cursor to retrieve every tile in the room instance
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
	UPDATE party
    SET tick_count = tick_count + 1;

    -- TODO: Process NPCs
    -- TODO: Process timed effects
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
END //
DELIMITER ; 

-- Process NPC behavior
-- game_process_npc

-- End game
-- game_end

-- SCORE --
-- Tally Score
-- score_tally

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
CALL create_database();
CALL populate_test_data();
CALL populate_game_data();

-- TESTING --
-- ACCOUNT --
-- account_register(email, password, admin)
-- regular
CALL account_register("TestPlayer@kharst.game","Admin123", FALSE);
-- admin
CALL account_register("TestAdmin@kharst.game","Admin123", TRUE);
-- check
SELECT * FROM user_account;

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
-- reset
UPDATE user_account
SET lockout_time = NULL
WHERE email = "TestPlayer@kharst.game";

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

-- account_delete(email)
CALL account_delete("UpdatedPlayer@kharst.game");
-- check account
SELECT * FROM user_account
WHERE email = "UpdatedPlayer@kharst.game";
-- attempt login
CALL account_login("UpdatedPlayer@kharst.game", "UpdatedPassword");

-- CHARACTER --
-- character_create(name, account ID, health, hue)
CALL character_create("Tadmin", 5);
-- check character
SELECT * FROM player_character WHERE `name` = "Tadmin";
-- delete character
SELECT player_character_id INTO @character_id FROM player_character WHERE `name` = "Tadmin";
CALL character_delete(@character_id);
-- Confirm the character is gone
SELECT * FROM player_character WHERE `name` = "Tadmin";

-- create again to test
CALL character_create("Tadmin", 5);
SELECT * FROM player_character WHERE `name` = "Tadmin";
-- CHARACTER PLAY
-- character_play(player_character_id_in)
CALL character_play(2);
-- check parties
SELECT * FROM party;
-- View that lobby's tiles and entities
CALL debug_view_room(1);

-- Update character colour
SELECT player_character_id INTO @character_id FROM player_character WHERE `name` = "Tadmin";
-- Check original colour
SELECT player_character_id, `name`, hue 
FROM player_character 
WHERE player_character_id = @character_id;
-- Update character colour
CALL character_update_colour(@character_id, 180);
-- Check updated colour
SELECT player_character_id, `name`, hue 
FROM player_character 
WHERE player_character_id = @character_id;

-- PARTY --
-- New account
CALL account_register("TestPlayer@kharst.game", "Admin123", FALSE);
SELECT * FROM user_account;

-- New character
CALL character_create("Tayer", 6);

-- Get Tayer's character ID
SELECT player_character_id
INTO @character_2_id
FROM player_character
WHERE `name` = "Tayer";

-- Play game (creates Tayer's original party and lobby)
CALL character_play(@character_2_id);

-- Get Tayer's original party
SELECT party_id
INTO @old_party_id
FROM player_character
WHERE player_character_id = @character_2_id;

-- Save the original lobby and game IDs
SELECT room_instance_id, game_id
INTO @old_room_id, @old_game_id
FROM party
WHERE party_id = @old_party_id;

-- Check parties and Tayer's room
SELECT * FROM party;
CALL debug_view_room(@old_room_id);

-- Get Tadmin's character ID and party
SELECT player_character_id, party_id
INTO @character_1_id, @party_id
FROM player_character
WHERE `name` = "Tadmin";

-- Invite Tayer to Tadmin's party
CALL party_invite(
    @party_id,
    @character_1_id,
    @character_2_id
);
-- Check the invitation exists
SELECT * FROM party_invite;
-- Accept the invitation and join Tadmin's party
CALL party_add_player(
    @party_id,
    @character_2_id
);

-- Check both characters' parties
SELECT player_character_id, `name`, party_id
FROM player_character
WHERE player_character_id IN (@character_1_id, @character_2_id);
-- Check the invitation was removed
SELECT * FROM party_invite;
-- Check the old party was deleted
SELECT * FROM party WHERE party_id = @old_party_id;
-- Check the old lobby was deleted
SELECT * FROM room_instance WHERE room_instance_id = @old_room_id;
-- Check the old game was deleted (if it had one)
SELECT * FROM game WHERE game_id = @old_game_id;

-- communication
CALL party_send_message(
    @character_1_id,
    'Greetings Tayer!'
);
-- party_get_messages(character id)
CALL party_get_messages(@character_2_id);

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

CALL debug_view_room(@tayer_room_id);

-- party_remove_player( player_character_id, Destination party id)
CALL party_remove_player(@character_2_id, Null);

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
CALL debug_view_room(@tayer_room_id);

-- check parties
SELECT player_character_id, `name`, party_id FROM player_character;
-- check new party messages
CALL party_get_messages(@tayer_id);

-- movement
-- invalid input
CALL gameplay_move_in_direction(@tayer_id, 'q');
-- move right
CALL debug_view_room(@tayer_room_id);
CALL gameplay_move_in_direction(@tayer_id, 'd');
CALL debug_view_room(@tayer_room_id);

CALL gameplay_move_in_direction(@tayer_id, 's');
CALL gameplay_move_in_direction(@tayer_id, 's');
CALL gameplay_move_in_direction(@tayer_id, 's');
-- blocked by wall
CALL gameplay_move_in_direction(@tayer_id, 's');
CALL debug_view_room(@tayer_room_id);

CALL gameplay_move_in_direction(@tayer_id, 'd');
-- blocked by rock
CALL gameplay_move_in_direction(@tayer_id, 'd');
CALL debug_view_room(@tayer_room_id);

-- check tick event
SHOW EVENTS;
SELECT * FROM party;