require daslib/media

require helpers/spriteHelper
require helpers/soundHelper
require helpers/textHelper
require hud
require gameMap
require objectManager
require myFont
require collisionManager
require questManager

options debugger            // uncomment for debug in VS Code
require daslib/debug        // uncomment for debug in VS Code
options log

var
    gameOn      : bool = false
    prologue    : bool = true
    death       : bool = false
    DialogOn    : bool = false
    
    prologueScroll: float2
    cameraCenter: float2

    buttonExit : Image
    buttonStart: Image
    titleScreen: Image
    deathScreen: Image

    music : PcmSound

// 'initialize' runs once when game starts and every hot-reload
[export]
def initialize
    set_window_title("Water of Life")
    //set_resolution(get_desktop_width(), get_desktop_height())

    titleScreen <- create_image(TITLE_SCREEN)
    buttonStart <- create_image(BUTTON_START)
    buttonExit  <- create_image(BUTTON_EXIT)
    deathScreen <- create_image(DEATH_SCREEN)

    music <- create_sound(TITLE_THEME)

    FisrstStart()

    cameraCenter = float2(float(titleScreen.width / 2), float(titleScreen.height / 2) - float(get_screen_height() / 16 - titleScreen.height / 16))
    setup_2d_camera(cameraCenter, float(get_screen_height() / 270 * 2))
    music |> play_sound_loop(0.5f)
    show_mouse_cursor()
    return

// this function is called to update game data,
// dt - time elapsed since the previous update (in seconds)
[export]
def act(dt: float)
    if get_key(VK_ESCAPE)
        Exit()
    if gameOn
        if prologue
            var scroll: float
            if get_key(VK_UP) || get_key(VK_W)
                scroll = - 1f
            if get_key(VK_DOWN) || get_key(VK_S)
                scroll = 1f
            if get_key(VK_SPACE)
                prologue = false
                music |> play_sound_loop(0.25f)

            prologueScroll += float2(0f, scroll - 5f * get_delta_time())
            if prologueScroll.y > -10f
                prologueScroll.y = -10f
            if prologueScroll.y < -580f
                prologue = false
                music |> play_sound_loop(0.25f)

            return
        if death
            if get_key_up(VK_R)
                refreshWorld = true
                death = false
                return
        else
            if DialogOn
                if !showText
                    showText = true
                if get_key_up(VK_SPACE)
                    ScrollText(DialogOn)
                    print("\nMenuOn {DialogOn}")
                    print("\nInteracting? {GetPlayer().isInteracting}")
            else
                UpdateObjects(dt)
                UpdateNPCs(dt, DialogOn)
                setup_2d_camera(GetPlayer().pos, float(get_screen_height() / 270 * 2))
    else
        HandleTitleMenu()
    return

// this function will be called every frame after 'act',
// you can draw anything in this function
[export]
def draw
    if death
        draw_image(deathScreen, GetPlayer().pos.x - float(deathScreen.width / 2), GetPlayer().pos.y - float(deathScreen.height / 2), 0xFFFFFFFF)
        return

    if gameOn
        if !prologue
            DrawGameMap(GetDrawArea())
            enable_alpha_blend()
            DrawObjects()
            if GetPlayer() != null
                DrawHud(GetPlayer().pos, GetPlayer() -> GetCurrentHealth(), GetPlayer() -> GetHealthCap(), GetPlayer() -> GetCurrentStamina(), GetPlayer() -> GetStaminaCap(), GetPlayer() -> GetWeapon())
            if DialogOn
                DrawTextBox(GetPlayer().pos)
            disable_alpha_blend()
        else
            DrawPrologue(cameraCenter - float2(150f, -80f))
    else
        DrawTitleScreen()

def GameOver
    death = true

def InitGame
    death = false
    var callback = @@ GameOver
    InitObjectContainer(callback)

def FisrstStart
    InitMap()
    InitGame()
    InitFont()
    InitQuests()
    InitItems()
    InitDecorations()

def DrawPrologue(pos: float2)
    textLines <- ProcessText(textTable["Prologue"])
    for i in range(0, textLines |> length)
        DrawText(textLines[i], pos + prologueScroll, i)

    fill_rect(pos.x - 20f, pos.y, 360f, 20f, 0xFF000000)
    DrawText("'space' to skip", pos, 0)
    DrawText("'arrows' to scroll", pos + float2(175f, 0f), 0)
    

def DrawTitleScreen
    draw_image(titleScreen, 0f,0f)
    draw_image(buttonStart, 290f, 75f)
    draw_image(buttonExit, 290f, 155f)

def HandleTitleMenu
    if get_key(VK_S) || get_key(VK_RETURN)
        Start()
    if get_key(VK_E) || get_key(VK_ESCAPE) 
        Exit()
    if get_mouse_button_down(MB_LEFT)
        var mousePos = screen_to_world(get_mouse_position())
        if PointRect(mousePos, float4(290f,75f,100f,30f))
            Start()
            hide_mouse_cursor()
        elif PointRect(mousePos, float4(290f,155f,100f,30f))
            Exit()

def Exit
    show_mouse_cursor()
    schedule_quit_game()

def Start
    print("\nStart!")
    InitHUD()
    gameOn = true
    stop_all_sounds()
    music <- create_sound(GRASS_THEME)
    //music |> play_sound_loop(0.25f)