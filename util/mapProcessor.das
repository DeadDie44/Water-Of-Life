require daslib/media
require util

let
    colorList = [[uint[18] 0xff000000; 0xff00ff00; 0xff0000ff; 0xffff0000;
                0xff7f7f00; 0xff545454; 0xfffffe33; 0xff800080; 0xff008080;0xffffffff;
                0xff9900ff; 0xffccf867; 0xff494036; 0xff3d2c19; 0xff3f330e;0xff4c5744;
                0xff4d6e38; 0xff35601b]]

    MAP_TILES_LAYOUT   = "assets/mapLayout.png"
    MAP_OBJECTS_LAYOUT = "assets/objectsLayout.png"
    MAP_ITEMS_LAYOUT   = "assets/itemsLayout.png"
var
    mapSize: int2

def GetMapSize(): int2
    return mapSize

def ReadMap(mapFile: string): array<int>
    print("\nTrying to read map")
    var map: array<int>
    var img: Image
    img <- create_image(mapFile)

    mapSize.x = img.width
    mapSize.y = img.height

    for y in range(0, img.width)
        for x in range(0, img.height)
            map |> push(GetColorIndex(img |> get_pixel(x, y)))
    delete img

    return <- map

def GetColorIndex(color: uint): int
    var i: int = 0
    for c in range(0, colorList |> length)
        if colorList[c] == color
            return c + 8 * random_int(8)
    return i