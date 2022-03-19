require daslib/media

let
    mapFile = "assets/mapLayout.png"
    colorList = [[uint[11] 0xff000000; 0xff00ff00; 0xff0000ff; 0xffff0000;
                0xff808000; 0xff800080; 0xff008080; 0xff545454; 0xffffffff;
                0xff9900ff; 0xfffffe33]]
var
    mapSize: int2

def GetMapSize(): int2
    return mapSize

def ReadMap: array<int>
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
            return c
    return i