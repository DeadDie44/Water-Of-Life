require daslib/media

require gameObject
require player
require objectFactory
require collisionManager

var
    objectContainer: array<GameObject?>
    player: Player?

def InitObjectContainer
    clear (objectContainer)
    player = new Player(objectFromDesc("player"), float2(40, 40))
    CreateObject(new GameObject(objectFromDesc("father"), float2(100, 100)))

def CreateObject(var obj: GameObject?)
    obj.id = (objectContainer |> length) + 1
    objectContainer |> push(obj)

def UpdateObjects(dt: float)
    player -> UpdateObject(dt)
    if objectContainer |> length != 0
        UpdateCollisions (player, objectContainer)
        for obj in objectContainer
            UpdateCollisions (obj, objectContainer)
            obj -> UpdateObject(dt)

def DrawObjects
    player -> DrawObject()
    if objectContainer |> length != 0
        for obj in objectContainer
            obj -> DrawObject()