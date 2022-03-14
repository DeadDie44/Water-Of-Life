require daslib/media
require mapHelper
require util

class GameMap
    mapContainer: array<int>

    def GameMap()
        self -> createGameMap()
        return

    def createGameMap(): void
        var tempMap: array<int>
        for i in range(0, MAP_WIDTH * MAP_HEIGHT)
            tempMap |> push(TEST_MAP_LAYOUT[i])
        mapContainer := tempMap
        tempMap |> clear
        return

    def DrawGameMap(var tiles: ImageHandle&)
        for i in range(0, mapContainer |> length)
            draw_image_region(tiles, float(i % MAP_HEIGHT) * TILE_SIZE, float(i / MAP_WIDTH) * TILE_SIZE,
            getSpriteRect(mapContainer[i], TILE_SET_WIDTH, TILE_SET_HEIGHT, TILE_SIZE, TILE_SIZE))
            //getTileRect(mapContainer[i]) )
        return
