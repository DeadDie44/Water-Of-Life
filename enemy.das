require daslib/media

require gameObject
require animator
require objectFactory
require util/util
require helpers/objectHelper
require collisionManager
require gameMap

class Enemy: GameObject
    agro       : bool
    targetPos  : float2
    area       : float2
    areaSize   : float = 100f
    destination: float2
    standTimer : float
    stuckTimer : float
    stuckRect  : float4
    previousPos: float2

    def Enemy (desc: ObjectDescriptor; position: float2; i: int)
        GameObject`GameObject(self, desc, position, i)

    def override init (desc: ObjectDescriptor; position: float2)
        GameObject`init(self, desc, position)
        SetRoamArea(pos)
        destination = pos
        previousPos = pos
        faction = int(Faction ENEMY)
    
    def override UpdateObject(dt: float): bool
        if GameObject`UpdateObject(self, dt)
            if agro
                destination = targetPos
                if Distance(pos, targetPos) < colliderSize.x + attackRadius
                    Attack()

            if pos == destination   
                if standTimer < universalCD * 2f
                    standTimer += get_delta_time()
                    return false
                destination = NewDestination()
                standTimer = 0f

            else
                if stuckTimer == 0f
                    stuckRect = float4(pos.x, pos.y, 0f, 0f)
                stuckTimer += get_delta_time()
                var move: float2 = float2(0f, 0f)

                if abs(pos.x - destination.x) < Speed() * dt && abs(pos.y - destination.y) < Speed() * dt
                    pos.x = destination.x
                    pos.y = destination.y
                else
                    move = (destination - pos) / Distance(destination, pos) * Speed() * dt
                Move(move)

                if stuckTimer >= universalCD * 2f
                    // Мы всё ещё находимся внутри прямоугольника в котором мы топтались в течении таймера?
                    if pos.x > stuckRect.x && pos.x < stuckRect.x + stuckRect.z && pos.y > stuckRect.y && pos.y < stuckRect.y + stuckRect.w
                        destination = NewDestination()
                    stuckTimer = 0f
                    stuckRect = float4(pos.x, pos.y, 0f, 0f)

                if stuckTimer != 0f // Пока идёт таймер запоминаем прямоугольник в рамках которого мы топчемся
                    if stuckRect.x > pos.x
                        stuckRect.x = pos.x
                    if stuckRect.y > pos.y
                        stuckRect.y = pos.y
                    if stuckRect.x + stuckRect.z < pos.x
                        stuckRect.z = pos.x - stuckRect.x
                    if stuckRect.y + stuckRect.w < pos.y
                        stuckRect.w = pos.y - stuckRect.y
        return true

    def override SpotPlayer(playerPos: float2; radius: float)
        if attackRadius > 0f
            targetPos = playerPos
            if Distance(pos, playerPos) < areaSize / 2f
                if !agro
                    destination = pos
                agro = true
            elif Distance(area, playerPos) > areaSize * 1.5f
                agro = false

    def SetRoamArea(a: float2) 
        area = a

    def NewDestination : float2  
        var minX, maxX, minY, maxY: float

        minX = max(area.x - areaSize, 1f + colliderSize.x)
        minY = max(area.y - areaSize, 1f + colliderSize.x)

        maxX = min(area.x + areaSize, float(mapWidth) * TILE_SIZE - colliderSize.x - 1f)
        maxY = min(area.y + areaSize, float(mapHeight) * TILE_SIZE - colliderSize.x - 1f)

        return float2(random_float(minX, maxX), random_float(minY, maxY))