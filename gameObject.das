require daslib/media

require helpers/collisionHelper
require animator
require objectFactory
require util/util  

class GameObject
    private healthPoints, healthCap: int
    //***
    showCollider : bool = false //  для тестов
    //***
    isAlive      : bool
    isAttacking  : bool
    canBeRemoved : bool
    movable      : bool
    killable     : bool
    drawable     : bool

    colliderType : int
    id           : int
    faction      : int

    attackRadius : float
    baseSpeed    : float
    cooldown     : float
    hitInvul     : float
    universalCD  : float

    attackPos    : float2
    colliderSize : float2
    direction    : float2
    spriteSize   : float2
    pos          : float2
    vel          : float2

    objName      : string

    spriteSheet : ImageHandle

    animator    : Animator?

    def GameObject(desc: ObjectDescriptor; position: float2; i: int)
        id = i
        self -> init(desc, position)

    def init(desc: ObjectDescriptor; position: float2)
        isAlive      = true
        canBeRemoved = false
        drawable     = true

        direction    = float2(0, 1)
        pos          = position
        universalCD  = 0.5f
        cooldown     = universalCD
        hitInvul     = universalCD

        attackPos    = desc.attackPos
        attackRadius = desc.attackRadius
        movable      = desc.movable
        killable     = desc.killable
        objName      = desc.objName 
        colliderSize = desc.colliderSize
        colliderType = desc.colliderType
        spriteSize   = desc.size
        baseSpeed    = desc.baseSpeed
        healthCap    = desc.health
        healthPoints = healthCap
        spriteSheet  <- create_managed_image(desc.sprite)

        animator = new Animator(desc.frames, desc.frameCount, desc.deathAnimation, desc.fps)
        animator -> SetAnimationState(AnimState IDLE)
        print("\n{objName} id:{id} created")

    def RecieveAttack(attackerId, damage: int; attackerName: string)
        if !killable || hitInvul < universalCD
            return
        print("\nI am {objName} id {id} took a hit from {attackerName} id {attackerId}!")
        LoseHealth(damage)

    def LoseHealth(damage: int)
        healthPoints -= damage
        hitInvul = 0f
        if healthPoints <= 0
            healthPoints = 0
            isAlive = false
            animator -> SetAnimationState(AnimState DEATH)

    def GetCurrentHealth: int
        return healthPoints

    def GetHealthCap: int
        return healthCap

    def GetDamage: int
        return 10

    def UpdateObject(dt: float): bool
        if !isAlive
            isAttacking = false
            if id != 0 && animator.currentFrame >= animator.deathAnimation |> length - 2
                canBeRemoved = true
            return false
        if isAttacking && animator.animationState == AnimState IDLE
            isAttacking = false
            cooldown = 0f
        pos += vel

        vel *= 0f
        if cooldown < universalCD
            cooldown += dt
        if hitInvul < universalCD
            drawable = !drawable
            hitInvul += dt
        else
            drawable = true

        return true

    def Move(move: float2)
        if !isAlive || !movable || isAttacking   
            return
        if move == float2(0f, 0f)
            animator -> SetAnimationState(AnimState IDLE)
        else
            if move.x > 0f && abs(move.x) > abs(move.y)
                direction.x = 1f
                direction.y = 0f
            elif move.x < 0f && abs(move.x) > abs(move.y)
                direction.x = -1f
                direction.y = 0f
            if move.y > 0f && abs(move.x) < abs(move.y)
                direction.x = 0f
                direction.y = 1f
            elif move.y < 0f && abs(move.x) < abs(move.y)
                direction.x = 0f
                direction.y = -1f            
            vel = move * Speed() * get_delta_time()
            animator -> SetAnimationState(AnimState RUNNING)
            
    def SpotPlayer(pos: float2; radius: float)
        return

    def Attack()
        if (cooldown >= universalCD)
            isAttacking = true
            animator -> SetAnimationState(AnimState ATTACK)

    def Speed() : float
        return baseSpeed

    def DrawObject
        if !drawable
            return
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
                var dirVec: float2 = float2(direction.x,direction.y)
                if direction.y != 0f
                    dirVec.x = 0f
                fill_circle(pos.x + dirVec.x * attackPos.x, pos.y + dirVec.y * attackPos.y, attackRadius, 0x44FF5555)
            if colliderType == COLLIDER_RECTANGLE
                fill_rect(pos.x - colliderSize.x / 2f, pos.y - colliderSize.y / 2f, colliderSize.x, colliderSize.y, 0x44FFFFFF)

        animator -> Animate(direction)