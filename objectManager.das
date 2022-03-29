require daslib/media

require collisionManager
require boss
require enemy
require doorTrigger
require gameObject
require gameMap
require item
require helpers/SpriteAtlas
require player
require objectFactory
require myFont
require npc
require respawnPoint
require questManager
require util/mapProcessor
require util/util

let
    objectNames = [[string[21] "NA"; "barrel"; "crate"; "bandit"; "banditRanger";
                    "verliokaFirst"; "verliokaTrue"; "respawn"; "player";
                    "kolovershi"; "babaYaga"; "leshy"; "secretBabaYaga"; "door"; "bossGate";
                    "bossTrigger1"; "bossTrigger2"; "banditLeader"; "blockage1"; "blockage2";
                    "turret"]]
    decorationNames = [[string[20] "NA"; "izbushka"; "NA"; "NA"; "NA";
                    "NA"; "NA"; "NA"; "NA";
                    "NA"; "NA"; "NA"; "tree1"; "tree2"; "tree3";
                    "bush1"; "bush2"; "bush3"; "NA"; "NA"]]

struct Decoration
    pos   : float2
    sprite: string

struct BossTrigger
    activated: bool
    bossPos  : float2
    doorPos  : float2
    pos      : float2 
    bossName : string

struct Projectile
    toRemove: bool
    faction : int
    frame   : int
    sprite  : int
    size    : float
    pos     : float2
    velocity: float2

var
    refreshWorld       : bool
    showIntermission   : bool
    intermissionTimer  : float
    projectileTime     : float
    currentRespawn     : float2
    intermissionMessage: string 

    bossTriggers       : array<BossTrigger?>
    decorationContainer: array<Decoration?>
    itemContainer      : array<ObjectMarker>
    NPCContainer       : array<NPC?>
    projectiles        : array<Projectile>
    objectContainer    : array<GameObject?>
    respawnPoints      : array<float2>
    
def SetRespawn(index: int)
    currentRespawn = respawnPoints[index]

def RespawnHere()
    currentRespawn = GetPlayer().pos
    refreshWorld = true

def RespawnAfterFirstBoss()
    currentRespawn = respawnPoints[1]

def RemoveBaricade(i: int)
    if objectContainer |> length > 0
        for obj in objectContainer
            if obj != null && obj.id == 1024 * i
                obj -> LoseHealth(obj -> GetHealthCap(), "")

def BossKilled()
    objectContainer[GetIndexById(999)] -> LoseHealth(objectContainer[GetIndexById(999)] -> GetHealthCap(),"")

def SpawnProjectile(origin, target: float2&; faction, projectile: int)
    var p: Projectile
    p.pos = origin
    p.velocity = (target - origin) / Distance(target, origin) * 150f
    p.faction = faction
    p.size = 6f
    p.sprite = projectile
    projectiles |> push(p)
    
def InitItems
    clear(itemContainer)
    MakeItems()
    itemContainer := rawItems

def RefreshItems
    var i = 0

def InitDecorations
    clear(decorationContainer)
    var decorationArray: array<ObjectMarker> <- ReadLayout(MAP_DECORATIONS_LAYOUT)
    for deco in decorationArray
        if deco.index > 0
            if decorationNames[deco.index] != "NA"
                var dec: Decoration? = new Decoration
                dec.pos = deco.pos
                dec.sprite = decorationNames[deco.index]
                decorationContainer |> push(dec)
    print ("\n Decorations  {decorationContainer |> length}")
    clear(decorationArray)

def InitObjectContainer(gameOver: function)
    var playerExists: bool = false
    var oldPlayer: GameObject?

    if objectContainer |> length > 0
        if objectContainer[0] != null
            playerExists = true
            oldPlayer := objectContainer[0]

    clear(objectContainer)
    var objectArray: array<ObjectMarker> := rawObjects //<- ReadObjects()
    for obj in objectArray
        if obj.index > 0
            if !playerExists && (objectNames[obj.index] == "babaYaga" || objectNames[obj.index] == "leshy" || objectNames[obj.index] == "secretBabaYaga")
                NPCContainer |> push(new NPC(objectFromDesc(objectNames[obj.index]), float2(obj.pos.x, obj.pos.y), 200 + NPCContainer |> length))
            else
                if objectNames[obj.index] == "player"
                    if playerExists
                        oldPlayer -> ReplenishHealth(oldPlayer -> GetHealthCap())
                        oldPlayer.isAlive = true
                        oldPlayer.pos = currentRespawn + float2(0f, 18f)
                        CreateObject(oldPlayer)
                    else
                        currentRespawn = obj.pos
                        respawnPoints |> push(obj.pos)
                        var player: Player? = new Player(objectFromDesc(objectNames[obj.index]), float2(obj.pos.x, obj.pos.y), objectContainer |> length)
                        player.gameOver = gameOver
                        player.changeRespawn = @@ RespawnAfterFirstBoss
                        CreateObject(player)

                elif objectNames[obj.index] == "turret" || objectNames[obj.index] == "banditLeader" || objectNames[obj.index] == "bandit" || objectNames[obj.index] == "banditRanger" || objectNames[obj.index] == "verliokaFirst" || objectNames[obj.index] == "verliokaTrue" || objectNames[obj.index] == "kolovershi"
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
                elif objectNames[obj.index] == "respawn" 
                    if !playerExists
                        respawnPoints |> push(float2(obj.pos.x, obj.pos.y))
                
                    var respawn: RespawnPoint? = new RespawnPoint(objectFromDesc(objectNames[obj.index]), float2(obj.pos.x, obj.pos.y), objectContainer |> length)
                    respawn.respawnHere = @@ RespawnHere
                    CreateObject(respawn)
                else
                    if !((objectNames[obj.index] == "blockage1" && GetQuestByName("Baba Yaga").progress >= 3) || (objectNames[obj.index] == "blockage2" && GetQuestByName("Leshy").progress >= 3))
                        CreateObject(new GameObject(objectFromDesc(objectNames[obj.index]), float2(obj.pos.x, obj.pos.y), objectContainer |> length))
    
    if itemContainer |> length > 0   
        for obj in objectContainer
            for i in range(0, itemContainer |> length)
                var size: float = 16f
                if itemContainer[i].pos == obj.pos
                    obj -> PickUpItem(itemContainer[i].index)
                    //erase(itemContainer, i)
                    //Надо всё таки хранить какие итемы были собраны потому-что мы каждый раз должны генерить итемы, чтобы их в карманы положить мобам

    clear(objectArray)
    refreshWorld = false

def CreateObject(var obj: GameObject?)
    objectContainer |> push(obj)

def ForceClearObjects
    if objectContainer |> length > 0   
        for obj in objectContainer
            if obj.id != GetPlayer().id
                obj.canBeRemoved = true
        RemoveObjects()

def UpdateObjects(dt: float; var epilogue: bool&)
    if showIntermission
        intermissionTimer += get_delta_time()
        if intermissionTimer > 1.5f
            intermissionTimer = 0f
            showIntermission = false

    if PointRect(GetPlayer().pos, float4(3050f, 2350f, 240f,240f))
        epilogue = true
        return
    if refreshWorld
        ForceClearObjects()
        InitObjectContainer(@@RespawnAfterFirstBoss)
        return

    if objectContainer |> length > 0
        for obj in objectContainer
            if obj != null           
                obj -> UpdateObject(dt)
                if obj.isAlive
                    for target in objectContainer
                        if PointRect(target.pos, GetActiveArea(obj))
                            if target != null && obj.id != target.id && target.isAlive
                                if obj.isAttacking && target.killable && obj.faction != target.faction
                                    if obj.ranged && obj.readyToShoot && target.id == GetPlayer().id
                                        SpawnProjectile(obj.pos, obj.targetPos, obj.faction, obj.projectile)
                                        obj.readyToShoot = false
                                    else
                                        CheckAttack(obj, target)
                                    if !target.isAlive && target.id != GetPlayer().id
                                        var quest: Quest? = GetQuestByTrigger(target.objName)
                                        if quest != null && quest.progress < 2
                                            ProgressQuest(quest)
                                if(obj.movable || target.movable)
                                    CheckCollision(obj, target)
                    if obj.id != GetPlayer().id
                        obj -> SpotPlayer(GetPlayer())
                        if GetPlayer().isInteracting && CanInteract(GetPlayer(), obj)
                            obj -> InteractWith()
                    TileCollision(obj, GetActiveArea(obj))
                    MapBoundaryCheck(obj)
    UpdateProjectiles(dt)
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

                var twin: bool = false
                for obj in objectContainer
                    if obj.id == 999
                        obj = new GameObject(objectFromDesc("bossGate"), trigger.doorPos, 999)
                        twin = true
                if !twin
                    CreateObject(new GameObject(objectFromDesc("bossGate"), trigger.doorPos, 999))

def UpdateItems(dt: float)
    if itemContainer |> length > 0
        var toRemove: bool = false
        var index: int
        for i in range(0, itemContainer |> length)
            var itemSize: float = 16f
            if CircleCircle(itemContainer[i].pos, GetPlayer().pos, itemSize, GetPlayer().colliderSize.x)
                GetPlayer() -> PickUpItem(itemContainer[i].index)
                showIntermission = true
                intermissionMessage = "New item: {GetItemByIndex(itemContainer[i].index).itemName}"
                var quest: Quest? = GetQuestByTrigger(GetItemByIndex(itemContainer[i].index).itemName)
                if quest != null
                    ProgressQuest(quest)
                toRemove = true
                index = i
                break
        if toRemove
            erase(itemContainer, index)

def UpdateNPCs(dt: float; var interact: bool&)
    if refreshWorld
        return
    if NPCContainer |> length > 0
        for npc in NPCContainer
            if npc != null
                CheckCollision(GetPlayer(), npc)
                if GetPlayer().isInteracting && CanInteract(GetPlayer(), npc)
                    var name: string = npc -> InteractWith()

                    InitText(GetQuestByName(name).dialogText[GetQuestByName(name).progress])
                    if GetQuestByName(name).progress % 2 == 0
                        GetQuestByName(name).progress++
                        if name == "Baba Yaga" && GetQuestByName("Baba Yaga").progress == 3
                            RemoveBaricade(1)
                        if name == "Leshy" && GetQuestByName("Leshy").progress == 3
                            RemoveBaricade(2)
                    interact = true

                    return

def UpdateProjectiles(dt: float)
    if projectiles |> length > 0
        for p in projectiles
            p.pos += p.velocity * dt
            if objectContainer |> length > 0
                for obj in objectContainer
                    if  obj.killable && obj.isAlive && p.faction != obj.faction
                        if CircleCircle(p.pos, obj.pos, p.size, obj.colliderSize.x) 
                            obj -> RecieveAttack(obj.id, obj.damage, obj.objName)
                            p.toRemove = true            
            if p.pos.x < 0f || p.pos.y < 0f || p.pos.x > float(mapWidth) * TILE_SIZE || p.pos.y > float(mapHeight) * TILE_SIZE || !Walkable(int(p.pos.y / TILE_SIZE) * mapWidth + int(p.pos.x / TILE_SIZE))
                p.toRemove = true
        RemoveProjectiles()

def RemoveProjectiles
    var needToDelete: bool = true
    var i = 0
    while (needToDelete)
        needToDelete = false
        for p in range(0, projectiles |> length)
            if projectiles[p].toRemove
                delete projectiles[p]
                erase(projectiles, p)
                needToDelete = true
                break
        i++
    

def GetPlayer: GameObject?
    return objectContainer[0]

def GetActiveArea(obj: GameObject?): float4
    var area: float4
    var areaWidth: float = 360f + obj.colliderSize.x
    var areaHeight: float = 360f + obj.colliderSize.y
    area.x = obj.pos.x - areaWidth / 2f
    area.y = obj.pos.y - areaHeight / 2f
    area.z = areaWidth
    area.w = areaHeight
    return area

def GetDrawArea: float4
    if GetPlayer() == null
        return float4(1f,1f,1f,1f)
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
                        delete(obj)
                    needToDelete = true
    else
        return
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

def DrawObjects()
    if refreshWorld
        DrawText("Refeshing the world...", GetPlayer().pos - float2(50f, 0f), 0)
        return

    if objectContainer |> length > 0
        for obj in objectContainer
            if obj != null
                if PointRect(obj.pos, GetDrawArea())  
                    obj -> DrawObject()
    DrawNPCs()
    DrawItems()
    DrawProjectiles()
    DrawDecorations()
    DrawHints()
    if showIntermission
        DrawIntermission()

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
                draw_image_region(ITEMS_SPRITE, item.pos.x - 16f, item.pos.y - 16f, getSpriteRect(items[item.index].sprite, 8, 8, 32f, 32f))

def DrawDecorations
    if decorationContainer |> length > 0
        for deco in decorationContainer
            if PointRect(deco.pos, GetDrawArea())
                draw_image(DECORATION_TABLE[deco.sprite], deco.pos.x - float(DECORATION_TABLE[deco.sprite].width) / 2f, deco.pos.y - float(DECORATION_TABLE[deco.sprite].height) / 2f -  float(DECORATION_TABLE[deco.sprite].height) / 3f)

def DrawProjectiles
    if projectiles |> length > 0
        for p in projectiles
            if PointRect(p.pos, GetDrawArea())
                projectileTime += get_delta_time()
                if projectileTime > 0.08f
                    p.frame = p.frame == 3 ? 0: p.frame + 1
                    projectileTime = 0f
                draw_image_region(PROJECTILES_SPRITE, p.pos.x - 8f, p.pos.y - 8f, getSpriteRect(p.sprite * 4 + p.frame, 4, 4, 16f, 16f))

def DrawIntermission()
    var width: float = 150f
    var height: float = 20f
    fill_rect(GetPlayer().pos.x - width / 2f , GetPlayer().pos.y - 90f, width, height, 0xFF000000)
    DrawText(intermissionMessage, float2(GetPlayer().pos.x - width / 2f + 5f, GetPlayer().pos.y - 85f), 0)

def DrawHints
    DrawText("WASD or ARROW keys to move", float2(204f, 197f), 0)
    DrawText("SPACE to attack", float2(750f, 750f), 0)
    DrawText("LEFT SHIFT to roll",  float2(950f, 700f), 0)