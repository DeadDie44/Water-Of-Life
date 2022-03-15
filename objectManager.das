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
    CreateObject(new GameObject(objectFromDesc("torch"), float2(150, 380), objectContainer |> length))
    for i in range(1, 15)
        var x: float = 30f * float(i)
        var y: float = 30f * float(i)
        CreateObject(new Enemy(objectFromDesc("kolovershi"), float2(x, y), objectContainer |> length))
    for j in range(1, 15)
        var x: float = 10f * float(j)
        var y: float = 40f * float(j)
        CreateObject(new Enemy(objectFromDesc("kolovershi"), float2(x, y), objectContainer |> length))

def CreateObject(var obj: GameObject?)
    objectContainer |> push(obj)

def UpdateObjects(dt: float)
    if objectContainer |> length != 0
        for obj in objectContainer
            obj -> UpdateObject(dt)
            for target in objectContainer
                if(obj.id != target.id && (obj.movable || obj.movable))
                    CheckCollision(obj, target)
            MapBoundaryCheck (obj)

def DrawObjects
    if objectContainer |> length != 0
        for obj in objectContainer
            obj -> DrawObject()