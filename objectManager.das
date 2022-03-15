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
    //CreateObject(new GameObject(objectFromDesc("father"), float2(100, 100)))
    //CreateObject(new GameObject(objectFromDesc("barrel"), float2(130, 130)))    
    //CreateObject(new GameObject(objectFromDesc("crate"), float2(50, 110)))
    //CreateObject(new GameObject(objectFromDesc("torch"), float2(150, 80)))
    CreateObject(new Enemy(objectFromDesc("kolovershi"), float2(20, 20), objectContainer |> length))
    CreateObject(new Enemy(objectFromDesc("kolovershi"), float2(480, 480), objectContainer |> length))
    CreateObject(new Enemy(objectFromDesc("kolovershi"), float2(480, 20), objectContainer |> length))
    CreateObject(new Enemy(objectFromDesc("kolovershi"), float2(20, 480), objectContainer |> length))

def CreateObject(var obj: GameObject?)
    unsafe
        var o: GameObject? = new GameObject()
        o = obj
        objectContainer |> push(o)
    

def UpdateObjects()
    if objectContainer |> length != 0
        for obj in objectContainer
            obj -> UpdateObject()
            for target in objectContainer
                if(obj.id != target.id && (obj.movable || obj.movable))
                    CheckCollision(obj, target)
            MapBoundaryCheck (obj)

def DrawObjects
    if objectContainer |> length != 0
        for obj in objectContainer
            obj -> DrawObject()