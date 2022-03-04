require daslib/media

require Objects/gameCharacter
require Graphics/mySpriteAtlas
require Graphics/Animation/animationHelper

class public Player: GameCharacter
    speed:float = 65f
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

    currentAnimation: array<int>

    def Player()
        self -> init()
        return

    def init
        print("Player is here")
        spriteSheet <- create_managed_image(PLAYER)
        currentAnimation <- idleAnimationUp[0..idleAnimationUp |> length]
        currentFrame = 0

    def playerMove(move:float2; dt:float)
        pos += move * speed * dt

        if move.x == 0f && move.y == 0f
            if direction.y < 0
                currentAnimation <- idleAnimationUp[0..(idleAnimationUp |> length)]
            elif direction.y > 0
                currentAnimation <- idleAnimationDown[0..(idleAnimationDown |> length)]
            if direction.x > 0
                currentAnimation <- idleAnimationRight[0..(idleAnimationRight |> length)]
            elif direction.x < 0   
                currentAnimation <- idleAnimationLeft[0..(idleAnimationLeft |> length)]
            return
        if move.y < 0f
            currentAnimation <- runAnimationUp[0..(runAnimationUp |> length)]
        elif move.y > 0f
            currentAnimation <- runAnimationDown[0..(runAnimationDown |> length)]
        if move.x > 0f
            currentAnimation <- runAnimationRight[0..(runAnimationRight |> length)]
        elif move.x < 0f    
            currentAnimation <- runAnimationLeft[0..(runAnimationLeft |> length)]
        direction := int2(move)

    def DrawPlayer()
        if currentFrame >= currentAnimation |> length
            currentFrame = 0
        draw_image_region(spriteSheet, pos.x - 16f, pos.y - 16f, getTileRect(currentAnimation[currentFrame]))
        setup_2d_camera(pos, 4.0)
        frameTime += get_delta_time()
        if frameTime >= 1f/fps
            currentFrame++
            frameTime = 0f

    def getTileRect(spriteIndex: int): float4
        var x, y: int

        x = spriteIndex % 8
        y = spriteIndex / 8

        return float4(x * 32, y * 32, 32, 32)