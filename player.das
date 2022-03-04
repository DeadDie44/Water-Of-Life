require daslib/media

require Objects/gameCharacter
require Graphics/mySpriteAtlas
require Graphics/Animation/animationHelper

class public Player: GameCharacter
    speed:float = 75f
    currentFrame:int = 0
    fps:float = 12f
    frameTime:float
    direction:int2

    public animationState: int = CHARACTER_IDLE

    idleAnimationUp = [[int[1]25]]
    idleAnimationDown = [[int[1]26]]
    idleAnimationLeft = [[int[1]24]]
    idleAnimationRight = [[int[1]27]]

    runAnimationUp = [[int[8]25;0;1;2;25;3;4;5]]
    runAnimationDown = [[int[8]26;12;13;14;26;15;16;17]]
    runAnimationLeft = [[int[8]24;6;7;8;24;9;10;11]]
    runAnimationRight = [[int[8]27;18;19;20;27;21;22;23]]

    attackAnimationUp = [[int[5]28;29;30;31;32]]
    attackAnimationDown = [[int[8]28;29;30;31;32;33;34;35]]
    attackAnimationLeft = [[int[5]28;29;30;31;32]]
    attackAnimationRight = [[int[5]28;29;30;31;32]]

    currentAnimation: array<int>

    def Player()
        self -> init()
        return

    def init
        print("Player is here x:" + string(pos.y) + " y:" + string(pos.y))
        spriteSheet <- create_managed_image(PLAYER)
        currentAnimation <- idleAnimationDown[0..idleAnimationDown |> length]
        currentFrame = 0

    def playerMove(move:float2; dt:float)
        pos += move * speed * dt

        if move.x == 0f && move.y == 0f
            if direction.y < 0
                currentAnimation <- idleAnimationUp[0..(idleAnimationUp |> length)]
            elif direction.y > 0
                currentAnimation <- idleAnimationDown[0..(idleAnimationDown |> length)]
            elif direction.x < 0
                currentAnimation <- idleAnimationLeft[0..(idleAnimationLeft |> length)]
            elif direction.x > 0   
                currentAnimation <- idleAnimationRight[0..(idleAnimationRight |> length)]
            return
        if move.y < 0f
            currentAnimation <- runAnimationUp[0..(runAnimationUp |> length)]
        elif move.y > 0f
            currentAnimation <- runAnimationDown[0..(runAnimationDown |> length)]
        elif move.x < 0f
            currentAnimation <- runAnimationLeft[0..(runAnimationLeft |> length)]
        elif move.x > 0f    
            currentAnimation <- runAnimationRight[0..(runAnimationRight |> length)]
        direction := int2(move)

    def playerAttack()
        if direction.y < 0
            currentAnimation <- attackAnimationUp[0..(attackAnimationUp |> length)]
        elif direction.y > 0
            currentAnimation <- attackAnimationDown[0..(attackAnimationDown |> length)]
        elif direction.x < 0
            currentAnimation <- attackAnimationLeft[0..(attackAnimationLeft |> length)]
        elif direction.x > 0   
            currentAnimation <- attackAnimationRight[0..(attackAnimationRight |> length)]

    def DrawPlayer()
        if currentFrame >= currentAnimation |> length
            currentFrame = 0
        draw_image_region(spriteSheet, pos.x - PLAYER_SIZE/2f, pos.y - PLAYER_SIZE/2f, getSpriteRect(currentAnimation[currentFrame]))
        setup_2d_camera(pos, 18.0)
        frameTime += get_delta_time()
        circle(pos.x - 0.5f, pos.y - 0.5f, 8f, 0xFFFFFFFF)
        circle(pos.x - 0.5f, pos.y - 0.5f, 0.5f, 0xFFFFFFFF)
        rect(pos.x - 0.5f, pos.y - 0.5f, 4f, 4f, 0xFFFFFFFF)
        rect(pos.x - 2.5f, pos.y - 2.5f, 5f, 5f, 0xFFFFFFFF)
        if frameTime >= 1f/fps
            currentFrame++
            frameTime = 0f

    def getSpriteRect(spriteIndex: int): float4
        var x, y: float

        x = float(spriteIndex % 8)
        y = float(spriteIndex / 8)

        return float4(x * PLAYER_SIZE, y * PLAYER_SIZE, PLAYER_SIZE, PLAYER_SIZE)