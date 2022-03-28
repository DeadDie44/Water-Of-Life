require daslib/media

require helpers/spriteAtlas
require helpers/soundHelper
require helpers/textHelper
require hud
require gameMap
require objectManager
require myFont
require collisionManager
require questManager

//options debugger            // uncomment for debug in VS Code
//require daslib/debug        // uncomment for debug in VS Code
options log

var
    gameOn      : bool = false
    prologue    : bool = true
    epilogue    : bool = false
    death       : bool = false
    DialogOn    : bool = false
    
    prologueScroll: float2
    cameraCenter: float2

    music : PcmSound

// 'initialize' runs once when game starts and every hot-reload
[export]
def initialize
    set_window_title("Water of Life")

    FisrstStart()

    cameraCenter = float2(float(TITLE_SCREEN_SPRITE.width / 2), float(TITLE_SCREEN_SPRITE.height / 2) - float(get_screen_height() / 16 - TITLE_SCREEN_SPRITE.height / 16))
    setup_2d_camera(cameraCenter, float(get_screen_height() / 270 * 2))
    PlayMusic(TITLE_THEME, 0.5f)
    show_mouse_cursor()
    return

// this function is called to update game data,
// dt - time elapsed since the previous update (in seconds)
[export]
def act(dt: float)
    if get_key(VK_ESCAPE)
        Exit()
    if epilogue 
        return
    if gameOn
        if prologue
            HandlePrologue()
            if ! prologue
                PlayMusic(GRASS_THEME, 0.25f)
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
                UpdateObjects(dt, epilogue)
                UpdateNPCs(dt, DialogOn)
                setup_2d_camera(GetPlayer().pos, float(get_screen_height() / 270 * 2))
    else
        HandleTitleMenu()
    return

// this function will be called every frame after 'act',
// you can draw anything in this function
[export]
def draw
    enable_alpha_blend()
    if epilogue
        DrawText("To be continued..", GetPlayer().pos - float2(40f,0f), 0)
        DrawText("Thank you for playing!", GetPlayer().pos - float2(55f,15f), 0)
        return
    if death
        draw_image(DEATH_SCREEN_SPRITE, GetPlayer().pos.x - float(DEATH_SCREEN_SPRITE.width / 2), GetPlayer().pos.y - float(DEATH_SCREEN_SPRITE.height / 2), 0xFFFFFFFF)
    else
        if gameOn
            if !prologue
                DrawGameMap(GetDrawArea())
                
                DrawObjects()
                if GetPlayer() != null
                    DrawHud(GetPlayer().pos, GetPlayer() -> GetCurrentHealth(), GetPlayer() -> GetHealthCap(), GetPlayer() -> GetCurrentStamina(), GetPlayer() -> GetStaminaCap(), GetPlayer() -> GetWeapon())
                if DialogOn
                    DrawTextBox(GetPlayer().pos)
                
            else
                DrawPrologue(cameraCenter - float2(150f, -80f))
        else
            DrawTitleScreen()
    disable_alpha_blend()

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
    draw_image(PROLOGUE_SPRITE, cameraCenter.x - float(PROLOGUE_SPRITE.width / 2), cameraCenter.y - float(PROLOGUE_SPRITE.height / 2), 0xFFFFFFFF)
    textLines <- ProcessText(textTable["Prologue"])
    for i in range(0, textLines |> length)
        DrawText(textLines[i], pos + prologueScroll, i)

    fill_rect(pos.x - 20f, pos.y, 360f, 20f, 0xFF000000)
    DrawText("'space' to skip", pos, 0)
    DrawText("'arrows' to scroll", pos + float2(175f, 0f), 0)

def DrawTitleScreen
    draw_image(TITLE_SCREEN_SPRITE, 0f,0f)
    draw_image(BUTTON_START_SPRITE, 290f, 75f)
    draw_image(BUTTON_EXIT_SPRITE, 290f, 155f)

def HandlePrologue
    var scroll: float
    if get_key(VK_UP) || get_key(VK_W)
        scroll = - 1f
    if get_key(VK_DOWN) || get_key(VK_S)
        scroll = 1f
    if get_key(VK_SPACE)
        prologue = false

    prologueScroll += float2(0f, scroll - 5f * get_delta_time())
    if prologueScroll.y > -10f
        prologueScroll.y = -10f
    if prologueScroll.y < -580f
        prologue = false

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
    PlayMusic(PROLOGUE_THEME, 0.6f)

def PlayMusic(file: string; volume: float)
    stop_all_sounds()
    music <- create_sound(file)
    music |> play_sound_loop(volume)