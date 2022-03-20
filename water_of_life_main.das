require daslib/media

require helpers/spriteHelper
require helpers/soundHelper
require gameMap
require objectManager

// options debugger            // uncomment for debug in VS Code
// require daslib/debug        // uncomment for debug in VS Code
options log

var
    GameOn      : bool = false
    cameraCenter: float2

    buttonExit : ImageHandle
    buttonStart: ImageHandle
    titleScreen: ImageHandle

    music : PcmSound

// 'initialize' runs once when game starts and every hot-reload
[export]
def initialize
    set_window_title("Water of Life")
    //set_resolution(get_desktop_width(), get_desktop_height())

    titleScreen <- create_managed_image(TITLE_SCREEN)
    buttonStart <- create_managed_image(BUTTON_START)
    buttonExit  <- create_managed_image(BUTTON_EXIT)

    music <- create_sound(TITLE_THEME)

    cameraCenter = float2(float(titleScreen.width / 2), float(titleScreen.height / 2) - float(get_screen_height() / 16 - titleScreen.height / 16))
    setup_2d_camera(cameraCenter, float(get_screen_height() / 270 * 2))
    InitMap()
    InitObjectContainer()
    music |> play_sound_loop()
    return

// this function is called to update game data,
// dt - time elapsed since the previous update (in seconds)
[export]
def act(dt: float)
    if GameOn
        if get_key(VK_ESCAPE)
            schedule_quit_game()
        UpdateObjects(dt)
        setup_2d_camera(GetPlayer().pos, float(get_screen_width()/270))
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
        DrawGameMap()
        DrawObjects()
        disable_alpha_blend()
    else
        enable_alpha_blend()
        DrawTitleScreen()
        draw_image(buttonStart, 290f, 75f)
        draw_image(buttonExit, 290f, 155f)
        disable_alpha_blend()
    
def DisplayText(pos:float2; text:string; size: int)
    set_font_name("assets/fonts/SquareCaps.ttf")  // set_font_name("mono"), set_font_name("sans"), set_font_name("*.ttf")
    set_font_size(size)
    text_out(pos.x, pos.y, text, 0xFFFFFFFF)

def DrawTitleScreen
    draw_image(titleScreen, 0f,0f)

def HandleTitleMenu
    if get_key(VK_S) || get_key(VK_RETURN)
        Start()
    if get_key(VK_E) || get_key(VK_ESCAPE) 
        Exit()
    if get_mouse_button_down(MB_LEFT)
        if PointRec(screen_to_world(get_mouse_position()), float4(290f,75f,100f,30f))
            Start() 
        elif PointRec(screen_to_world(get_mouse_position()), float4(290f,155f,100f,30f))
            Exit()

def Start
    print("\nStart!")
    GameOn = true
    stop_all_sounds()
    music <- create_sound(GRASS_THEME)
    music |> play_sound_loop(0.25f)

def Exit
    schedule_quit_game()

def PointRec(pos: float2; rect: float4): bool
    return pos.x >= rect.x && pos.x <= rect.x + rect.z && pos.y >= rect.y && pos.y <= rect.y + rect.w