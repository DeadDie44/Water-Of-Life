require daslib/media

require gameObject
require enemy
require player
require objectFactory
require collisionManager

/*
0xff000000; 
0xff00ff00; 
0xff0000ff; 
0xffff0000;
0xff808000; 
0xff800080; 
0xff008080; 
0xff545454; 
0xffffffff;
0xFF9900ff

let
    objectNames = [[string[10] "NA"; "barrel"; "crate"; "bandit"; "bandit_ranger";
                    "verlioka_first"; "verlioka_true"; "respawn"; "player";
                    "kolovershi"; "baba_yaga"; "leshyi"; "" ]]

let
    NO_OBJECT    : string = "NA"
    BARREL       : string = "NA"
    CRATE        : string = "NA"
    ENEMY_1      : string = "NA"
    ENEMY_2      : string = "NA"
    BOSS_1       : string = "NA"
    BOSS_2       : string = "NA"
    RESPAWN_POINT: string = "NA"
    PLAYER_START : string = "NA"
    KOLOVERSHI   : string = "NA"
    
*/


var
    objectContainer: array<GameObject?>

def InitObjectContainer
    clear (objectContainer)
    CreateObject(new Player(objectFromDesc("player"), float2(108, 96), objectContainer |> length))

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