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


CALL gameplay_move_in_direction(@tayer_character, 'w');
CALL item_pick_up(@tayer_character, 55);
CALL gameplay_move_in_direction(@tayer_character, 's');
CALL gameplay_navigate_doorway(@tayer_character);

CALL score_get(@tayer_character);
CALL gameplay_navigate_doorway(@tayer_character);
CALL score_get(@tayer_character);
CALL gameplay_navigate_doorway(@tayer_character);
CALL score_get(@tayer_character); 