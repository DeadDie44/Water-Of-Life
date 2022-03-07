require daslib/media

require gameCharacter
require mySpriteAtlas
require animationHelper
require collisionHelper

class public Player: GameCharacter
    
    def Player
        self -> init()

    def init
        speed = 75f
        currentFrame = 0
        fps = 12f

        animationState = CHARACTER_IDLE

        idleAnimationUp = [[int[1]18]]
        idleAnimationSide = [[int[1]19]]
        idleAnimationDown = [[int[1]20]]
        

        runAnimationUp = [[int[8]18;0;1;2;18;3;4;5]]
        runAnimationSide = [[int[8]19;6;7;8;19;9;10;11]]
        runAnimationDown = [[int[8]20;12;13;14;20;15;16;17]]
        

        attackAnimationUp = [[int[7]35;36;37;38;39;40;41]]
        attackAnimationSide = [[int[7]42;43;44;45;46;47;48]]
        attackAnimationDown = [[int[7]28;29;30;31;32;33;34]]
        

        print("Player is here x:" + string(pos.y) + " y:" + string(pos.y))
        spriteSheet <- create_managed_image(PLAYER)
        shadowSprite <- create_image(CHARACTER_SHADOW)
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
    
        draw_image(shadowSprite, pos.x - PLAYER_SIZE / 2f, pos.y - PLAYER_SIZE / 2f)
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