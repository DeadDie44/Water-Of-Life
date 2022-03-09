require daslib/media

require collisionHelper
require animator
require objectFactory
require util

class GameObject
    private healthPoints, healthCap: int
    showCollider : bool = true

    colliderType: int
    id          : int
    colliderSize: float
    size        : float
    baseSpeed   : float
    speed       : float
    direction   : float2
    pos         : float2
    objName     : string

    spriteSheet : ImageHandle
    shadowSprite: Image

    animator    : Animator?

    def GameObject(desc: ObjectDescriptor; position: float2)
        self -> init(desc, position)

    def init(desc: ObjectDescriptor; position: float2)
        direction = float2(0, 1)
        pos       = position

        objName      = desc.objName 
        colliderSize = desc.colliderSize
        colliderType = desc.colliderType
        size         = desc.size
        baseSpeed    = desc.baseSpeed
        healthCap    = desc.health
        healthPoints = healthCap
        spriteSheet  <- create_managed_image(desc.sprite)
        shadowSprite <- create_image(desc.shadow)

        animator = new Animator(desc.frames, desc.frameCount, desc.fps)
        animator -> SetAnimationState(AnimState IDLE)
        print("\n" + objName + " created")

    def loseHealth(damage: int)
        healthPoints -= damage

    def getCurrentHealth: int
        return healthPoints

    def getHealthCap: int
        return healthCap

    def UpdateObject(dt: float): void
        return
        
    def DrawObject
        animator -> Animate(direction)
        
        draw_image(shadowSprite, pos.x - size / 2f, pos.y - size / 2f)
        if direction == float2(1f,0f)
            draw_image_transformed(spriteSheet, pos.x + size / 2f, pos.y - size / 2f,
            getSpriteRect(animator -> FrameIndex(), 8, 8, size, size), 
            0xFFFFFFFF, float2(-size, size), 0f, 0f, 0f)
        else
            draw_image_region(spriteSheet, pos.x - size / 2f, pos.y - size / 2f, 
            getSpriteRect(animator -> FrameIndex(), 8, 8, size, size))

        if showCollider
            if colliderType == COLLIDER_CIRCLE
                print("")
                fill_circle(pos.x, pos.y, colliderSize, 0x44FFFFFF)
            if colliderType == COLLIDER_RECTANGLE
                fill_rect(pos.x - colliderSize, pos.y - colliderSize, colliderSize*2f, colliderSize*2f, 0x44FFFFFF)