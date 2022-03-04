require daslib/media

require Graphics/mySpriteAtlas
require Map/gameMap
require Util/Util
require player

// options debugger            // uncomment for debug in VS Code
// require daslib/debug        // uncomment for debug in VS Code

var
    GameOn: bool = false
    tiles: ImageHandle
    myMap = new GameMap()
    player = new Player()
        

// 'initialize' runs once when game starts and every hot-reload
[export]
def initialize
    set_window_title("Water of Life")
    tiles <- create_managed_image(TILES)

    setup_2d_camera(float2(get_screen_width() / 8, get_screen_height() / 8), 4.0)

    GameOn = true

    return

// this function is called to update game data,
// dt - time elapsed since the previous update (in seconds)
[export]
def act(dt: float)
    if get_key(VK_ESCAPE)
        schedule_quit_game()
    //if get_key(VK_SPACE)
    if (GameOn)
        var move: float2

        if get_key(VK_W) || get_key(VK_UP)
            move.y = -1f
        if get_key(VK_S) || get_key(VK_DOWN)
            move.y = 1f
        if get_key(VK_A) || get_key(VK_LEFT)
            move.x = -1f
        if get_key(VK_D) || get_key(VK_RIGHT)
            move.x = 1f

        move = normalize(move)

        player -> playerMove(move, dt)

    return

// this function will be called every frame after 'act',
// you can draw anything in this function
[export]
def draw
    //print("Draw")
    enable_alpha_blend()
    myMap -> DrawGameMap(tiles)
    player -> DrawPlayer()
    disable_alpha_blend()
    //if GameOn
        //myMap -> DrawGameMap(tiles)
    return