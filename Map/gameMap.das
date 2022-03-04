require daslib/media
require mapHelper

class GameMap
    width: int = 16
    height: int = 16
    mapContainer: array<int>

    def GameMap()
        self -> createGameMap()
        return

    def public createGameMap(): void
        var tempMap: array<int>
        for i in range(0, width * height)
            tempMap |> push(TEST_MAP_LAYOUT[i])
        mapContainer := tempMap
        tempMap |> clear
        return

    def getTileRect(spriteIndex: int): float4
        var x, y: int

        x = spriteIndex % TILE_SET_HEIGHT
        y = spriteIndex / TILE_SET_WIDTH

        return float4(x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE)

    def DrawGameMap(var tiles: ImageHandle&)
        for i in range(0, mapContainer |> length)
            draw_image_region(tiles, float(i % height * TILE_SIZE), float(i / width * TILE_SIZE),
            getTileRect(mapContainer[i]))
        return
