require daslib/media

//Виды анимаций
enum AnimState
    IDLE
    RUNNING
    ATTACK
    DEATH

//Куда смотрит персонаж
enum Direction
    UP
    SIDE
    DOWN

class Animator
    animationState: AnimState
    direction     : Direction

    currentFrame  : int // Текущий кадр в рамках проигрываемой анимации    
    frameTime     : float // Сколько времени прошло со смены кадра

    deathAnimation: array<int> // индекс 0 это фпс. Анимация смерти одинаковая вне зависимости в какую сторону смотришь, так что проще её отдельно вынести, ну или мне просто лень
    frames        : array<int> // Кадры ориентированных анимаций, в соотвествии с порядковым номером спрайта в нашем sprite sheet
    frameCount    : array<int> // Сколько кадров в анимациях для конкретного animationState (Для простоты считаем что все однотипные анимации длятся одинаковое количество кадров)

    fps           : array<float>// Скорость анимации конкретного animationState

    def Animator(framesArray, countArray, deathArray: array<int>; fpsArray: array<float>)
        self -> init(framesArray, countArray, deathArray, fpsArray)

    def init(framesArray, countArray, deathArray: array<int>; fpsArray: array<float>)
        currentFrame = 0
        frameTime    = 0f

        deathAnimation := deathArray
        
        frames     := framesArray
        frameCount := countArray
        fps        := fpsArray

    def SetAnimationState(state: AnimState)
        if(animationState != state)
            frameTime    = 0f
            currentFrame = 0
        animationState = state

    def GetAnimationState(): int
        if (int(animationState) > fps |> length)
            return fps |> length
        return int(animationState)

    def GetDirection(): int
        if (int(direction) > fps |> length)
            return fps |> length - 1
        return int(direction)

    def FrameIndex: int
        if animationState != AnimState DEATH
            return frames[GetFirstFrame() + currentFrame]
        else
            return deathAnimation[1 + currentFrame]

    // Анимации в frames идут в следующем порядке:
    // Idle Up, Idle Side, Idle Down,
    // Running Up, Running Side, Running Down,
    // Attack Up, Attack Side, Attack Down
    def GetFirstFrame: int
        return FindState() + GetDirection() * frameCount[GetAnimationState()]  

    def FindState(): int
        var i:int = 0
        if frameCount |> length == 1
            return 0
        for n in range(0, GetAnimationState())
            i += frameCount |> length * frameCount[n]

        return i

    def GetLastFrame: int
        return GetFirstFrame() + frameCount[GetAnimationState()]

    def Animate (directionVector: float2)
        frameTime += get_delta_time()

        if animationState == AnimState DEATH
            if currentFrame < deathAnimation |> length - 2
                if frameTime >= 1f / float(deathAnimation[0])
                    currentFrame++
                    frameTime = 0f
            return

        if abs(directionVector.x) > abs(directionVector.y)
            direction = Direction SIDE
        elif directionVector.y < 0f
            direction = Direction UP
        elif directionVector.y > 0f
            direction = Direction DOWN

        if frameTime >= 1f/fps[GetAnimationState()]
            currentFrame++
            frameTime = 0f
            if currentFrame >= frameCount[GetAnimationState()]
                if animationState == AnimState ATTACK
                    animationState = AnimState IDLE
                currentFrame = 0