//options persistent_heap = true

require fio
require daslib/json
require daslib/json_boost

def GetJson (fileName:string): JsonValue?
    var json: JsonValue?
    var root:string = get_das_root()
    let fname = root + "/bin/projects/Water-Of-Life/assets/json/{fileName}.json"
    fopen(fname, "rb") <| $ ( f )
        fread(f) <| $ ( data )
            //print ( "\n{fname}\n" )
            //print("before read {int(heap_bytes_allocated())} {int(string_heap_bytes_allocated())}\n")
            var error = ""
            json = read_json(data, error)
            if json == null
                panic("failed to parse, {error}\n")
    return json

def objectFromDesc(objName: string): ObjectDescriptor
    var desc: ObjectDescriptor
    var json: JsonValue? = GetJson ("objectDescriptors/" + objName + "Desc")
    //print("We got json:\n" + write_json(json))

    var jsonTable: table<string; JsonValue?>

    print("\nDig in json:")
    if json is _object
        jsonTable := json as _object
        var i:int = 0
        for k,v in keys(jsonTable), values(jsonTable)
            //print("\nPair" + string(i) + ": " + "{k}:{v}")
            i++
            if k == "sprite"
                desc.sprite = "assets/sprites/" + v as _string
            elif k == "shadow"
                desc.shadow = "assets/sprites/" + v as _string
            elif k == "colliderSize"
                desc.colliderSize = float(v as _number)
            elif k == "colliderType"
                desc.colliderType = int(v as _number)
            elif k == "health"
                desc.health = int(v as _number)
            elif k == "idleFrameCount"
                desc.idleFrameCount = int(v as _number)
            elif k == "runFrameCount"
                desc.runFrameCount = int(v as _number)
            elif k == "attackFrameCount"
                desc.attackFrameCount = int(v as _number)
            elif k == "size"
                desc.size = float(v as _number)
            elif k == "baseSpeed"
                desc.baseSpeed = float(v as _number)
            elif k == "idleFPS"
                desc.idleFPS = float(v as _number)
            elif k == "runFPS"
                desc.runFPS = float(v as _number)
            elif k == "attackFPS"
                desc.attackFPS = float(v as _number)
            elif k == "idleFrames"
                desc.idleFrames <- JsonArrayAsInt(v as _array)
            elif k == "runFrames"
                desc.runFrames <- JsonArrayAsInt(v as _array)
            elif k == "attackFrames"
                desc.attackFrames <- JsonArrayAsInt(v as _array)

    print("\nSprite(string): " + desc.sprite)
    print("\nShadow(string): " + desc.shadow)
    print("\nColliderSize(float): " + string(desc.colliderSize))
    print("\nColliderType(int): " + string(desc.colliderType))
    print("\nHealth(int): " + string(desc.health))
    print("\nIdleFrameCount(int): " + string(desc.idleFrameCount))
    print("\nRunFrameCount(int): " + string(desc.runFrameCount))
    print("\nAttackFrameCount(int): " + string(desc.attackFrameCount))
    print("\nSize(float): " + string(desc.size))
    print("\nBaseSpeed(float): " + string(desc.baseSpeed))
    print("\nIdleFPS(float): " + string(desc.idleFPS))
    print("\nRunFPS(float): " + string(desc.runFPS))
    print("\nAttackFPS(float): " + string(desc.attackFPS))
    print("\nIdleFrames(array<int>): ")
    for i in desc.idleFrames
        print(string(i) + ",")
    print("\nRunFrames(array<int>): ")
    for i in desc.runFrames
        print(string(i) + ",")
    print("\nAttackFrames(array<int>): ")
    for i in desc.attackFrames
        print(string(i) + ",")
    return <- desc

def JsonArrayAsInt(arr: array<JsonValue?>): array<int>
    var myArr: array<int>
    for a in arr
        myArr |> push(int(a.value as _number))
    return <- myArr

struct ObjectDescriptor
    sprite, shadow: string

    colliderType, health: int
    idleFrameCount, runFrameCount, attackFrameCount: int
    baseSpeed, colliderSize, size, idleFPS, runFPS, attackFPS: float

    idleFrames,runFrames,attackFrames: array<int>