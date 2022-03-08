require daslib/media
require collisionManager
require collisionHelper
require animator
require objectFactory

class GameObject
    private healthPoints, healthCap: int

    showCollider: bool = true

    colliderType: int
    currentFrame: int

    colliderSize: float
    size:         float
    baseSpeed:    float
    speed:        float

    direction: float2
    pos:       float2

    spriteSheet: ImageHandle
    shadowSprite: Image

    animator: Animator?

    def GameObject(desc: ObjectDescriptor)
        self -> init(desc)

    def init(desc: ObjectDescriptor)
        colliderSize = desc.colliderSize
        colliderType = desc.colliderType
        size = desc.size
        baseSpeed = desc.baseSpeed
        healthCap = desc.health
        healthPoints = healthCap
        spriteSheet <- create_managed_image(desc.sprite)
        shadowSprite <- create_image(desc.shadow)

        animator = new Animator()

    def loseHealth(damage: int)
        healthPoints -= damage

    def getCurrentHealth: int
        return healthPoints

    def getHealthCap: int
        return healthCap

    def abstract UpdateObject(dt: float): void
        
    def DrawObject
        animator -> Animate(direction)
        if currentFrame >= animator.currentAnimation |> length
            currentFrame = 0
    
        draw_image(shadowSprite, pos.x - size / 2f, pos.y - size / 2f)
        if direction == float2(1f,0f)
            draw_image_transformed(spriteSheet, pos.x + size / 2f, pos.y - size / 2f,
            getSpriteRect(animator.currentAnimation[currentFrame]), 0xFFFFFFFF, float2(-size, size), 
            0f, 0f, 0f)
        else
            draw_image_region(spriteSheet, pos.x - size / 2f, pos.y - size / 2f, 
            getSpriteRect(animator.currentAnimation[currentFrame]))
       
        animator.frameTime += get_delta_time()

        if showCollider
            if colliderType == COLLIDER_CIRCLE
                fill_circle(pos.x, pos.y, colliderSize,0x44FFFFFF)
            if colliderType == COLLIDER_RECTANGLE
                fill_rect(pos.x - colliderSize, pos.y - colliderSize, colliderSize*2f, colliderSize*2f,0x44FFFFFF)

        if animator.frameTime >= 1f/animator.fps
            currentFrame++
            animator.frameTime = 0f
     
    def getSpriteRect(spriteIndex: int): float4
        var x, y: float

        x = float(spriteIndex % 8)
        y = float(spriteIndex / 8)

        return float4(x * size, y * size, size, size)