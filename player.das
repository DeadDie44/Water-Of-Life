require daslib/media

require objects/gameCharacter
require graphics/mySpriteAtlas
require graphics/Animation/animationHelper
require objects/Physics/collisionHelper

class public Player: GameCharacter
    
    def Player
        self -> init()

    def init
        speed = 75f
        currentFrame = 0
        fps = 12f

        animationState = CHARACTER_IDLE

        idleAnimationUp = [[int[1]25]]
        idleAnimationDown = [[int[1]26]]
        idleAnimationSide = [[int[1]24]]

        runAnimationUp = [[int[8]25;0;1;2;25;3;4;5]]
        runAnimationDown = [[int[8]26;12;13;14;26;15;16;17]]
        runAnimationSide = [[int[8]24;6;7;8;24;9;10;11]]

        attackAnimationUp = [[int[7]35;36;37;38;39;40;41]]
        attackAnimationDown = [[int[7]28;29;30;31;32;33;34]]
        attackAnimationSide = [[int[7]42;43;44;45;46;47;48]]

        print("Player is here x:" + string(pos.y) + " y:" + string(pos.y))
        spriteSheet <- create_managed_image(PLAYER)
        currentAnimation <- idleAnimationDown[0..idleAnimationDown |> length]
        currentFrame = 0
        direction = float2(0f,-1f)
        colliderType = COLLIDER_RECTANGLE
        colliderSize = 10f

    def playerMove(move: float2; dt: float)
        pos += move * speed * dt
        if move != float2(0f,0f)
            direction := move
            animationState = CHARACTER_RUNNING
            fps = 12f
        else
            animationState = CHARACTER_IDLE
            fps = 12f

    def playerAttack
        animationState = CHARACTER_ATTACK
        fps = 32f

    def DrawPlayer()
        Animate()
        if currentFrame >= currentAnimation |> length
            currentFrame = 0
    
        if direction == float2(1f,0f)
            draw_image_transformed(spriteSheet, pos.x + PLAYER_SIZE / 2f, pos.y - PLAYER_SIZE / 2f,
            getSpriteRect(currentAnimation[currentFrame]), 0xFFFFFFFF, float2(-PLAYER_SIZE,PLAYER_SIZE), 
            0f, 0f, 0f)
        else
            draw_image_region(spriteSheet, pos.x - PLAYER_SIZE / 2f, pos.y - PLAYER_SIZE / 2f, 
            getSpriteRect(currentAnimation[currentFrame]))


        setup_2d_camera(pos, 8.0)
        frameTime += get_delta_time()

        if showCollider
            if colliderType == COLLIDER_CIRCLE
                fill_circle(pos.x, pos.y, colliderSize,0x44FFFFFF)
            if colliderType == COLLIDER_RECTANGLE
                fill_circle(pos.x, pos.y, colliderSize,0x44FFFFFF)
                fill_rect(pos.x - colliderSize, pos.y - colliderSize, colliderSize*2f, colliderSize*2f,0x44FFFFFF)
        

        //fill_rect(pos.x - PLAYER_SIZE / 2f , pos.y - PLAYER_SIZE / 2f, PLAYER_SIZE, PLAYER_SIZE,0x44FFFFFF)
        //fill_circle(pos.x, pos.y, 16f,0x44FFFFFF)
        //fill_circle(pos.x, pos.y, 24f,0x44FF2222)

        if frameTime >= 1f/fps
            currentFrame++
            frameTime = 0f

    def Animate
        var i:int = 0
        if animationState == CHARACTER_IDLE
            if direction.y < 0f
                currentAnimation <- idleAnimationUp[0..(idleAnimationUp |> length)]
            elif direction.y > 0f
                currentAnimation <- idleAnimationDown[0..(idleAnimationDown |> length)]
            elif direction.x != 0f
                currentAnimation <- idleAnimationSide[0..(idleAnimationSide|> length)]
        elif animationState == CHARACTER_RUNNING
            if direction.y < 0f
                currentAnimation <- runAnimationUp[0..(runAnimationUp |> length)]
            elif direction.y > 0f
                currentAnimation <- runAnimationDown[0..(runAnimationDown |> length)]
            elif direction.x != 0f
                currentAnimation <- runAnimationSide[0..(runAnimationSide |> length)]
        elif animationState == CHARACTER_ATTACK
            if direction.y < 0f
                currentAnimation <- attackAnimationUp[0..(attackAnimationUp |> length)]
            elif direction.y > 0f
                currentAnimation <- attackAnimationDown[0..(attackAnimationDown |> length)]
            elif direction.x != 0f
                currentAnimation <- attackAnimationSide[0..(attackAnimationSide |> length)]

    def getSpriteRect(spriteIndex: int): float4
        var x, y: float

        x = float(spriteIndex % 8)
        y = float(spriteIndex / 8)

        return float4(x * PLAYER_SIZE, y * PLAYER_SIZE, PLAYER_SIZE, PLAYER_SIZE)