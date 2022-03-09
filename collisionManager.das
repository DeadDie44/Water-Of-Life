require math
require gameObject
require collisionHelper

def UpdateCollisions (obj: GameObject?; objectContainer: array<GameObject?>)
    for target in objectContainer
        if(obj.id != target.id)
            if(obj.colliderType == COLLIDER_CIRCLE && target.colliderType == COLLIDER_CIRCLE)
                if CircleCircle(float3(obj.pos.x ,obj.pos.y, obj.colliderSize), float3(target.pos.x, target.pos.y, target.colliderSize))
                    print("\nCOLLISION: " + string(obj.id) + " to " + string(target.id))

def CircleCircle(c1: float3; c2: float3): bool
    return (DistanceSquared(float2(c1.x, c1.y), float2(c2.x, c2.y)) < (c1.z + c2.z) * (c1.z + c2.z))

def DistanceSquared(p1: float2; p2: float2): float
    return (p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y)

def RectRect(r1: float4; r2: float4): bool
    return (r1.x < r2.x + r2.w) && (r1.x + r1.w > r2.x) && (r1.y < r2.y + r2.z) && (r1.y + r1.z > r2.y)