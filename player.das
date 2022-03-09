require daslib/media

require gameObject
require animator
require objectFactory

class public Player: GameObject

    def Player (desc: ObjectDescriptor; position: float2)
        GameObject`GameObject(self, desc, position)

    def override init (desc: ObjectDescriptor; position: float2)
        GameObject`init(self, desc, position)
    
    def override UpdateObject(dt: float): void
        var move = float2(0f,0f)

        speed = baseSpeed

        if get_key(VK_W) || get_key(VK_UP)
            move.y = -1f
        if get_key(VK_S) || get_key(VK_DOWN)
            move.y = 1f
        if get_key(VK_A) || get_key(VK_LEFT)
            move.x = -1f
        if get_key(VK_D) || get_key(VK_RIGHT)
            move.x = 1f

        move = normalize(move)

        if get_key(VK_SPACE) || get_key(VK_SPACE)
            playerAttack()
        else
            playerAct(move, dt)

    def playerAct(move: float2; dt: float)
        pos += move * speed * dt
        setup_2d_camera(pos, 8.0)
        
        if move != float2(0f,0f)
            direction := move
            animator -> SetAnimationState(AnimState RUNNING)
        else
            animator -> SetAnimationState(AnimState IDLE)

    def playerAttack
        print("\nPlayer attack")
        animator -> SetAnimationState(AnimState ATTACK)