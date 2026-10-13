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
-- \\character_play(player_character_id_in)
CALL character_play(@tadmin_character);
-- check parties
-- SELECT * FROM party;
-- View that lobby's tiles and entities
-- CALL debug_view_room(1);

-- Update character colour
-- SELECT player_character_id INTO @character_id FROM player_character WHERE `name` = "Tadmin";

-- Check original colour
-- SELECT player_character_id, `name`, hue 
-- FROM player_character 
-- WHERE player_character_id = @character_id;

-- Update character colour
-- CALL character_update_colour(@character_id, 180);

-- Check updated colour
-- SELECT player_character_id, `name`, hue 
-- FROM player_character 
-- WHERE player_character_id = @character_id;



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

-- Play game (creates Tayer's original party and lobby)
CALL character_play(@tayer_character);

-- Get Tayer's original party
-- SELECT party_id
-- INTO @old_party_id
-- FROM player_character
-- WHERE player_character_id = @tayer_character;

-- Save the original lobby and game IDs
-- SELECT room_instance_id, game_id
-- INTO @old_room_id, @old_game_id
-- FROM party
-- WHERE party_id = @old_party_id;

-- Check parties and Tayer's room
-- SELECT * FROM party;
-- CALL debug_view_room(@old_room_id);

-- Invite Tayer to Tadmin's party
SELECT party_id 
INTO @tadmin_party_id
FROM player_character
WHERE user_account_id = @tadmin_character;

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

-- Invite Tadmin to Tayer's party
SELECT party_id 
INTO @tayer_party_id
FROM player_character
WHERE user_account_id = @tayer_character;

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

-- get tayer's new data
SELECT
    pc.player_character_id,
    pc.party_id,
    p.room_instance_id
INTO
    @tayer_id,
    @tayer_party_id,
    @tayer_room_id
FROM player_character AS pc
JOIN party AS p
    ON p.party_id = pc.party_id
WHERE pc.`name` = 'Tayer';

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

CALL room_get(@tadmin_character);
CALL party_toggle_ready(@tadmin_character);
CALL party_toggle_ready(@tayer_character);

CALL debug_view_room(@tayer_room_id);
DO sleep(11);
CALL debug_view_room(@tayer_room_id);

