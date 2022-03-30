require daslib/media

require gameObject
require animator
require objectFactory
require util/util
require helpers/objectHelper
require collisionManager
require gameMap
require helpers/soundAtlas

class Enemy: GameObject
    agro       : bool
    flee        : bool
    agroRadius : float = 100f
    area       : float2
    areaSize   : float = 100f
    destination: float2
    timer      : float
    previousPos: float2

    def Enemy (desc: ObjectDescriptor; position: float2; i: int)
        GameObject`GameObject(self, desc, position, i)

    def override init (desc: ObjectDescriptor; position: float2)
        GameObject`init(self, desc, position)
        SetRoamArea(pos)
        destination = pos
        previousPos = pos
        faction = int(Faction ENEMY)
        staminaCap = 10
        stamina = staminaCap
    
    def override UpdateObject(dt: float): bool
        if GameObject`UpdateObject(self, dt)
            var move: float2 = float2(0f, 0f)
            if agro
                destination = targetPos
                if ranged
                    Attack()
                elif Distance(pos, targetPos) < colliderSize.x + attackRadius
                    Attack()
            if !movable
                return true
            if flee
                destination = float2(pos.x + (pos.x - targetPos.x), pos.y + (pos.y - targetPos.y))

            if pos == destination   
                if timer < universalCD * 2f
                    timer += get_delta_time()
                    return false
                destination = NewDestination()
                timer = 0f
            else
                if abs(pos.x - destination.x) < Speed() * dt && abs(pos.y - destination.y) < Speed() * dt
                    pos.x = destination.x
                    pos.y = destination.y
                else
                    move = (destination - pos) / Distance(destination, pos)

            if abs(pos.x - previousPos.x) < 0.1f && abs(pos.y - previousPos.y) < 0.1f
                destination = NewDestination()

            previousPos = pos
            Move(move)
        return true

    def override SpotPlayer(player: GameObject?)
        targetPos = player.pos
        var distance = Distance(pos, player.pos)
        if attackRadius > 0f   
            if ranged
                if distance < attackRange
                    if distance < colliderSize.x * 4f
                        flee = true
                    else
                        flee = false
                    agro = true
                else
                    agro = false
            else
                if distance < agroRadius + colliderSize.x
                    if !agro
                        destination = pos
                    agro = true
                elif distance > agroRadius * 2f  + colliderSize.x
                    agro = false
        else 
            if distance < agroRadius + colliderSize.x
                flee = true

    def SetRoamArea(a: float2) 
        area = a

    def override LoseHealth(dmg: int; source: string)
        GameObject`LoseHealth(self, dmg, source)
        if starts_with(objName, "Bandit")
            if !isAlive
                BOSS_DEATH_SOUND |> play_sound(0.5f)
            else
                PAIN4_SOUND |> play_sound(0.8f)
        if starts_with(objName, "Dark Totem")
            if !isAlive
                TOTEM_DEATH_SOUND |> play_sound(0.5f)
            else
                STONE_HIT_SOUND |> play_sound(0.5f)

    def NewDestination : float2  
        var minX, maxX, minY, maxY: float

        minX = max(area.x - areaSize, 1f + colliderSize.x)
        minY = max(area.y - areaSize, 1f + colliderSize.x)

        maxX = min(area.x + areaSize, float(mapWidth) * TILE_SIZE - colliderSize.x - 1f)
        maxY = min(area.y + areaSize, float(mapHeight) * TILE_SIZE - colliderSize.x - 1f)

        return float2(random_float(minX, maxX), random_float(minY, maxY))