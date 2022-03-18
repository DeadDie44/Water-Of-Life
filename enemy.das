require daslib/media

require gameObject
require animator
require objectFactory
require util
require helpers/mapHelper
require collisionManager

class Enemy: GameObject
    area       : float3
    areaSize   : float = 145f
    destination: float2
    waitFor    : float = 1f
    timer      : float
    previousPos: float2

    def Enemy (desc: ObjectDescriptor; position: float2; i: int)
        GameObject`GameObject(self, desc, position, i)

    def override init (desc: ObjectDescriptor; position: float2)
        GameObject`init(self, desc, position)
        SetRoamArea(float3(pos.x, pos.y, areaSize))
        destination = pos
        previousPos = pos
    
    def override UpdateObject(dt: float): void
        GameObject`UpdateObject(self, dt)
        //if abs(pos.x - previousPos.x) < 0.01f || abs(pos.y - previousPos.y) < 0.01f
            
        if pos == destination
            if timer < waitFor
                timer += get_delta_time()
                return
            destination = NewDestination()
            timer = 0f
        else
            var move: float2 = float2(0f, 0f)
            if abs(pos.x - destination.x) < Speed() * dt && abs(pos.y - destination.y) < Speed() * dt
                pos.x = destination.x
                pos.y = destination.y
            else
                move = (destination - pos) / Distance(destination, pos) * Speed() * dt
            Move(move)
        if abs(pos.x - previousPos.x) < 0.1f && abs(pos.y - previousPos.y) < 0.1f
            destination = NewDestination()
        previousPos = pos

    def SetRoamArea(a: float3)
        area = a

    def NewDestination : float2
        var minX, maxX, minY, maxY: float

        minX = max(area.x - areaSize, 1f + colliderSize.x)
        minY = max(area.y - areaSize, 1f + colliderSize.x)

        maxX = min(area.x + areaSize, float(MAP_WIDTH) * TILE_SIZE - colliderSize.x - 1f)
        maxY = min(area.y + areaSize, float(MAP_HEIGHT) * TILE_SIZE - colliderSize.x - 1f)

        return float2(random_float(minX, maxX), random_float(minY, maxY))