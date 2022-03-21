require daslib/media

require gameObject
require enemy
require player
require objectFactory
require collisionManager
require util/mapProcessor
require util/util

/*
0xff000000; 
0xff00ff00; 
0xff0000ff; 
0xffff0000;
0xff7f7f00; 
0xff545454; 
0xfffffe33;
0xff7f007f; 
0xff007f7f;
0xffffffff;
0xff9900ff; 
0xffccf867; 
0xff494036; 
0xff3d2c19; 
0xff3f330e;
0xff4c5744;           
0xff4d6e38; 
0xff35601b;
0xff67dbf8; 
0xffea2cba
*/

let
    objectNames = [[string[20] "NA"; "barrel"; "crate"; "bandit"; "banditRanger";
                    "verliokaFirst"; "verliokaTrue"; "respawn"; "player";
                    "kolovershi"; "babaYaga"; "leshyi"; "NA"; "NA"; "NA";
                    "NA"; "NA"; "NA"; "blockage1"; "blockage2"]]
    decorationNames = [[string[20] "NA"; "NA"; "NA"; "NA"; "NA";
                    "NA"; "NA"; "NA"; "NA";
                    "NA"; "NA"; "NA"; "tree1"; "tree2"; "tree3";
                    "bush1"; "bush2"; "bush3"; "NA"; "NA"]]

struct Decoration
    pos: float2
    img: Image

var
    objectContainer: array<GameObject?>
    decorationContainer: array<Decoration?>

def InitDecorations()
    clear(decorationContainer)
    var decorationArray: array<objectMarker> <- ReadDecoraions()
    for deco in decorationArray
        if deco.nameIndex > 0
            if decorationNames[deco.nameIndex] != "NA"
                var dec: Decoration? = new Decoration
                dec.pos = deco.pos
                dec.img <- create_image("assets/sprites/decorations/{decorationNames[deco.nameIndex]}.png")
                if random_float(0f,1f) > 0.5f
                    dec.img |> flip_image_x()
                decorationContainer |> push(dec)
    clear(decorationArray)

def InitObjectContainer
    clear(objectContainer)
    var objectArray: array<objectMarker> <- ReadObjects()
    for obj in objectArray
        if obj.nameIndex > 0
            if objectNames[obj.nameIndex] == "player"
                CreateObject(new Player(objectFromDesc(objectNames[obj.nameIndex]), float2(obj.pos.x, obj.pos.y), objectContainer |> length))
            elif objectNames[obj.nameIndex] == "bandit" || objectNames[obj.nameIndex] == "banditRanger" || objectNames[obj.nameIndex] == "verliokaFirst" || objectNames[obj.nameIndex] == "verliokaTrue" || objectNames[obj.nameIndex] == "kolovershi"
                CreateObject(new Enemy(objectFromDesc(objectNames[obj.nameIndex]), float2(obj.pos.x, obj.pos.y), objectContainer |> length))
            else
                CreateObject(new GameObject(objectFromDesc(objectNames[obj.nameIndex]), float2(obj.pos.x, obj.pos.y), objectContainer |> length))
    clear(objectArray)

def CreateObject(var obj: GameObject?)
    objectContainer |> push(obj)

def UpdateObjects(dt: float)
    if objectContainer |> length > 0
        for obj in objectContainer
            if obj != null
                //if PointRect(obj.pos, GetActiveArea(GetPlayer()))              
                obj -> UpdateObject(dt)
                if obj.isAlive
                    for target in objectContainer
                        if PointRect(target.pos, GetActiveArea(obj))
                            if target != null && obj.id != target.id && target.isAlive
                                if obj.isAttacking && target.killable
                                    CheckAttack(obj, target)   
                                if obj.id != target.id && (obj.movable || target.movable)
                                    CheckCollision(obj, target)
                    if obj.id != GetPlayer().id
                        obj -> SpotPlayer(GetPlayer().pos, GetPlayer().colliderSize.x)
                    TileCollision (obj, GetActiveArea(obj))
                    MapBoundaryCheck (obj)

def GetPlayer: GameObject?
    return objectContainer[0]

def GetActiveArea(obj: GameObject?): float4
    var area: float4
    var areaWidth: float = 100f + obj.colliderSize.x
    var areaHeight: float = 100f + obj.colliderSize.y
    area.x = obj.pos.x - areaWidth / 2f
    area.y = obj.pos.y - areaHeight / 2f
    area.z = areaWidth
    area.w = areaHeight
    return area

def GetDrawArea(): float4
    var area: float4
    var areaWidth: float = 640f
    var areaHeight: float = 640f
    area.x = GetPlayer().pos.x - areaWidth / 2f
    area.y = GetPlayer().pos.y - areaHeight / 2f
    area.z = areaWidth
    area.w = areaHeight
    return area

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
                //if PointRect(obj.pos, GetDrawingArea())  
                obj -> DrawObject()

def DrawDecorations
    if decorationContainer |> length > 0
        for deco in decorationContainer
            if PointRect(deco.pos, GetDrawArea())  
                draw_image(deco.img, deco.pos.x - float(deco.img.width) / 2f, deco.pos.y - float(deco.img.height) / 2f -  float(deco.img.height) / 3f)