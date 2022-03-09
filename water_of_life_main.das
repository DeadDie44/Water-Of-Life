require daslib/media

require mySpriteAtlas
require gameMap
require objectManager

// options debugger            // uncomment for debug in VS Code
// require daslib/debug        // uncomment for debug in VS Code

var
    GameOn: bool = false
    tiles: ImageHandle
    myMap = new GameMap()

// 'initialize' runs once when game starts and every hot-reload
[export]
def initialize
    set_window_title("Water of Life")
    tiles <- create_managed_image(TILES)
    setup_2d_camera(float2(get_screen_width() / 8, get_screen_height() / 8), 4.0)
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
    set_font_name("mono")  // set_font_name("mono"), set_font_name("sans"), set_font_name("*.ttf")
    set_font_size(24)

    text_out(0f, 0f, "It's Game man", 0xFFFFFFFF)
    disable_alpha_blend()