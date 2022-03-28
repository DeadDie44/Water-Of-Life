require daslib/media

require spriteHelper

var
    BUTTON_START_SPRITE     : ImageHandle <- create_managed_image(BUTTON_START)
    BUTTON_EXIT_SPRITE      : ImageHandle <- create_managed_image(BUTTON_EXIT)
    DEATH_SCREEN_SPRITE     : ImageHandle <- create_managed_image(DEATH_SCREEN)
    FONT_SPRITE             : ImageHandle <- create_managed_image(FONT)
    ITEMS_SPRITE            : ImageHandle <- create_managed_image(ITEMS)
    INTERATCION_MARK_SPRITE : ImageHandle <- create_managed_image(INTERATCION_MARK)
    HUD_TEST_SPRITE         : ImageHandle <- create_managed_image(HUD_TEST)
    HUD_SHEET_SPRITE        : ImageHandle <- create_managed_image(HUD_SHEET)
    TEST_SPRITE             : ImageHandle <- create_managed_image(TEST)
    TEXT_BOX_SPRITE         : ImageHandle <- create_managed_image(TEXT_BOX)
    TILES_SPRITE            : ImageHandle <- create_managed_image(TILES)
    TITLE_SCREEN_SPRITE     : ImageHandle <- create_managed_image(TITLE_SCREEN) 
    TORCHES_SPRITE          : ImageHandle <- create_managed_image(TORCHES)
    WEAPON_CLUB_SPRITE      : ImageHandle <- create_managed_image(WEAPON_CLUB)
    WEAPON_MACE_SPRITE      : ImageHandle <- create_managed_image(WEAPON_MACE)
    WEAPON_AXE_SPRITE       : ImageHandle <- create_managed_image(WEAPON_AXE)
    WEAPON_SWORD_SPRITE     : ImageHandle <- create_managed_image(WEAPON_SWORD)
    DOORS_SPRITE            : ImageHandle <- create_managed_image(DOORS)
    PROLOGUE_SPRITE         : ImageHandle <- create_managed_image(PROLOGUE)
    PROJECTILES_SPRITE      : ImageHandle <- create_managed_image(PROJECTILES)


    OBJECT_TABLE <- {{ "player" => create_managed_image(PLAYER); "bandit" => create_managed_image(BANDIT); "bandit_ranger" => create_managed_image(BANDIT_RANGER);
    "bandit_leader" => create_managed_image(BANDIT_LEADER); "kolovershi" => create_managed_image(KOLOVERSHI); "npcs" => create_managed_image(NPCS); "verlioka" => create_managed_image(VERLIOKA);
    "static_objects" => create_managed_image(STATIC_OBJECTS); "movable_objects" => create_managed_image(MOVABLE_OBJECTS); "doors" => create_managed_image(DOORS) }}

    DECORATION_TABLE <- {{ "bush1" => create_image(BUSH1); "bush2" => create_image(BUSH2); "bush3" => create_image(BUSH3);
    "tree1" => create_image(TREE1); "tree2" => create_image(TREE2); "tree3" => create_image(TREE3); "izbushka" => create_image(IZBUSHKA)}}