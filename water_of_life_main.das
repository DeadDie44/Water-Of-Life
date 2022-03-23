require daslib/media

require helpers/spriteHelper
require helpers/soundHelper
require hud
require gameMap
require objectManager
require myFont
require collisionManager

// options debugger            // uncomment for debug in VS Code
// require daslib/debug        // uncomment for debug in VS Code
options log

var
    GameOn      : bool = false
    cameraCenter: float2

    buttonExit : Image
    buttonStart: Image
    titleScreen: Image

    music : PcmSound

// 'initialize' runs once when game starts and every hot-reload
[export]
def initialize
    set_window_title("Water of Life")
    //set_resolution(get_desktop_width(), get_desktop_height())

    titleScreen <- create_image(TITLE_SCREEN)
    buttonStart <- create_image(BUTTON_START)
    buttonExit  <- create_image(BUTTON_EXIT)

    music <- create_sound(TITLE_THEME)

    cameraCenter = float2(float(titleScreen.width / 2), float(titleScreen.height / 2) - float(get_screen_height() / 16 - titleScreen.height / 16))
    setup_2d_camera(cameraCenter, float(get_screen_height() / 270 * 2))
    InitFont()
    InitMap()
    InitObjectContainer()
    InitDecorations()
    InitText(0)
    music |> play_sound_loop(0.5f)
    return

// this function is called to update game data,
// dt - time elapsed since the previous update (in seconds)
[export]
def act(dt: float)
    if GameOn
        if get_key(VK_ESCAPE)
            schedule_quit_game()
        if get_key_up(VK_SPACE)
            ScrollText()
        UpdateObjects(dt)
        setup_2d_camera(GetPlayer().pos, float(get_screen_width() / 270))
        RemoveObjects()
    else
        HandleTitleMenu()
    return

// this function will be called every frame after 'act',
// you can draw anything in this function
[export]
def draw 
    if GameOn
        enable_alpha_blend()
        DrawGameMap(GetDrawArea())
        DrawObjects()
        DrawDecorations()
        DrawHud(GetPlayer().pos, GetPlayer() -> GetCurrentHealth(), GetPlayer() -> GetHealthCap(), GetPlayer() -> GetCurrentStamina(), GetPlayer() -> GetStaminaCap(), GetPlayer() -> GetWeapon())
        DrawText(GetPlayer().pos)
        disable_alpha_blend()
    else
        enable_alpha_blend()
        DrawTitleScreen()
        draw_image(buttonStart, 290f, 75f)
        draw_image(buttonExit, 290f, 155f)
        disable_alpha_blend()

def DrawTitleScreen
    draw_image(titleScreen, 0f,0f)

def HandleTitleMenu
    if get_key(VK_S) || get_key(VK_RETURN)
        Start()
    if get_key(VK_E) || get_key(VK_ESCAPE) 
        schedule_quit_game()
    if get_mouse_button_down(MB_LEFT)
        var mousePos = screen_to_world(get_mouse_position())
        if PointRect(mousePos, float4(290f,75f,100f,30f))
            Start()
            hide_mouse_cursor()
        elif PointRect(mousePos, float4(290f,155f,100f,30f))
            schedule_quit_game()

def Start
    print("\nStart!")
    InitHUD()
    GameOn = true
    stop_all_sounds()
    music <- create_sound(GRASS_THEME)
    music |> play_sound_loop(0.25f)