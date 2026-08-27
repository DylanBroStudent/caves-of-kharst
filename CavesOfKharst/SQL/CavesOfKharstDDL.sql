
-- reset database
DROP DATABASE IF EXISTS temp;
CREATE DATABASE temp;
USE temp;
DROP DATABASE IF EXISTS caves_of_kharst;
CREATE DATABASE caves_of_kharst;
USE caves_of_kharst;
DROP DATABASE IF EXISTS temp;

-- create tables
DELIMITER //
DROP PROCEDURE IF EXISTS create_tables //
CREATE PROCEDURE create_tables()
BEGIN
	CREATE TABLE user_account (
		user_account_id bigint(19)   NOT NULL AUTO_INCREMENT PRIMARY KEY,
		email 			varchar(64)  NOT NULL UNIQUE,
		`password` 		varchar(64)  NOT NULL,
		`role` 			varchar(64)  NOT NULL DEFAULT 'player',
        lockoutTime		timestamp(6)
	);

	CREATE TABLE game (
		game_id    int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
		seed 	   int(10) NOT NULL,
		start_time timestamp(6) NOT NULL
	);

	CREATE TABLE room (
		room_id int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
		height  int(10) NOT NULL,
		width   int(10) NOT NULL
	);

	CREATE TABLE room_instance (
		room_instance_id bigint(19) NOT NULL AUTO_INCREMENT PRIMARY KEY,
		room_id 		 int(10)    NOT NULL,
		game_id 		 int(10),
		depth 			 int(10)    NOT NULL,
		CONSTRAINT fk_room_instance_room FOREIGN KEY (room_id) REFERENCES room (room_id),
		CONSTRAINT fk_room_instance_game FOREIGN KEY (game_id) REFERENCES game (game_id)
	);

	CREATE TABLE party (
		party_id	 	 int(10)    NOT NULL AUTO_INCREMENT PRIMARY KEY,
		game_id 		 int(10)    NOT NULL,
		room_instance_id bigint(19) NOT NULL,
		CONSTRAINT fk_party_game 		  FOREIGN KEY (game_id) 		 REFERENCES game (game_id),
		CONSTRAINT fk_party_room_instance FOREIGN KEY (room_instance_id) REFERENCES room_instance (room_instance_id)
	);

	CREATE TABLE player_character (
		player_character_id int(10)      NOT NULL AUTO_INCREMENT PRIMARY KEY,
		`name` 				varchar(64)  NOT NULL UNIQUE,
		health 				int(10) 	 NOT NULL,
		hue 				int(3) 		 NOT NULL,
		user_account_id 	bigint(19)   NOT NULL,
		party_id 			int(10)      NOT NULL,
        ready				bool		 NOT NULL DEFAULT FALSE,
		CONSTRAINT fk_player_character_user  FOREIGN KEY (user_account_id)  REFERENCES user_account (user_account_id),
		CONSTRAINT fk_player_character_party FOREIGN KEY (party_id) 		REFERENCES party (party_id)
	);

	CREATE TABLE inventory (
		inventory_id 		bigint(19)  NOT NULL AUTO_INCREMENT PRIMARY KEY,
		player_character_id int(10),
		`type` 		 		varchar(64) NOT NULL,
		CONSTRAINT fk_inventory_player_character FOREIGN KEY (player_character_id) REFERENCES player_character (player_character_id)
	);

	CREATE TABLE structure (
		structure_id 	 int(10) 	  NOT NULL AUTO_INCREMENT PRIMARY KEY,
		`name` 		 	 varchar(64)  NOT NULL UNIQUE,
		description  	 varchar(255) NOT NULL,
		`type` 		 	 varchar(64)  NOT NULL
	);

	CREATE TABLE effect (
		effect_id 	 int(10) 	  NOT NULL AUTO_INCREMENT PRIMARY KEY,
		`name` 		 varchar(64)  NOT NULL UNIQUE,
		description  varchar(255) NOT NULL,
		`type` 		 varchar(64)  NOT NULL,
		target_style varchar(64)  NOT NULL,
		magnitude 	 int(10) 	  NOT NULL,
		`range` 	 int(10),
		duration 	 int(10)
	);

	CREATE TABLE npc (
		npc_id 		int(10) 	 NOT NULL AUTO_INCREMENT PRIMARY KEY,
		`name` 		varchar(64)  NOT NULL UNIQUE,
		description varchar(255) NOT NULL,
		`type` 		varchar(64)  NOT NULL,
		effect_id   int(10) 	 NOT NULL,
		CONSTRAINT fk_npc_effect FOREIGN KEY (effect_id) REFERENCES effect (effect_id)
	);

	CREATE TABLE item (
		item_id 	int(10) 	 NOT NULL AUTO_INCREMENT PRIMARY KEY,
		`name` 		varchar(64)  NOT NULL UNIQUE,
		description varchar(255) NOT NULL,
		`type` 		varchar(64)  NOT NULL,
		effect_id 	int(10),
		CONSTRAINT fk_item_effect FOREIGN KEY (effect_id) REFERENCES effect (effect_id)
	);

	CREATE TABLE slot (
		slot_no 	 int(10) 	NOT NULL,
		inventory_id bigint(19) NOT NULL,
		item_id 	 int(10),
		quantity 	 int(10) 	NOT NULL,
		PRIMARY KEY (slot_no, inventory_id),
		CONSTRAINT fk_slot_inventory FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id),
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
		symbol 		   char(1) 	   NOT NULL UNIQUE,
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
		position_x 		 int(5) 	NOT NULL,
		position_y 		 int(5) 	NOT NULL,
		CONSTRAINT fk_tile_game_instance_room_instance FOREIGN KEY (room_instance_id) REFERENCES room_instance (room_instance_id)
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
		CONSTRAINT fk_entity_instance_tile_game_instance FOREIGN KEY (tile_instance_id)    REFERENCES tile_game_instance (tile_instance_id),
		CONSTRAINT fk_entity_instance_npc 				 FOREIGN KEY (npc_id) 			   REFERENCES npc (npc_id),
		CONSTRAINT fk_entity_instance_item 				 FOREIGN KEY (item_id) 			   REFERENCES item (item_id),
		CONSTRAINT fk_entity_instance_player_character 	 FOREIGN KEY (player_character_id) REFERENCES player_character (player_character_id),
		CONSTRAINT fk_entity_instance_structure 		 FOREIGN KEY (structure_id) 	   REFERENCES structure (structure_id),
        CONSTRAINT fk_entity_instance_inventory		 	 FOREIGN KEY (inventory_id) 	   REFERENCES inventory (inventory_id),
        CONSTRAINT fk_entity_instance_destination		 FOREIGN KEY (destination_id) 	   REFERENCES room_instance (room_instance_id)
	);

	CREATE TABLE entity_instance_spawn_table (
		entity_instance_id bigint(10) NOT NULL,
		spawn_table_id 	   int(10)    NOT NULL,
		weight 			   int(10)    NOT NULL,
		PRIMARY KEY (entity_instance_id, spawn_table_id),
		CONSTRAINT fk_entity_instance_spawn_table_entity FOREIGN KEY (entity_instance_id) REFERENCES entity_instance (entity_instance_id),
		CONSTRAINT fk_entity_instance_spawn_table_spawn  FOREIGN KEY (spawn_table_id) 	  REFERENCES spawn_table (spawn_table_id)
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
		sender_character_id   int(10) 	   NOT NULL,
		receiver_character_id int(10),
		`type` 				  varchar(64)  NOT NULL,
		contents 			  varchar(255) NOT NULL,
		`timestamp`		  	  timestamp(6),
		CONSTRAINT fk_message_sender   FOREIGN KEY (sender_character_id)   REFERENCES player_character (player_character_id),
		CONSTRAINT fk_message_receiver FOREIGN KEY (receiver_character_id) REFERENCES player_character (player_character_id)
	);

	CREATE TABLE entity_effect (
		entity_instance_id bigint(10) NOT NULL,
		effect_id 		   int(10) NOT NULL,
		start_time 		   timestamp(6) NOT NULL,
		PRIMARY KEY (entity_instance_id, effect_id, start_time),
		CONSTRAINT fk_entity_effect_instance FOREIGN KEY (entity_instance_id) REFERENCES entity_instance (entity_instance_id),
		CONSTRAINT fk_entity_effect_effect   FOREIGN KEY (effect_id) 		  REFERENCES effect (effect_id)
	);
END //

-- populate tables
DELIMITER //
DROP PROCEDURE IF EXISTS populate_tables //
CREATE PROCEDURE populate_tables()
BEGIN
	INSERT INTO user_account (user_account_id, email, `password`, `role`) VALUES 
    (1, 'redwin23@kharst.game'	 , 'Admin123', 'admin'),
    (2, 'greenwacke1@kharst.game', 'Admin123', 'player'),
    (3, 'blueppereel@kharst.game', 'Admin123', 'player');
END //

-- call procedures
CALL create_tables();
CALL populate_tables();