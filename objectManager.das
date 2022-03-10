require daslib/media

require gameObject
require player
require objectFactory
require collisionManager

var
    objectContainer: array<GameObject?>

def InitObjectContainer
    clear (objectContainer)
    CreateObject(new Player(objectFromDesc("player"), float2(60, 60)))
    CreateObject(new GameObject(objectFromDesc("father"), float2(100, 100)))
    CreateObject(new GameObject(objectFromDesc("barrel"), float2(120, 120)))

def CreateObject(var obj: GameObject?)
    obj.id = (objectContainer |> length)
    objectContainer |> push(obj)

def UpdateObjects(dt: float)
    if objectContainer |> length != 0
        for obj in objectContainer
            obj -> UpdateObject(dt)
            for target in objectContainer
                if(obj.id != target.id && (obj.movable || obj.movable))
                    CheckCollision(obj, target)

def DrawObjects
    if objectContainer |> length != 0
        for obj in objectContainer
            obj -> DrawObject()