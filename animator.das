require daslib/media

//Состояния анимации
enum AnimState
    IDLE
    RUNNING
    ATTACK

// Куда смотрит персонаж
enum Direction
    UP
    SIDE
    DOWN

class Animator
    animationState: AnimState
    direction     : Direction

    currentFrame  : int
    frameTime     : float

    frames        : array<int>
    frameCount    : array<int>

    fps           : array<float>

    def Animator(framesArray, countArray: array<int>; fpsArray: array<float>)
        self -> init(framesArray, countArray, fpsArray)

    def init(framesArray, countArray: array<int>; fpsArray: array<float>)
        currentFrame = 0
        
        frames     := framesArray
        frameCount := countArray
        fps        := fpsArray

    def SetAnimationState(state: AnimState)
        animationState = state

    def FrameIndex: int
        return frames[GetFirstFrame() + currentFrame]

    def GetFirstFrame: int
        var currentLength:int = frameCount[int(animationState)]
        var nAnimations  :int = frameCount |> length
        var whereStateStarts: int = nAnimations * int(animationState)
        
        return whereStateStarts + int(direction) * currentLength  

    def GetLastFrame: int
        return GetFirstFrame() + frameCount[int(animationState)]

    def Animate (directionVector: float2)
        frameTime += get_delta_time()

        if frameTime >= 1f/fps[int(animationState)]
            currentFrame++
            frameTime = 0f
        if currentFrame >= frameCount[int(animationState)]
            currentFrame = 0    

        if directionVector.y   < 0f
            direction = Direction UP
        elif directionVector.y > 0f
            direction = Direction DOWN
        elif directionVector.x != 0f
            direction = Direction SIDE