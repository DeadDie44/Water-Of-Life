require daslib/media
require mapHelper
require util

class GameMap
    width       : int = 16
    height      : int = 16
    
    mapContainer: array<int>

    def GameMap()
        self -> createGameMap()
        return

    def createGameMap(): void
        var tempMap: array<int>
        for i in range(0, width * height)
            tempMap |> push(TEST_MAP_LAYOUT[i])
        mapContainer := tempMap
        tempMap |> clear
        return

    def DrawGameMap(var tiles: ImageHandle&)
        for i in range(0, mapContainer |> length)
            draw_image_region(tiles, float(i % height) * TILE_SIZE, float(i / width) * TILE_SIZE,
            getSpriteRect(mapContainer[i], TILE_SET_WIDTH, TILE_SET_HEIGHT, TILE_SIZE, TILE_SIZE))
            //getTileRect(mapContainer[i]) )
        return
