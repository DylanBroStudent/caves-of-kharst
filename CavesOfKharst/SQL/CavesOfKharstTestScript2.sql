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



CALL gameplay_move_in_direction(@tayer_character, 'w');
CALL item_pick_up(@tayer_character, @item_id);
CALL gameplay_move_in_direction(@tayer_character, 's');
CALL gameplay_navigate_doorway(@tayer_character);

CALL score_get(@tayer_character);
CALL gameplay_navigate_doorway(@tayer_character);
CALL score_get(@tayer_character);
CALL gameplay_navigate_doorway(@tayer_character);
CALL score_get(@tayer_character); 