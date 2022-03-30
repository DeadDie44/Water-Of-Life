require daslib/media

require soundHelper

var
    END_THEME_MUSIC      : PcmSound <- create_sound(END_THEME)
    GRASS_THEME_MUSIC    : PcmSound <- create_sound(GRASS_THEME)
    PROLOGUE_THEME_MUSIC : PcmSound <- create_sound(PROLOGUE_THEME)
    TITLE_THEME_MUSIC    : PcmSound <- create_sound(TITLE_THEME)

    ATTACK1_SOUND      : PcmSound <- create_sound(ATTACK1)
    FIREBALL_SOUND     : PcmSound <- create_sound(FIREBALL)
    DEATH_SCREEN_SOUND : PcmSound <- create_sound(DEATH_SCREEN)
    BOSS_DEATH_SOUND   : PcmSound <- create_sound(BOSS_DEATH)
    BOSS_PAIN_SOUND    : PcmSound <- create_sound(BOSS_PAIN)
    GRUNT1_SOUND       : PcmSound <- create_sound(GRUNT1)
    GRUNT2_SOUND       : PcmSound <- create_sound(GRUNT2)

    PAIN1_SOUND       : PcmSound <- create_sound(PAIN1)
    PAIN2_SOUND       : PcmSound <- create_sound(PAIN2)
    PAIN3_SOUND       : PcmSound <- create_sound(PAIN3)
    PAIN4_SOUND       : PcmSound <- create_sound(PAIN4)

    PICK_UP_SOUND      : PcmSound <- create_sound(PICK_UP)

    HIT_SOUND        : PcmSound <- create_sound(HIT)
    STONE_HIT_SOUND  : PcmSound <- create_sound(STONE_HIT)
    TOTEM_DEATH_SOUND: PcmSound <- create_sound(TOTEM_DEATH)

    HIT_WOOD_SOUND: PcmSound <- create_sound(HIT_WOOD)

/*
    SOUND_ROOT: string = "assets/sfx/sound/"
    MUSIC_ROOT: string = "assets/sfx/music/"

    TITLE_THEME: string = MUSIC_ROOT + "title.mp3"
    GRASS_THEME: string = MUSIC_ROOT + "grass.mp3"
    PROLOGUE_THEME: string = MUSIC_ROOT + "prologue.mp3"
    END_THEME: string = MUSIC_ROOT + "thanksForPlaying.mp3"

    ATTACK1: string = SOUND_ROOT + "attack1.mp3"
    FIREBALL: string = SOUND_ROOT + "fireball.mp3"
    DEATH_SCREEN: string = SOUND_ROOT + "gameOver.mp3"
    BOSS_DEATH: string = SOUND_ROOT + "boosDeath.mp3"

    GRUNT1: string = SOUND_ROOT + "grunt1.mp3"
*/