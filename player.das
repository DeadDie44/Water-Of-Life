require daslib/media

require Objects/gameCharacter
require Graphics/mySpriteAtlas

class public Player: GameCharacter
    speed:float = 35f
    currentSprite:int = 0 

    def Player()
        self -> init()
        return

    def init
        print("Player is here")
        spriteSheet <- create_managed_image(PLAYER)

    def playerMove(move:float2; dt:float)
        pos += move * speed * dt

    def DrawPlayer()
        var i = 1
        draw_image_region(spriteSheet, pos.x, pos.y, getTileRect(currentSprite))
        setup_2d_camera(pos, 4.0)

    def getTileRect(spriteIndex: int): float4
        var x, y: int

        x = spriteIndex % 8
        y = spriteIndex / 8

        return float4(x * 32, y * 32, 32, 32)