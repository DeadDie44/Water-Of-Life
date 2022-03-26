require daslib/media

require collisionManager
require boss
require enemy
require doorTrigger
require gameObject
require item
require helpers/SpriteHelper
require player
require objectFactory
require myFont
require npc
require questManager
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
                    "kolovershi"; "babaYaga"; "leshy"; "secretBabaYaga"; "door"; "bossGate";
                    "bossTrigger1"; "bossTrigger2"; "NA"; "blockage1"; "blockage2"]]
    decorationNames = [[string[20] "NA"; "NA"; "NA"; "NA"; "NA";
                    "NA"; "NA"; "NA"; "NA";
                    "NA"; "NA"; "NA"; "tree1"; "tree2"; "tree3";
                    "bush1"; "bush2"; "bush3"; "NA"; "NA"]]

struct Decoration
    pos: float2
    img: Image

struct BossTrigger
    activated: bool
    pos: float2
    bossPos: float2
    doorPos: float2
    bossName: string

var
    itemSheet: ImageHandle
    NPCContainer: array<NPC?>
    objectContainer: array<GameObject?>
    decorationContainer: array<Decoration?>
    itemContainer: array<objectMarker>
    bossTriggers: array<BossTrigger?>
    respawnPoints: array<float2>
    gameoverCallback: function

    currentRespawn: float2

def SetRespawn(index: int)
    currentRespawn = respawnPoints[index]

def RespawnAfterFirstBoss()
    currentRespawn = respawnPoints[1]

def InitItems
    clear(itemContainer)
    MakeItems()
    itemSheet <- create_managed_image(ITEMS)
    itemContainer <- ReadLayout(MAP_ITEMS_LAYOUT)

def InitDecorations
    clear(decorationContainer)
    var decorationArray: array<objectMarker> <- ReadLayout(MAP_DECORATIONS_LAYOUT)
    for deco in decorationArray
        if deco.index > 0
            if decorationNames[deco.index] != "NA"
                var dec: Decoration? = new Decoration
                dec.pos = deco.pos
                dec.img <- create_image("assets/sprites/decorations/{decorationNames[deco.index]}.png")
                if random_float(0f,1f) > 0.5f
                    dec.img |> flip_image_x()
                decorationContainer |> push(dec)
    clear(decorationArray)

def InitObjectContainer(callback: function)
    var playerExists: bool = false
    var oldPlayer: GameObject?

    if objectContainer |> length > 0
        if objectContainer[0] != null
            playerExists = true
            oldPlayer := objectContainer[0]

    clear(objectContainer)
    var objectArray: array<objectMarker> <- ReadObjects()
    for obj in objectArray
        if obj.index > 0
            if objectNames[obj.index] == "babaYaga" || objectNames[obj.index] == "leshy" || objectNames[obj.index] == "secretBabaYaga"
                NPCContainer |> push(new NPC(objectFromDesc(objectNames[obj.index]), float2(obj.pos.x, obj.pos.y), 200 + NPCContainer |> length))
            else
                if objectNames[obj.index] == "player"
                    if playerExists
                        oldPlayer -> ReplenishHealth(oldPlayer -> GetHealthCap())
                        oldPlayer.isAlive = true
                        oldPlayer.pos = currentRespawn
                        CreateObject(oldPlayer)
                    else
                        currentRespawn = obj.pos
                        respawnPoints |> push(obj.pos)
                        var player: Player? = new Player(objectFromDesc(objectNames[obj.index]), float2(obj.pos.x, obj.pos.y), objectContainer |> length)
                        player.gameOver = callback
                        player.changeRespawn = @@ RespawnAfterFirstBoss
                        CreateObject(player)

                elif objectNames[obj.index] == "bandit" || objectNames[obj.index] == "banditRanger" || objectNames[obj.index] == "verliokaFirst" || objectNames[obj.index] == "verliokaTrue" || objectNames[obj.index] == "kolovershi"
                    CreateObject(new Enemy(objectFromDesc(objectNames[obj.index]), float2(obj.pos.x, obj.pos.y), 300 + objectContainer |> length))
                elif starts_with(objectNames[obj.index], "door")
                    CreateObject(new DoorTrigger(objectFromDesc(objectNames[obj.index]), float2(obj.pos.x, obj.pos.y), 500 + objectContainer |> length))

                elif objectNames[obj.index] == "bossTrigger1"
                    var trigger: BossTrigger? = new BossTrigger
                    trigger.pos = obj.pos
                    trigger.bossPos = float2(trigger.pos.x + 96f, trigger.pos.y + 96f)
                    trigger.doorPos = float2(trigger.pos.x - 64f, trigger.pos.y)
                    trigger.bossName = "verliokaFirst"
                    bossTriggers |> push(trigger)

                elif objectNames[obj.index] == "bossTrigger2"
                    var trigger: BossTrigger? = new BossTrigger
                    trigger.pos = obj.pos
                    trigger.bossPos = float2(trigger.pos.x, trigger.pos.y - 160f)
                    trigger.doorPos = float2(trigger.pos.x, trigger.pos.y + 64f)
                    trigger.bossName = "verliokaTrue"
                    bossTriggers |> push(trigger)

                elif objectNames[obj.index] == "respawn" && !playerExists
                    respawnPoints |> push(float2(obj.pos.x, obj.pos.y + 18f))
                else
                    CreateObject(new GameObject(objectFromDesc(objectNames[obj.index]), float2(obj.pos.x, obj.pos.y), objectContainer |> length))
    clear(objectArray)

def CreateObject(var obj: GameObject?)
    objectContainer |> push(obj)

def BossKilled()
    objectContainer[GetIndexById(999)] -> LoseHealth(1,"")

def UpdateObjects(dt: float)
    if objectContainer |> length > 0
        for obj in objectContainer
            if obj != null           
                obj -> UpdateObject(dt)
                if obj.isAlive
                    for target in objectContainer
                        if PointRect(target.pos, GetActiveArea(obj))
                            if target != null && obj.id != target.id && target.isAlive
                                if obj.isAttacking && target.killable
                                    CheckAttack(obj, target)
                                if(obj.movable || target.movable)
                                    CheckCollision(obj, target)
                    if obj.id != GetPlayer().id
                        obj -> SpotPlayer(GetPlayer())
                    TileCollision(obj, GetActiveArea(obj))
                    MapBoundaryCheck(obj)
    UpdateTriggers()
    UpdateItems(dt)
    RemoveObjects()

def UpdateTriggers()
    if bossTriggers |> length > 0
        for trigger in bossTriggers            
            if !trigger.activated && PointRect(GetPlayer().pos, float4(trigger.pos.x - 16f, trigger.pos.y - 16f, 32f, 32f))
                trigger.activated = true
                var boss: Boss? = new Boss(objectFromDesc(trigger.bossName), trigger.bossPos, 666)
                var fPointer = @@ BossKilled
                boss.fPointer = fPointer
                CreateObject(boss)
                CreateObject(new GameObject(objectFromDesc("bossGate"), trigger.doorPos, 999))

def UpdateItems(dt: float)
    if itemContainer |> length > 0
        var toRemove: bool = false
        var index: int
        for i in range(0, itemContainer |> length)
            var itemSize: float = 16f
            if CircleCircle(itemContainer[i].pos, GetPlayer().pos, itemSize, GetPlayer().colliderSize.x)
                GetPlayer() -> PickUpItem(itemContainer[i].index)
                var quest: Quest? = GetQuestByTrigger(GetItemByIndex(itemContainer[i].index).itemName)
                if quest != null
                    ProgressQuest(quest)
                toRemove = true
                index = i
                break
        if toRemove
            erase(itemContainer, index)

def UpdateNPCs(dt: float; var interact: bool&)
    if NPCContainer |> length > 0
        for npc in NPCContainer
            if npc != null
                CheckCollision(GetPlayer(), npc)
                if GetPlayer().isInteracting && CanInteract(GetPlayer(), npc)
                    var name: string = npc -> InteractWith()

                    InitText(GetQuestByName(name).dialogText[GetQuestByName(name).progress])
                    if GetQuestByName(name).progress % 2 == 0
                        GetQuestByName(name).progress++
                    interact = true

                    return

def GetPlayer: GameObject?
    return objectContainer[0]

def GetActiveArea(obj: GameObject?): float4
    var area: float4
    var areaWidth: float = 130f + obj.colliderSize.x
    var areaHeight: float = 130f + obj.colliderSize.y
    area.x = obj.pos.x - areaWidth / 2f
    area.y = obj.pos.y - areaHeight / 2f
    area.z = areaWidth
    area.w = areaHeight
    return area

def GetDrawArea: float4
    var area: float4
    var areaWidth: float = 500f
    var areaHeight: float = 450f
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
            if obj != null
                if PointRect(obj.pos, GetDrawArea())  
                    obj -> DrawObject()
    DrawNPCs()
    DrawItems()
    DrawDecorations()

def DrawNPCs
    if NPCContainer |> length > 0
        for npc in NPCContainer
            if npc != null
                if PointRect(npc.pos, GetDrawArea())  
                    npc -> DrawObject()

def DrawItems
    if itemContainer |> length > 0
        for item in itemContainer
            if PointRect(item.pos, GetDrawArea())  
                draw_image_region(itemSheet, item.pos.x - 16f, item.pos.y - 16f, getSpriteRect(items[item.index - 1].sprite, 8, 8, 32f, 32f))

def DrawDecorations
    if decorationContainer |> length > 0
        for deco in decorationContainer
            if PointRect(deco.pos, GetDrawArea())  
                draw_image(deco.img, deco.pos.x - float(deco.img.width) / 2f, deco.pos.y - float(deco.img.height) / 2f -  float(deco.img.height) / 3f)