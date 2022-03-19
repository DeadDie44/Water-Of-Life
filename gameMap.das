require daslib/media

require util/util
require util/mapProcessor

let
//Размер тайла
    TILE_SIZE      : float = 32f
    TILE_SET_WIDTH : int   = 8
    TILE_SET_HEIGHT: int   = 8

//Индексы тайлов
    TILE_EMPTY: int = 0
//Трава
    TILE_GRASS: int = 1

var
    mapWidth: int
    mapHeight: int
    mapContainer: array<int>

def Walkable(index: int): bool
    if mapContainer[index] != TILE_EMPTY
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
