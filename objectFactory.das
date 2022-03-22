//options persistent_heap = true

require daslib/fio
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

    if json is _object
        jsonTable <- json as _object
        var i:int = 0
        for k,v in keys(jsonTable), values(jsonTable)
            i++
            if k == "sprite"
                desc.sprite = "assets/sprites/" + v as _string
            elif k == "name"
                desc.objName = v as _string
            elif k == "movable"
                desc.movable = v as _bool
            elif k == "killable"
                desc.killable = v as _bool
            elif k == "colliderSize"
                desc.colliderSize = JsonAsFloat2(v as _array)
            elif k == "attackPos"
                desc.attackPos = JsonAsFloat2(v as _array)
            elif k == "colliderType"
                desc.colliderType = int(v as _number)
            elif k == "health"
                desc.health = int(v as _number)
            elif k == "stamina"
                desc.stamina = int(v as _number)
            elif k == "frameCount"
                desc.frameCount <- JsonArrayAsInt(v as _array)
            elif k == "size"
                desc.size = JsonAsFloat2(v as _array)
            elif k == "baseSpeed"
                desc.baseSpeed = float(v as _number)
            elif k == "attackRadius"
                desc.attackRadius = float(v as _number)
            elif k == "fps"
                desc.fps <- JsonArrayAsFloat(v as _array)
            elif k == "frames"
                desc.frames <- JsonArrayAsInt(v as _array)
            elif k == "deathAnimation"
                desc.deathAnimation <- JsonArrayAsInt(v as _array)
    return <- desc

def JsonAsFloat2(arr: array<JsonValue?>): float2
    var myArr: array<float>
    for a in arr
        myArr |> push(float(a.value as _number))

    return float2(myArr[0], myArr[1])

def JsonArrayAsInt(arr: array<JsonValue?>): array<int>
    var myArr: array<int>
    for a in arr
        myArr |> push(int(a.value as _number))
    return <- myArr

def JsonArrayAsFloat(arr: array<JsonValue?>): array<float>
    var myArr: array<float>
    for a in arr
        myArr |> push(float(a.value as _number))
    return <- myArr

struct ObjectDescriptor
    movable, killable            : bool
    colliderType, health, stamina: int
    baseSpeed, attackRadius      : float
    sprite, objName              : string
    size, colliderSize,attackPos : float2
    deathAnimation               : array<int>
    frameCount, frames           : array<int>
    fps                          : array<float>