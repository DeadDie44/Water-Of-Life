require daslib/media

require gameObject
require animator
require objectFactory
require util
require mapHelper
require collisionManager

class Enemy: GameObject
    area       : float3
    areaSize   : float = 45f
    destination: float2
    waitFor    : float = 10f
    timer      : float

    def Enemy (desc: ObjectDescriptor; position: float2; i: int)
        GameObject`GameObject(self, desc, position, i)

    def override init (desc: ObjectDescriptor; position: float2)
        GameObject`init(self, desc, position)
        SetRoamArea(float3(pos.x, pos.y, areaSize))
        destination = pos
    
    def override UpdateObject(): void
        GameObject`UpdateObject(self)
    
        if pos == destination
            destination = NewDestination()
        else
            if abs(pos.x - destination.x) < 1f && abs(pos.y - destination.y) < 1f
                pos.x = destination.x
                pos.y = destination.y
            else
                Move(-(pos - destination) / Distance(pos, destination))

    def SetRoamArea(a: float3)
        area = a

    def NewDestination : float2
        var minX, maxX, minY, maxY: float

        minX = max(area.x - areaSize, 1f + colliderSize.x)
        minY = max(area.y - areaSize, 1f + colliderSize.x)

        maxX = min(area.x + areaSize, float(MAP_WIDTH) * TILE_SIZE - colliderSize.x)
        maxY = min(area.y + areaSize, float(MAP_HEIGHT) * TILE_SIZE - colliderSize.x)

        return float2(random_float(minX, maxX), random_float(minY, maxY))