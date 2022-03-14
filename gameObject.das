require daslib/media

require collisionHelper
require animator
require objectFactory
require util

class GameObject
    private healthPoints, healthCap: int
    //***
    showCollider : bool = true // для тестов
    //***
    movable     : bool
    colliderType: int
    id          : int
    baseSpeed   : float
    colliderSize: float2
    direction   : float2
    size        : float2
    pos         : float2
    velocity    : float2
    objName     : string

    spriteSheet : ImageHandle
    shadowSprite: Image

    animator    : Animator?

    def GameObject(desc: ObjectDescriptor; position: float2)
        self -> init(desc, position)

    def init(desc: ObjectDescriptor; position: float2)
        direction = float2(0, 1)
        pos       = position

        movable      = desc.movable
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

    def UpdateObject(dt: float)
        pos += velocity
        velocity *= 0f

    def Move(move: float2)
        if !movable
            return
        velocity = move

    def Speed() : float
        return baseSpeed

    def DrawObject
        animator -> Animate(direction)
        
        draw_image(shadowSprite, pos.x - size.x / 2f, pos.y - size.y / 2f)
        if direction == float2(1f,0f)
            draw_image_transformed(spriteSheet, pos.x + size.x / 2f, pos.y - size.y / 2f,
            getSpriteRect(animator -> FrameIndex(), 8, 8, size.x, size.y), 
            0xFFFFFFFF, float2(-size.x, size.y), 0f, 0f, 0f)
        else
            draw_image_region(spriteSheet, pos.x - size.x / 2f, pos.y - size.y / 2f, 
            getSpriteRect(animator -> FrameIndex(), 8, 8, size.x, size.y))

        if showCollider
            if colliderType == COLLIDER_CIRCLE
                fill_circle(pos.x, pos.y, colliderSize.x, 0x44FFFFFF)
            if colliderType == COLLIDER_RECTANGLE
                fill_rect(pos.x - colliderSize.x / 2f, pos.y - colliderSize.y / 2f, colliderSize.x, colliderSize.y, 0x44FFFFFF)
                if objName != "Player"
                    var expand: float4 = float4(pos.x - colliderSize.x / 2f - 14f / 2f,
                                        pos.y - colliderSize.y / 2f - 22f / 2f,
                                        colliderSize.x + 14f,
                                        colliderSize.y + 22f)
                    fill_rect(expand.x, expand.y, expand.z, expand.w, 0x44FFFFFF)