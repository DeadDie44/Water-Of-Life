require daslib/media

require gameObject
require animator
require mySpriteAtlas

class public Player: GameObject

    def Player
        GameObject`GameObject(self)

    def override init
        GameObject`init(self)
        size = PLAYER_SIZE
        speed = 60f
        print("Player here")
    
    def override UpdateObject(dt: float): void
        var move = float2(0f,0f)

        if get_key(VK_W) || get_key(VK_UP)
            move.y = -1f
        if get_key(VK_S) || get_key(VK_DOWN)
            move.y = 1f
        if get_key(VK_A) || get_key(VK_LEFT)
            move.x = -1f
        if get_key(VK_D) || get_key(VK_RIGHT)
            move.x = 1f

        move = normalize(move)

        playerAct(move, dt)
        if get_key(VK_SPACE) || get_key(VK_SPACE)
            playerAttack()

    def playerAct(move: float2; dt: float)
        pos += move * speed * dt
        setup_2d_camera(pos, 8.0)
        
        if move != float2(0f,0f)
            direction := move
            animator -> SetAnimationState(CHARACTER_RUNNING, 12f)
        else
            animator -> SetAnimationState(CHARACTER_IDLE, 12f)

    def playerAttack
        print("Player attack")
        animator -> SetAnimationState(CHARACTER_ATTACK, 32f)