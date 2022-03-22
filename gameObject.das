require daslib/media

require helpers/collisionHelper
require animator
require objectFactory
require util/util  

let
    universalCD: float  = 0.5f

class GameObject
    private healthPoints, healthCap: int
    //***
    showCollider : bool = true //  для тестов
    //***
    isAlive      : bool
    isAttacking  : bool
    isTelegraph  : bool
    isRolling    : bool
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

    attackPos    : float2
    colliderSize : float2
    direction    : float2
    displace     : float2
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

        if colliderType == COLLIDER_CIRCLE
            colliderSize.y = colliderSize.x
        animator = new Animator(desc.frames, desc.frameCount, desc.deathAnimation, desc.fps)
        animator -> SetAnimationState(AnimState IDLE)

    def RecieveAttack(attackerId, damage: int; attackerName: string)
        if !killable || hitInvul < universalCD || isRolling
            return
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
        return 1

    def UpdateObject(dt: float): bool
        if !isAlive
            isAttacking = false
            isTelegraph = false
            if id != 0 && animator.currentFrame >= animator.deathAnimation |> length - 2
                canBeRemoved = true
            return false
        if isRolling && animator.animationState == AnimState IDLE
            print("\nRoll finished")
            isRolling = false
        elif isAttacking && animator.animationState == AnimState IDLE
            print("\nAttack finished")
            isAttacking = false
            cooldown = 0f
        elif isTelegraph && animator.animationState == AnimState ATTACK
            print("\nTelegraph finished")
            isTelegraph = false
            isAttacking = true
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
        if !isAlive || !movable || isAttacking || isTelegraph     
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
        if isRolling
            return
        if (cooldown >= universalCD)
            isTelegraph = true
            //isAttacking = true
            animator -> SetAnimationState(AnimState TELE)

    def Speed() : float
        return baseSpeed

    def DrawObject
        if !drawable
            return
        
        // Если телеграфируем то пусть трясётся спрайт
        if isTelegraph
            displace.x = random_float(0f, 0.5f)
            displace.y = random_float(0f, 0.5f)
        
        var transform: float2
        transform.x = 1f
        transform.y = 1f
        if direction.x > 0f && direction.x > direction.y
            transform.x *= -1f
        if isRolling && direction.y > 0f
            transform.y *= -1f

        draw_image_transformed(spriteSheet, displace.x + pos.x - spriteSize.x * transform.x / 2f, displace.x + pos.y - spriteSize.y * transform.y / 2f,
        getSpriteRect(animator -> FrameIndex(), spriteSheet.width / int(spriteSize.x), spriteSheet.height / int(spriteSize.y), spriteSize.x, spriteSize.y), 
        0xFFFFFFFF, float2(spriteSize.x * transform.x, spriteSize.y * transform.y), 0f, 0f, 0f)

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