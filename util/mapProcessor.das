require daslib/media
require util

let
    colorList = [[uint[20] 0xff000000; 0xff00ff00; 0xff0000ff; 0xffff0000;
                0xff7f7f00; 0xff545454; 0xfffffe33; 0xff7f007f; 0xff007f7f;0xffffffff;
                0xff9900ff; 0xffccf867; 0xff494036; 0xff3d2c19; 0xff3f330e;0xff4c5744;
                0xff4d6e38; 0xff35601b; 0xff67dbf8; 0xffea2cba]]

    MAP_TILES_LAYOUT   = "assets/mapLayout.png"
    MAP_OBJECTS_LAYOUT = "assets/objectsLayout.png"
    MAP_ITEMS_LAYOUT   = "assets/itemsLayout.png"
    MAP_DECORATIONS_LAYOUT   = "assets/decorationsLayout.png"
var
    mapSize: int2

def GetMapSize(): int2
    return mapSize

def ReadMap(): array<int>
    print("\nTrying to read map")
    var map: array<int>
    var img: Image
    img <- create_image(MAP_TILES_LAYOUT)

    mapSize.x = img.width
    mapSize.y = img.height

    for y in range(0, img.width)
        for x in range(0, img.height)
            map |> push(GetColorIndex(img |> get_pixel(x, y)) + 8 * random_int(8))
    delete img

    return <- map

def ReadObjects(): array<objectMarker>
    print("\nTrying to read objects")
    var objectArray: array<objectMarker>

    var img: Image
    img <- create_image(MAP_OBJECTS_LAYOUT)

    for y in range(0, img.width)
        for x in range(0, img.height)
            if img |> get_pixel(x, y) == 0xff007f7f
                var myMarker: objectMarker
                myMarker.pos = float2(x * 32 + 16, y * 32 + 16)
                myMarker.nameIndex = GetColorIndex(img |> get_pixel(x, y))
                objectArray |> push(myMarker)
                break;

    for y in range(0, img.width)
        for x in range(0, img.height)
            if img |> get_pixel(x, y) != 0xff000000 && img |> get_pixel(x, y) != 0xff007f7f
                var myMarker: objectMarker
                myMarker.pos = float2(x * 32 + 16, y * 32 + 16)
                myMarker.nameIndex = GetColorIndex(img |> get_pixel(x, y))
                objectArray |> push(myMarker)
    delete img

    return <- objectArray

def ReadDecoraions(): array<objectMarker>
    print("\nTrying to read decorations")
    var objectArray: array<objectMarker>

    var img: Image
    img <- create_image(MAP_DECORATIONS_LAYOUT)

    for y in range(0, img.width)
        for x in range(0, img.height)
            if img |> get_pixel(x, y) != 0xff000000
                var myMarker: objectMarker
                myMarker.pos = float2(x * 32 + 16, y * 32 + 16)
                myMarker.nameIndex = GetColorIndex(img |> get_pixel(x, y))
                objectArray |> push(myMarker)
    delete img

    return <- objectArray

def GetColorIndex(color: uint): int
    var i: int = 0
    for c in range(0, colorList |> length)
        if colorList[c] == color
            return c
    return i

struct objectMarker
    pos: float2
    nameIndex: int