let
    //Состояния анимации персонажей
    CHARACTER_IDLE: int = 0
    CHARACTER_RUNNING: int = 1
    CHARACTER_ATTACK: int = 2

class Animator
    animationState: int

    frameTime: float
    fps: float = 12f

    currentAnimation: array<int>
    
    idleAnimationUp = [[int[1]18]]
    idleAnimationSide = [[int[1]19]]
    idleAnimationDown = [[int[1]20]]

    runAnimationUp = [[int[8]18;0;1;2;18;3;4;5]]
    runAnimationSide = [[int[8]19;6;7;8;19;9;10;11]]
    runAnimationDown = [[int[8]20;12;13;14;20;15;16;17]]
    
    attackAnimationUp = [[int[7]35;36;37;38;39;40;41]]
    attackAnimationSide = [[int[7]42;43;44;45;46;47;48]]
    attackAnimationDown = [[int[7]28;29;30;31;32;33;34]]

    def Animator()
        self -> init()
        return

    def init()
        currentAnimation <- idleAnimationUp[0..(idleAnimationUp |> length)]
        print("Animator initialized")

    def SetAnimationState(state: int; f:float)
        fps = f
        animationState = state

    def Animate (direction: float2)
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
