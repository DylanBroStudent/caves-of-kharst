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