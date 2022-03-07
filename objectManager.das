require daslib/media

require gameObject

var
    showCollider = true
    objectContainer: array<GameObject?>

def InitObjectContainer
    clear (objectContainer)

def CreateObject(var obj: GameObject)
    objectContainer |> push(new GameObject())

def DrawObjects()
    if objectContainer |> length != 0
        for obj in objectContainer
            DrawObject(obj)

def DrawObject(var obj: GameObject?)
    Animate(obj)
    if obj.currentFrame >= obj.currentAnimation |> length
        obj.currentFrame = 0
    
    draw_image_region(obj.spriteSheet, obj.pos.x - obj.size / 2f, obj.pos.y - obj.size / 2f, 
    getSpriteRect(obj.currentAnimation[obj.currentFrame], obj.size))
    
    obj.frameTime += get_delta_time()

    if showCollider
        if obj.colliderType == 0
            fill_circle(obj.pos.x, obj.pos.y, obj.colliderSize,0x44FFFFFF)
        if obj.colliderType == 1
            fill_circle(obj.pos.x, obj.pos.y, obj.colliderSize,0x44FFFFFF)
            fill_rect(obj.pos.x - obj.colliderSize, obj.pos.y - obj.colliderSize, obj.colliderSize*2f, obj.colliderSize*2f,0x44FFFFFF)

    if obj.frameTime >= 1f/obj.fps
        obj.currentFrame++
        obj.frameTime = 0f
        
def Animate (var obj: GameObject?)
    if obj.animationState == 0
        if obj.direction.y < 0f
            obj.currentAnimation <- obj.idleAnimationUp[0..(obj.idleAnimationUp |> length)]
        elif obj.direction.y > 0f
            obj.currentAnimation <- obj.idleAnimationDown[0..(obj.idleAnimationDown |> length)]
        elif obj.direction.x < 0f
            obj.currentAnimation <- obj.idleAnimationLeft[0..(obj.idleAnimationLeft |> length)]
        elif obj.direction.x > 0f  
            obj.currentAnimation <- obj.idleAnimationRight[0..(obj.idleAnimationRight |> length)]
    elif obj.animationState == 1
        if obj.direction.y < 0f
            obj.currentAnimation <- obj.runAnimationUp[0..(obj.runAnimationUp |> length)]
        elif obj.direction.y > 0f
            obj.currentAnimation <- obj.runAnimationDown[0..(obj.runAnimationDown |> length)]
        elif obj.direction.x < 0f
            obj.currentAnimation <- obj.runAnimationLeft[0..(obj.runAnimationLeft |> length)]
        elif obj.direction.x > 0f 
            obj.currentAnimation <- obj.runAnimationRight[0..(obj.runAnimationRight |> length)]
    elif obj.animationState == 2
        if obj.direction.y < 0f
            obj.currentAnimation <- obj.attackAnimationUp[0..(obj.attackAnimationUp |> length)]
        elif obj.direction.y > 0f
            obj.currentAnimation <- obj.attackAnimationDown[0..(obj.attackAnimationDown |> length)]
        elif obj.direction.x < 0f
            obj.currentAnimation <- obj.attackAnimationLeft[0..(obj.attackAnimationLeft |> length)]
        elif obj.direction.x > 0f  
            obj.currentAnimation <- obj.attackAnimationRight[0..(obj.attackAnimationRight |> length)]

def getSpriteRect(spriteIndex: int; size:float): float4
    var x, y: float

    x = float(spriteIndex % 8)
    y = float(spriteIndex / 8)

    return float4(x * size, y * size, size, size)