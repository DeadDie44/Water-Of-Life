require daslib/media

require util/util
require util/mapProcessor
require helpers/spriteHelper

let
    TILE_SIZE      : float = 32f
    TILE_SET_WIDTH : int   = 8
    TILE_SET_HEIGHT: int   = 8
/*
0xff000000;
0xff00ff00;
0xff0000ff;
0xffff0000;
0xff7f7f00;
0xff545454;
0xfffffe33
0xff800080;
0xff008080; 
0xffffffff;
0xff9900ff; 
*/

enum Tile
    EMPTY
    GRASS
    WATER
    WOODS
    CAVE_WALL
    CAVE_FLOOR
    SAND

var
    mapWidth    : int
    mapHeight   : int
    mapContainer: array<int>
    tiles       : ImageHandle

def Walkable(index: int): bool
    if index < 0 || index >= mapContainer |> length
        return false
    if mapContainer[index] % TILE_SET_WIDTH == int(Tile GRASS) || mapContainer[index] % TILE_SET_WIDTH == int(Tile CAVE_FLOOR) || mapContainer[index] % TILE_SET_WIDTH == int(Tile SAND)
        return true
    return false

def InitMap
    mapContainer <- ReadMap()
    tiles <- create_managed_image(TILES)
    var mapSize: int2 = GetMapSize()

    mapWidth = mapSize.x
    mapHeight = mapSize.y

def DrawGameMap(drawArea: float4)
    //for i in range(0, mapContainer |> length)
    for y in range(int(drawArea.y / TILE_SIZE), int(drawArea.y / TILE_SIZE + drawArea.w / TILE_SIZE))
        for x in range(int(drawArea.x / TILE_SIZE), int(drawArea.x / TILE_SIZE + drawArea.z / TILE_SIZE))
            if x >= 0 && y >= 0
                var i = y * mapWidth + x
                if mapContainer[i] != int(Tile EMPTY)
                    //var spriteIndex = FindSpriteVariant(i)
                    draw_image_region(tiles, float(i % mapHeight) * TILE_SIZE, float(i / mapWidth) * TILE_SIZE,
                    getSpriteRect(mapContainer[i], TILE_SET_WIDTH, TILE_SET_HEIGHT, TILE_SIZE, TILE_SIZE))

def HasWalkableNeighbour(i: int): bool 
    var N, NW, W, SW, S, SE, E, NE: int

    N = i - mapWidth
    W = i - 1
    S = i + mapWidth
    E = i + 1

    NW = N - 1
    SW = S - 1
    SE = S + 1
    NE = N + 1

    return Walkable(N) || Walkable(W) || Walkable(S) || Walkable(E) || Walkable(NW) || Walkable(SW) || Walkable(SE) || Walkable(NE)

/*
def FindSpriteVariant(i: int): int 
    var index, north, west, south, east: int

    north = i - mapWidth > 0 ? i - mapWidth : 0
    west  = i - 1 > 0 ? i - 1 : 0
    south = i + mapWidth < mapHeight * mapWidth ? i + mapWidth  : 0
    east  = i + 1 < mapHeight * mapWidth ? i + 1 : 0

    if mapContainer[north] == mapContainer[i]
        index += 1

    if  mapContainer[west] == mapContainer[i]
        index += 2

    if mapContainer[south] == mapContainer[i]
        index += 4
    
    if mapContainer[east] == mapContainer[i]
        index += 8
        
    return index
*/