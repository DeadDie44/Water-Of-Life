require daslib/media

require spriteHelper
require gameMap
require objectManager

// options debugger            // uncomment for debug in VS Code
// require daslib/debug        // uncomment for debug in VS Code
options log

var
    GameOn: bool = false
    tiles: ImageHandle
    titleScreen: ImageHandle
    myMap = new GameMap()

// 'initialize' runs once when game starts and every hot-reload
[export]
def initialize
    set_window_title("Water of Life")
    //set_resolution(get_desktop_width(), get_desktop_height())
    tiles <- create_managed_image(TILES)
    titleScreen <- create_managed_image(TITLE_SCREEN)
    //setup_2d_camera(float2(get_screen_width() / 4, get_screen_height() /4), 4.0)
    InitObjectContainer()
    GameOn = true

    return

// this function is called to update game data,
// dt - time elapsed since the previous update (in seconds)
[export]
def act(dt: float)
    if get_key(VK_ESCAPE)
        schedule_quit_game()
    if (GameOn)
        UpdateObjects(dt)

    return

// this function will be called every frame after 'act',
// you can draw anything in this function
[export]
def draw
    enable_alpha_blend()
    myMap -> DrawGameMap(tiles)
    DrawObjects()
    DrawTitleScreen()
    disable_alpha_blend()

def DisplayText(pos:float2; text:string; size: int)
    set_font_name("mono")  // set_font_name("mono"), set_font_name("sans"), set_font_name("*.ttf")
    set_font_size(size)
    text_out(pos.x, pos.y, text, 0xFFFFFFFF)

def DrawTitleScreen()
    draw_image(titleScreen, 0f,0f)