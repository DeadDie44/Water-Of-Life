require daslib/media

require gameObject
require enemy
require player
require objectFactory
require collisionManager

var
    objectContainer: array<GameObject?>

def InitObjectContainer
    clear (objectContainer)
    CreateObject(new Player(objectFromDesc("player"), float2(40, 40), objectContainer |> length))
    CreateObject(new GameObject(objectFromDesc("father"), float2(80, 100), objectContainer |> length))
    CreateObject(new GameObject(objectFromDesc("barrel"), float2(30, 230), objectContainer |> length))    
    CreateObject(new GameObject(objectFromDesc("crate"), float2(250, 110), objectContainer |> length))
    CreateObject(new GameObject(objectFromDesc("crate"), float2(50, 250), objectContainer |> length))
    CreateObject(new GameObject(objectFromDesc("crate"), float2(150, 410), objectContainer |> length))
    CreateObject(new GameObject(objectFromDesc("crate"), float2(270, 210), objectContainer |> length))
    CreateObject(new GameObject(objectFromDesc("crate"), float2(350, 110), objectContainer |> length))
    CreateObject(new GameObject(objectFromDesc("torch"), float2(150, 380), objectContainer |> length))
    for i in range(1, 15)
        var x: float = 30f * float(i)
        var y: float = 30f * float(i)
        CreateObject(new Enemy(objectFromDesc("kolovershi"), float2(x, y), objectContainer |> length))
    for i in range(1, 25)
        var x: float = 10f * float(i)
        var y: float = 30f * float(i)
        CreateObject(new Enemy(objectFromDesc("kolovershi"), float2(x, y), objectContainer |> length))
    for i in range(1, 25)
        var x: float = 30f * float(i)
        var y: float = 10f * float(i)
        CreateObject(new Enemy(objectFromDesc("kolovershi"), float2(x, y), objectContainer |> length))


def CreateObject(var obj: GameObject?)
    objectContainer |> push(obj)

def UpdateObjects(dt: float)
    if objectContainer |> length > 0
        for obj in objectContainer
            if obj != null && obj.isAlive
                obj -> UpdateObject(dt)
                for target in objectContainer
                    if target != null && obj.id != target.id && target.isAlive
                        if obj.isAttacking
                            CheckAttack(obj, target)   
                        if obj.id != target.id && (obj.movable || target.movable)
                            CheckCollision(obj, target)
                MapBoundaryCheck (obj)

def KillObjects
    if objectContainer |> length > 0
        for obj in objectContainer
            if obj != null
                if !obj.isAlive
                    unsafe
                        obj.spriteSheet |> delete_managed_image()
                        delete(obj)
    var needToDelete: bool = true

    while (needToDelete)
        needToDelete = false
        for n in range(0, objectContainer |> length)
            if objectContainer[n] == null
                erase(objectContainer, n)
                needToDelete = true
                break

def GetIndexById(i: int): int
    var index: int
    if objectContainer |> length > 0
        for n in range(0, objectContainer |> length)
            if objectContainer[n].id == i
                index = n
                break
    return index

def DrawObjects
    if objectContainer |> length > 0
        for obj in objectContainer
            if obj != null && obj.isAlive
                obj -> DrawObject()