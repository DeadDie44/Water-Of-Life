require daslib/media

require gameObject
require player
require objectFactory
require collisionManager

var
    objectContainer: array<GameObject?>
    //player: Player?

def InitObjectContainer
    clear (objectContainer)
    CreateObject(new Player(objectFromDesc("player"), float2(60, 60)))
    CreateObject(new GameObject(objectFromDesc("father"), float2(100, 100)))

def CreateObject(var obj: GameObject?)
    obj.id = (objectContainer |> length)
    objectContainer |> push(obj)

def UpdateObjects(dt: float)
    if objectContainer |> length != 0
        for obj in objectContainer
            for target in objectContainer
                if(obj.id != target.id)
                    CheckCollision(obj, target)
            obj -> UpdateObject(dt)

def DrawObjects
    if objectContainer |> length != 0
        for obj in objectContainer
            obj -> DrawObject()