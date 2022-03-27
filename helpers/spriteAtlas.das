require daslib/media

require spriteHelper

var
    BANDIT_SPRITE           : ImageHandle <- create_managed_image(BANDIT)
    BANDIT_RANGER_SPRITE    : ImageHandle <- create_managed_image(BANDIT_RANGER)
    BANDIT_LEADER_SPRITE    : ImageHandle <- create_managed_image(BANDIT_LEADER)
    BUTTON_START_SPRITE     : ImageHandle <- create_managed_image(BUTTON_START)
    BUTTON_EXIT_SPRITE      : ImageHandle <- create_managed_image(BUTTON_EXIT)
    DEATH_SCREEN_SPRITE     : ImageHandle <- create_managed_image(DEATH_SCREEN)
    FONT_SPRITE             : ImageHandle <- create_managed_image(FONT)
    ITEMS_SPRITE            : ImageHandle <- create_managed_image(ITEMS)
    INTERATCION_MARK_SPRITE : ImageHandle <- create_managed_image(INTERATCION_MARK)
    HUD_TEST_SPRITE         : ImageHandle <- create_managed_image(HUD_TEST)
    HUD_SHEET_SPRITE        : ImageHandle <- create_managed_image(HUD_SHEET)
    KOLOVERSHI_SPRITE       : ImageHandle <- create_managed_image(KOLOVERSHI)
    NPCS_SPRITE             : ImageHandle <- create_managed_image(NPCS)
    PLAYER_SPRITE           : ImageHandle <- create_managed_image(PLAYER)
    TEST_SPRITE             : ImageHandle <- create_managed_image(TEST)
    TEXT_BOX_SPRITE         : ImageHandle <- create_managed_image(TEXT_BOX)
    TILES_SPRITE            : ImageHandle <- create_managed_image(TILES)
    TITLE_SCREEN_SPRITE     : ImageHandle <- create_managed_image(TITLE_SCREEN) 
    TORCHES_SPRITE          : ImageHandle <- create_managed_image(TORCHES)
    VERLIOKA_SPRITE         : ImageHandle <- create_managed_image(VERLIOKA)
    WEAPON_CLUB_SPRITE      : ImageHandle <- create_managed_image(WEAPON_CLUB)
    WEAPON_MACE_SPRITE      : ImageHandle <- create_managed_image(WEAPON_MACE)
    WEAPON_AXE_SPRITE       : ImageHandle <- create_managed_image(WEAPON_AXE)
    WEAPON_SWORD_SPRITE     : ImageHandle <- create_managed_image(WEAPON_SWORD)
    STATIC_OBJECTS_SPRITE   : ImageHandle <- create_managed_image(STATIC_OBJECTS)
    MOVABLE_OBJECTS_SPRITE  : ImageHandle <- create_managed_image(MOVABLE_OBJECTS)
    DOORS_SPRITE            : ImageHandle <- create_managed_image(DOORS)

    OBJECT_SPRITES = [[ImageHandle[10] PLAYER_SPRITE; BANDIT_SPRITE; BANDIT_RANGER_SPRITE; BANDIT_LEADER_SPRITE;
                    KOLOVERSHI_SPRITE; NPCS_SPRITE; VERLIOKA_SPRITE; STATIC_OBJECTS_SPRITE; MOVABLE_OBJECTS_SPRITE;
                    DOORS_SPRITE ]]
    OBJECT_NAMES = [[string[10] "player"; "bandit"; "bandit_ranger"; "bandit_leader";
                    "kolovershi"; "npcs"; "verlioka"; "static_objects"; "movable_objects";
                    "doors" ]]

def GetObjectSprite(fileName: string): ImageHandle
    for i in range(0, OBJECT_NAMES|> length)
        if OBJECT_NAMES[i] == fileName
            return OBJECT_SPRITES[i]
    return INTERATCION_MARK_SPRITE
