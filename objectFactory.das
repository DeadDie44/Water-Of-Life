//options persistent_heap = true

require fio
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
        jsonTable := json as _object
        var i:int = 0
        for k,v in keys(jsonTable), values(jsonTable)
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
            elif k == "frameCount"
                desc.frameCount <- JsonArrayAsInt(v as _array)
            elif k == "size"
                desc.size = float(v as _number)
            elif k == "baseSpeed"
                desc.baseSpeed = float(v as _number)
            elif k == "fps"
                desc.fps <- JsonArrayAsFloat(v as _array)
            elif k == "frames"
                desc.frames <- JsonArrayAsInt(v as _array)
    return <- desc

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
    colliderType, health         : int
    baseSpeed, colliderSize, size: float
    sprite, shadow               : string

    frameCount, frames: array<int>
    fps               : array<float>