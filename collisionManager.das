require daslib/media

require math
require gameObject
require collisionHelper

def CheckCollision (var obj, target: GameObject?)
    if(obj.colliderType == COLLIDER_CIRCLE && target.colliderType == COLLIDER_CIRCLE)
        if CircleCircle(float3(obj.pos.x ,obj.pos.y, obj.colliderSize.x), float3(target.pos.x, target.pos.y, target.colliderSize.x))
            ResolveCC(obj, target) 
    if(obj.colliderType == COLLIDER_RECTANGLE && target.colliderType == COLLIDER_RECTANGLE)
        if RectRect(float4(obj.pos.x - obj.colliderSize.x, obj.pos.y - obj.colliderSize.y, obj.colliderSize.x * 2f, obj.colliderSize.y * 2f), 
        float4(target.pos.x - obj.colliderSize.x, target.pos.y - obj.colliderSize.y, target.colliderSize.x * 2f, target.colliderSize.y * 2f))
            ResolveRR(obj, target)
                
def ResolveCC(var obj, target : GameObject?)
    if obj.velocity.x == 0f && obj.velocity.y == 0f
        return
    var x, y    : float
    var distance: float = Distance(float2(obj.pos.x, obj.pos.y), float2(target.pos.x, target.pos.y))
    var overlap : float = 0.5f * (distance - obj.colliderSize.x - target.colliderSize.x)
    x = overlap * (obj.pos.x - target.pos.x) / distance
    y = overlap * (obj.pos.y - target.pos.y) / distance

    if (!obj.movable || !target.movable)
        x = 2f * overlap * (obj.pos.x - target.pos.x) / distance
        y = 2f * overlap * (obj.pos.y - target.pos.y) / distance
    obj    -> Move(float2(- x, - y))
    target -> Move(float2(x, y))

def ResolveRR(var obj, target : GameObject?)
    if obj.velocity.x == 0f && obj.velocity.y == 0f
        return
    var contactTime : float
    var contactPoint, contactNormal: float2
    var expandTarget: float4 = float4(target.pos.x - obj.colliderSize.x / 2f,
                                      target.pos.y - obj.colliderSize.y / 2f,
                                      target.colliderSize.x + obj.colliderSize.x,
                                      target.colliderSize.y + obj.colliderSize.y)

    var vX : float = obj.velocity.x == 0f ? 0.01f : obj.velocity.x
    var vY : float = obj.velocity.y == 0f ? 0.01f : obj.velocity.y

    var rayStart: float2 = float2(obj.pos.x + obj.colliderSize.x / 2f, obj.pos.y + obj.colliderSize.y / 2f)
    var rayDirection: float2 = float2((obj.pos.x + obj.colliderSize.x / 2f) + vX * get_delta_time(), (obj.pos.y + obj.colliderSize.y / 2f) + vY * get_delta_time())

    if RayRect(rayStart, rayDirection, float4(expandTarget.x, expandTarget.y, expandTarget.z, expandTarget.w), contactPoint, contactNormal, contactTime)
        if contactTime <= 1f
            obj -> Move(float2(contactNormal.x * abs(vX) * (1f - contactTime), contactNormal.y * abs(vY) * (1f - contactTime)))
    
def CircleCircle(c1: float3; c2: float3): bool
    return (DistanceSquared(float2(c1.x, c1.y), float2(c2.x, c2.y)) < (c1.z + c2.z) * (c1.z + c2.z))

def RectRect(r1: float4; r2: float4): bool
    return (r1.x < r2.x + r2.z) && (r1.x + r1.z > r2.x) && (r1.y < r2.y + r2.w) && (r1.y + r1.w > r2.y)

def RayRect(p1, p2: float2; rect:float4; var contactPoint, contactNormal: float2&; var tHitNear: float&) : bool
    var tNear : float2 = float2((rect.x - p1.x) / p2.x, 
                                (rect.y - p1.y) / p2.y)
    var tFar  : float2 = float2((rect.x + rect.z - p1.x) / p2.x, 
                                (rect.y + rect.w - p1.y) / p2.y)
    if tNear.x > tFar.x
        swap(tNear.x, tFar.x)
    if tNear.y > tFar.y
        swap(tNear.y, tFar.y)

    if tNear.x > tFar.x || tNear.y > tFar.y
        return false

    var tHitFar  : float = min(tFar.x, tFar.y)

    if tHitFar < 0f
        return false

    contactPoint.x = p1.x + tHitNear * p2.x
    contactPoint.y = p1.y + tHitNear * p2.y

    if tNear.x > tNear.y
        if p2.x < 0f
            contactNormal = float2(1f, 0f)
        else
            contactNormal = float2(-1f, 0f)
    elif tNear.x < tNear.y
        if p2.y < 0f
            contactNormal = float2(0f, 1f)
        else
            contactNormal = float2(0f, -1f)

    return true

def Distance(p1, p2: float2): float
    return sqrt(DistanceSquared(p1, p2))

def DistanceSquared(p1: float2; p2: float2): float
    return (p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y)