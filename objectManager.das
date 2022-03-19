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
    
    CreateObject(new Player(objectFromDesc("player"), float2(108, 96), objectContainer |> length))
    // TESTING
    /*
    CreateObject(new Enemy(objectFromDesc("bandit"), float2(400, 400), objectContainer |> length))
    CreateObject(new Enemy(objectFromDesc("bandit"), float2(340, 430), objectContainer |> length))
    CreateObject(new Enemy(objectFromDesc("bandit"), float2(410, 370), objectContainer |> length))
    CreateObject(new Enemy(objectFromDesc("bandit"), float2(323, 354), objectContainer |> length))
    CreateObject(new Enemy(objectFromDesc("bandit"), float2(346, 430), objectContainer |> length))
    CreateObject(new Enemy(objectFromDesc("bandit"), float2(310, 270), objectContainer |> length))
    CreateObject(new Enemy(objectFromDesc("bandit"), float2(150, 400), objectContainer |> length))
    CreateObject(new Enemy(objectFromDesc("bandit"), float2(440, 130), objectContainer |> length))
    CreateObject(new Enemy(objectFromDesc("bandit"), float2(210, 270), objectContainer |> length))

    CreateObject(new GameObject(objectFromDesc("father"), float2(80, 100), objectContainer |> length))
    for i in range(1, 10)
        CreateObject(new GameObject(objectFromDesc("barrel"), float2(i * 20, i * 35), objectContainer |> length))    
    for i in range(1, 10)
        CreateObject(new GameObject(objectFromDesc("emptyBarrel"), float2(i * 30, i * 15), objectContainer |> length))    
    CreateObject(new GameObject(objectFromDesc("crate"), float2(250, 110), objectContainer |> length))
    CreateObject(new GameObject(objectFromDesc("crate"), float2(240, 130), objectContainer |> length))
    CreateObject(new GameObject(objectFromDesc("crate"), float2(50, 250), objectContainer |> length))
    CreateObject(new GameObject(objectFromDesc("crate"), float2(150, 410), objectContainer |> length))
    CreateObject(new GameObject(objectFromDesc("crate"), float2(270, 210), objectContainer |> length))
    CreateObject(new GameObject(objectFromDesc("crate"), float2(350, 110), objectContainer |> length))
    CreateObject(new GameObject(objectFromDesc("torch"), float2(150, 380), objectContainer |> length))
    for i in range(1, 20)
        var x: float = 25f * float(i) + 12f
        var y: float = 512f
        CreateObject(new Enemy(objectFromDesc("kolovershi"), float2(x, y), objectContainer |> length))
    for i in range(1, 20)
        var x: float = 512f
        var y: float = 25f * float(i) + 12f
        CreateObject(new Enemy(objectFromDesc("kolovershi"), float2(x, y), objectContainer |> length))
    for i in range(1, 20)
        var x: float = 20f
        var y: float = 25f * float(i) + 12f
        CreateObject(new Enemy(objectFromDesc("kolovershi"), float2(x, y), objectContainer |> length))
    for i in range(1, 20)
        var x: float = 25f * float(i) + 12f
        var y: float = 20f 
        CreateObject(new Enemy(objectFromDesc("kolovershi"), float2(x, y), objectContainer |> length))
    */

def CreateObject(var obj: GameObject?)
    objectContainer |> push(obj)

def UpdateObjects(dt: float)
    if objectContainer |> length > 0
        for obj in objectContainer
            if obj != null
                obj -> UpdateObject(dt)
                if obj.isAlive
                    for target in objectContainer
                        if target != null && obj.id != target.id && target.isAlive
                            if obj.isAttacking && target.killable
                                CheckAttack(obj, target)   
                            if obj.id != target.id && (obj.movable || target.movable)
                                CheckCollision(obj, target)
                    if obj.id != GetPlayer().id
                        obj -> SpotPlayer(GetPlayer().pos, GetPlayer().colliderSize.x)
                    TileCollision (obj)
                    MapBoundaryCheck (obj)

def GetPlayer: GameObject?
    return objectContainer[0]

def RemoveObjects
    var needToDelete: bool = false
    if objectContainer |> length > 0
        for obj in objectContainer
            if obj != null
                if obj.canBeRemoved
                    unsafe
                        obj.spriteSheet |> delete_managed_image()
                        delete(obj)
                    needToDelete = true

    while (needToDelete)
        needToDelete = false
        for n in range(0, objectContainer |> length)
            if objectContainer[n] == null
                erase(objectContainer, n)
                needToDelete = true
                break

/*
def GetIndexById(i: int): int
    var index: int
    if objectContainer |> length > 0
        for n in range(0, objectContainer |> length)
            if objectContainer[n].id == i
                index = n
                break
    return index
*/

def DrawObjects
    if objectContainer |> length > 0
        for obj in objectContainer
            if obj != null
                obj -> DrawObject()