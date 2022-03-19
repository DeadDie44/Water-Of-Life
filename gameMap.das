require daslib/media

require util/util
require util/mapProcessor

let
    TILE_SIZE      : float = 32f
    TILE_SET_WIDTH : int   = 8
    TILE_SET_HEIGHT: int   = 8
/*
0xff000000; // пустота
0xff00ff00; // трава
0xff0000ff; // вода
0xffff0000; // стена леса
0xff808000; // стена пещеры
0xff800080; // 
0xff008080; 
0xff545454; // пол пещеры
0xffffffff;
0xff9900ff; 
0xfffffe33  // песок
*/


enum Tiles
    TILE_EMPTY
    TILE_GRASS
    TILE_WATER
    TILE_WOODS
    TILE_CAVE_WALL
    TILE_5
    TILE_6
    TILE_CAVE_FLOOR
    TILE_8
    TILE_9
    TILE_SAND

var
    mapWidth: int
    mapHeight: int
    mapContainer: array<int>

def Walkable(index: int): bool
    if mapContainer[index] != int(Tiles TILE_EMPTY) && mapContainer[index] != int(Tiles TILE_WATER) && mapContainer[index] != int(Tiles TILE_WOODS) && mapContainer[index] != int(Tiles TILE_CAVE_WALL)
        return true
    return false

class GameMap
    def GameMap
        self -> createGameMap()
        var mapSize: int2 = GetMapSize()
        mapWidth = mapSize.x
        mapHeight = mapSize.y

    def createGameMap
        mapContainer <- ReadMap()
        //var tempMap: array<int>
        //for i in range(0, MAP_WIDTH * MAP_HEIGHT)
        //    tempMap |> push(TEST_MAP_LAYOUT[i])
        //mapContainer := tempMap
        //tempMap |> clear

    def DrawGameMap(var tiles: ImageHandle&)
        for i in range(0, mapContainer |> length)
            draw_image_region(tiles, float(i % mapHeight) * TILE_SIZE, float(i / mapWidth) * TILE_SIZE,
            getSpriteRect(mapContainer[i], TILE_SET_WIDTH, TILE_SET_HEIGHT, TILE_SIZE, TILE_SIZE))
            //getTileRect(mapContainer[i]) )
