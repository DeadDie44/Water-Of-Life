require daslib/media

require gameObject
require player
require objectFactory

var
    //showCollider = true
    objectContainer: array<GameObject?>
    player: Player?

def InitObjectContainer
    clear (objectContainer)
    //CreateObject(new Player())
    player = new Player(objectFromDesc("player"))

def CreateObject(var obj: GameObject?)
    objectContainer |> push(new GameObject())

def UpdateObjects(dt: float)
    player -> UpdateObject(dt)
    if objectContainer |> length != 0
        for obj in objectContainer
            obj -> UpdateObject(dt)

def DrawObjects
    player -> DrawObject()
    if objectContainer |> length != 0
        for obj in objectContainer
            obj -> DrawObject()