require daslib/media

//Виды анимаций
enum AnimState
    IDLE
    RUNNING
    ATTACK

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

    frames        : array<int> // Кадры всех анимаций, в соотвествии с порядковым номером спрайта в нашем sprite sheet
    frameCount    : array<int> // Сколько кадров в анимациях для конкретного animationState (Для простоты считаем что все однотипные анимации длятся одинаковое количество кадров)

    fps           : array<float>// Скорость анимации конкретного animationState

    def Animator(framesArray, countArray: array<int>; fpsArray: array<float>)
        self -> init(framesArray, countArray, fpsArray)

    def init(framesArray, countArray: array<int>; fpsArray: array<float>)
        currentFrame = 0
        
        frames     := framesArray
        frameCount := countArray
        fps        := fpsArray

    def SetAnimationState(state: AnimState)
        if(animationState != state)
            currentFrame = 0
        animationState = state

    def FrameIndex: int
        return frames[GetFirstFrame() + currentFrame]

    // Анимации в frames идут в следующем порядке:
    // Idle Up, Idle Side, Idle Down,
    // Running Up, Running Side, Running Down,
    // Attack Up, Attack Side, Attack Down
    def GetFirstFrame: int        
        return FindState() + int(direction) * frameCount[int(animationState)]  

    def FindState(): int
        var i:int = 0
        for n in range(0, int(animationState))
            i += frameCount |> length * frameCount[n]

        return i

    def GetLastFrame: int
        return GetFirstFrame() + frameCount[int(animationState)]

    def Animate (directionVector: float2)
        frameTime += get_delta_time()

        if directionVector.y   < 0f
            direction = Direction UP
        elif directionVector.y > 0f
            direction = Direction DOWN
        elif directionVector.x != 0f
            direction = Direction SIDE

        if frameTime >= 1f/fps[int(animationState)]
            currentFrame++
            frameTime = 0f
            if currentFrame >= frameCount[int(animationState)]
                currentFrame = 0    

        