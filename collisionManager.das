require daslib/media

require math
require gameObject
require collisionHelper

def CheckCollision (var obj, target: GameObject?)
    if(obj.colliderType == COLLIDER_CIRCLE && target.colliderType == COLLIDER_CIRCLE)
        if CircleCircle(float3(obj.pos.x ,obj.pos.y, obj.colliderSize.x), float3(target.pos.x, target.pos.y, target.colliderSize.x))
            ResolveCC(obj, target) 
    elif(obj.colliderType == COLLIDER_RECTANGLE && target.colliderType == COLLIDER_RECTANGLE)
        if RectRect(float4(obj.pos.x - obj.colliderSize.x / 2f, obj.pos.y - obj.colliderSize.y / 2f, obj.colliderSize.x, obj.colliderSize.y), 
        float4(target.pos.x - target.colliderSize.x / 2f, target.pos.y - target.colliderSize.y / 2f, target.colliderSize.x, target.colliderSize.y))
            ResolveRR(obj, target)
    else
        var o: float4 = float4(obj.pos.x - obj.colliderSize.x / 2f, obj.pos.y - obj.colliderSize.y / 2f, obj.colliderSize.x, obj.colliderSize.y)
        var t: float4 = float4(target.pos.x - target.colliderSize.x / 2f, target.pos.y - target.colliderSize.y / 2f, target.colliderSize.x, target.colliderSize.y)
        if (obj.colliderType == COLLIDER_CIRCLE)
            if CircRect(float3(o.x, o.y, o.z), float4(t.x, t.y, t.z, t.w), obj.velocity)
                var i = 0
        else
            if CircRect(float3(t.x, t.y, t.z), float4(o.x, o.y, o.z, o.w), target.velocity)
                var i = 0
        
                
def ResolveCC(var obj, target : GameObject?)
    var distance: float = Distance(float2(obj.pos.x, obj.pos.y), float2(target.pos.x, target.pos.y))
    var overlap : float = 0.5f * (distance - obj.colliderSize.x - target.colliderSize.x)
    var x : float = overlap * (obj.pos.x - target.pos.x) / distance
    var y : float = overlap * (obj.pos.y - target.pos.y) / distance

    if (!obj.movable || !target.movable)
        x = 2f * overlap * (obj.pos.x - target.pos.x) / distance
        y = 2f * overlap * (obj.pos.y - target.pos.y) / distance
    obj.pos += obj.movable? float2(- x, - y) : float2(0f, 0f)
    target.pos += target.movable? float2(x, y) : float2(0f, 0f)
    //obj -> Move(float2(- x, - y))
    //target -> Move(float2(x, y))

def ResolveRR(var obj, target : GameObject?)
    var contactTime : float
    var contactPoint, contactNormal: float2
    var expandTarget: float4 = float4(target.pos.x - obj.colliderSize.x / 2f,
                                      target.pos.y - obj.colliderSize.y / 2f,
                                      target.colliderSize.x + obj.colliderSize.x,
                                      target.colliderSize.y + obj.colliderSize.y)

    var rayStart: float2 = float2(obj.pos.x + obj.colliderSize.x / 2f, obj.pos.y + obj.colliderSize.y / 2f)
    var rayDirection: float2 = float2(obj.velocity.x * get_delta_time(), (obj.velocity.y * get_delta_time()))

    if RayRect(rayStart, rayDirection, float4(expandTarget.x, expandTarget.y, expandTarget.z, expandTarget.w), contactPoint, contactNormal, contactTime)
        if contactTime <= 1f
            obj.pos += float2(contactNormal.x * abs(obj.velocity.x) * (1f - contactTime), contactNormal.y * abs(obj.velocity.y) * (1f - contactTime))
            target.pos += -float2(contactNormal.x * abs(obj.velocity.x) * (1f - contactTime), contactNormal.y * abs(obj.velocity.y) * (1f - contactTime))
            //obj -> Move(float2(contactNormal.x * abs(obj.velocity.x) * (1f - contactTime), contactNormal.y * abs(obj.velocity.y) * (1f - contactTime)))
            //target -> Move(-float2(contactNormal.x * abs(obj.velocity.x) * (1f - contactTime), contactNormal.y * abs(obj.velocity.y) * (1f - contactTime)))


def CircleCircle(c1: float3; c2: float3): bool
    return (DistanceSquared(float2(c1.x, c1.y), float2(c2.x, c2.y)) < (c1.z + c2.z) * (c1.z + c2.z))

def RectRect(r1: float4; r2: float4): bool
    return (r1.x < r2.x + r2.z) && (r1.x + r1.z > r2.x) && (r1.y < r2.y + r2.w) && (r1.y + r1.w > r2.y)

def CircRect(c:float3; r: float4; v:float2): bool
    var nearestPoint: float2
    nearestPoint.x = max(r.x, min(c.x + v.x * get_delta_time(), r.x + r.z))
    nearestPoint.y = max(r.y, min(c.y + v.y * get_delta_time(), r.y + r.w))

    var rayToNearest: float2
    rayToNearest.x = nearestPoint.x - (c.x + v.x * get_delta_time())
    rayToNearest.y = nearestPoint.y - (c.y + v.y * get_delta_time())
    var overlap: float = c.z - length(rayToNearest)
    if overlap > 0f
        return true
    return false

def RayRect(p1, p2: float2; rect:float4; var contactPoint, contactNormal: float2&; var tHitNear: float&) : bool
    var nX, nY, fX, fY: float
    nX = p2.x == 0f ? 0f : (rect.x - p1.x) / p2.x
    nY = p2.y == 0f ? 0f : (rect.y - p1.y) / p2.y
    fX = p2.x == 0f ? 0f : (rect.x + rect.z - p1.x) / p2.x
    fY = p2.y == 0f ? 0f : (rect.y + rect.w - p1.y) / p2.y

    var tNear : float2 = float2(nX, nY)
    var tFar  : float2 = float2(fX, fY)

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
    return sqrt(DistanceSquared(float2(p1.x, p1.y), float2(p2.x, p2.y)))

def DistanceSquared(p1: float2; p2: float2): float
    return (p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y)