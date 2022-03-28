require daslib/media

//Виды анимаций
enum AnimState
    IDLE
    RUNNING
    ATTACK
    ROLLING
    DEATH
    TELE

//Куда смотрит персонаж
enum Direction
    UP
    SIDE
    DOWN

    // Анимации в frames идут в следующем порядке:
    // Idle Up, Idle Side, Idle Down,
    // Running Up, Running Side, Running Down,
    // Attack Up, Attack Side, Attack Down
    // Roll Up, Roll Side, Roll Down

class Animator
    animationState: AnimState
    direction     : Direction

    currentFrame  : int // Текущий кадр в рамках проигрываемой анимации    
    frameTime     : float // Сколько времени прошло со смены кадра
    telegraphTime : float
    telegraphCD   : float

    deathAnimation: array<int> // индекс 0 это фпс. Анимация смерти одинаковая вне зависимости в какую сторону смотришь, так что проще её отдельно вынести, ну или мне просто лень
    frames        : array<int> // Кадры анимаций, в соотвествии с порядковым номером спрайта в нашем sprite sheet
    frameCount    : array<int> // Сколько кадров в анимациях для конкретного animationState (Для простоты считаем что все однотипные анимации длятся одинаковое количество кадров)

    fps           : array<float>// Скорость анимации конкретного animationState

    def Animator(framesArray, countArray, deathArray: array<int>; fpsArray: array<float>)
        self -> init(framesArray, countArray, deathArray, fpsArray)

    def init(framesArray, countArray, deathArray: array<int>; fpsArray: array<float>)
        currentFrame = 0
        frameTime    = 0f
        telegraphCD  = 0.5f 

        deathAnimation := deathArray
        if deathAnimation |> length > 0
            deathAnimation |> push(deathAnimation[deathAnimation |> length - 1])
        
        frames     := framesArray
        frameCount := countArray
        fps        := fpsArray

    def FrameIndex: int
        if animationState == AnimState TELE
            return frames[GetFirstFrame(int(AnimState ATTACK))]
        if animationState == AnimState DEATH
            return deathAnimation[1 + currentFrame]
        return frames[GetFirstFrame(GetAnimationState()) + currentFrame]

    def FindState(state: int): int
        var i:int = 0
        if frameCount |> length == 1
            return 0
        for n in range(0, state)
            i += 3 * frameCount[n]
        return i

    def GetAnimationState(): int
        if int(animationState) >= fps |> length
            return fps |> length - 1
        return int(animationState)

    def GetDirection(): int
        if fps |> length == 1
            return 0
        return int(direction)

    def GetFirstFrame(state: int): int
        return FindState(state) + GetDirection() * frameCount[state]

    //def GetLastFrame: int
        //return GetFirstFrame(GetAnimationState()) + frameCount[GetAnimationState()]

    def SetAnimationState(state: AnimState)
        if(animationState != state)
            frameTime    = 0f
            currentFrame = 0
        animationState = state

    def SetTeleTimer(f: float)
        telegraphCD = f
    
    def Animate (directionVector: float2)
        frameTime += get_delta_time()

        if animationState == AnimState DEATH
            if currentFrame < deathAnimation |> length - 2
                if frameTime >= 1f / float(deathAnimation[0])
                    currentFrame++
                    frameTime = 0f
            return
           
        if animationState == AnimState TELE
            if telegraphTime < telegraphCD
                telegraphTime += get_delta_time()
            else
                telegraphTime = 0f
                animationState = AnimState ATTACK
            return

        if directionVector.x != 0f || directionVector.y != 0f
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
                if animationState == AnimState ATTACK || animationState == AnimState ROLLING
                    animationState = AnimState IDLE
                currentFrame = 0