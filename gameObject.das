require daslib/media

require helpers/collisionHelper
require animator
require objectFactory
require util

class GameObject
    private healthPoints, healthCap: int
    //***
    showCollider : bool = true // для тестов
    //***
    isAlive     : bool
    isAttacking : bool
    movable     : bool
    colliderType: int
    id          : int
    attackRadius: float
    baseSpeed   : float
    cooldown    : float
    universalCD : float
    colliderSize: float2
    direction   : float2
    spriteSize  : float2
    pos         : float2
    velocity    : float2
    objName     : string

    spriteSheet : ImageHandle

    animator    : Animator?

    def GameObject(desc: ObjectDescriptor; position: float2; i: int)
        id = i
        self -> init(desc, position)

    def init(desc: ObjectDescriptor; position: float2)
        isAlive     = true
        direction   = float2(0, 1)
        pos         = position
        universalCD = 0.5f
        cooldown    = universalCD

        attackRadius = desc.attackRadius
        movable      = desc.movable
        objName      = desc.objName 
        colliderSize = desc.colliderSize
        colliderType = desc.colliderType
        spriteSize   = desc.size
        baseSpeed    = desc.baseSpeed
        healthCap    = desc.health
        healthPoints = healthCap
        spriteSheet  <- create_managed_image(desc.sprite)

        animator = new Animator(desc.frames, desc.frameCount, desc.fps)
        animator -> SetAnimationState(AnimState IDLE)
        print("\n {objName} id:{id} created")

    def loseHealth(damage: int)
        healthPoints -= damage
        if healthPoints <= 0
            healthPoints = 0
            isAlive = false

    def getCurrentHealth: int
        return healthPoints

    def getHealthCap: int
        return healthCap

    def UpdateObject(dt: float)
        if isAttacking && animator.animationState == AnimState IDLE
            isAttacking = false
            cooldown = 0f
        pos += velocity

        velocity *= 0f
        if cooldown < universalCD
            cooldown += dt

    def Move(move: float2)
        if !movable || isAttacking   
            return
        if move == float2(0f, 0f)
            animator -> SetAnimationState(AnimState IDLE)
        else
            normalize(move)
            animator -> SetAnimationState(AnimState RUNNING)
            velocity = move * Speed() * get_delta_time()
            direction = move

    def Attack()
        if (cooldown >= universalCD)
            isAttacking = true
            animator -> SetAnimationState(AnimState ATTACK)

    def Speed() : float
        return baseSpeed

    def DrawObject
        animator -> Animate(direction)
        if direction.x > 0f && direction.x > direction.y
            draw_image_transformed(spriteSheet, pos.x + spriteSize.x / 2f, pos.y - spriteSize.y / 2f,
            getSpriteRect(animator -> FrameIndex(), spriteSheet.width / int(spriteSize.x), spriteSheet.height / int(spriteSize.y), spriteSize.x, spriteSize.y), 
            0xFFFFFFFF, float2(-spriteSize.x, spriteSize.y), 0f, 0f, 0f)
        else
            draw_image_region(spriteSheet, pos.x - spriteSize.x / 2f, pos.y - spriteSize.y / 2f, 
            getSpriteRect(animator -> FrameIndex(), spriteSheet.width / int(spriteSize.x), spriteSheet.height / int(spriteSize.y), spriteSize.x, spriteSize.y))

        if showCollider
            if colliderType == COLLIDER_CIRCLE
                fill_circle(pos.x, pos.y, colliderSize.x, 0x44FFFFFF)
            if colliderType == COLLIDER_RECTANGLE
                fill_rect(pos.x - colliderSize.x / 2f, pos.y - colliderSize.y / 2f, colliderSize.x, colliderSize.y, 0x44FFFFFF)

    
    
