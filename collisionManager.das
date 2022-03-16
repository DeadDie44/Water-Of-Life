require daslib/media

require math
require gameObject
require helpers/collisionHelper
require helpers/mapHelper

def MapBoundaryCheck (var obj: GameObject?)
    if obj.colliderType == COLLIDER_CIRCLE
        if obj.pos.x - obj.colliderSize.x < 0f
            obj.pos.x = obj.colliderSize.x
        if obj.pos.y - obj.colliderSize.x < 0f
            obj.pos.y = obj.colliderSize.x

        if obj.pos.x + obj.colliderSize.x > float(MAP_WIDTH) * TILE_SIZE
            obj.pos.x = float(MAP_WIDTH) * TILE_SIZE - obj.colliderSize.x
        if obj.pos.y + obj.colliderSize.x > float(MAP_HEIGHT) * TILE_SIZE
            obj.pos.y = float(MAP_HEIGHT) * TILE_SIZE - obj.colliderSize.x
    else
        if obj.pos.x - obj.colliderSize.x / 2f < 0f
            obj.pos.x = obj.colliderSize.x / 2f
        if obj.pos.y - obj.colliderSize.y / 2f < 0f
            obj.pos.y = obj.colliderSize.y / 2f

        if obj.pos.x + obj.colliderSize.x / 2f > float(MAP_WIDTH) * TILE_SIZE
            obj.pos.x = float(MAP_WIDTH) * TILE_SIZE - obj.colliderSize.x / 2f
        if obj.pos.y + obj.colliderSize.y / 2f > float(MAP_HEIGHT) * TILE_SIZE
            obj.pos.y = float(MAP_HEIGHT) * TILE_SIZE - obj.colliderSize.y / 2f

// Напоминалка: двигаться могут только круги
def CheckCollision (var obj, target: GameObject?)
    if obj.colliderType == COLLIDER_CIRCLE && target.colliderType == COLLIDER_CIRCLE
        if CircleCircle(float3(obj.pos.x ,obj.pos.y, obj.colliderSize.x), float3(target.pos.x, target.pos.y, target.colliderSize.x))
            ResolveCC(obj, target) 
    elif obj.colliderType == COLLIDER_RECTANGLE && target.colliderType == COLLIDER_RECTANGLE
        if RectRect(float4(obj.pos.x - obj.colliderSize.x / 2f, obj.pos.y - obj.colliderSize.y / 2f, obj.colliderSize.x, obj.colliderSize.y), 
        float4(target.pos.x - target.colliderSize.x / 2f, target.pos.y - target.colliderSize.y / 2f, target.colliderSize.x, target.colliderSize.y))
            ResolveRR(obj, target)
    else
        var o: float4 = float4(obj.pos.x, obj.pos.y, obj.colliderSize.x, obj.colliderSize.y)
        var t: float4 = float4(target.pos.x, target.pos.y, target.colliderSize.x, target.colliderSize.y)
        if obj.colliderType == COLLIDER_CIRCLE
            CircRect(float3(o.x, o.y, o.z), float4(t.x - t.z / 2f, t.y - t.w / 2f, t.z, t.w), obj.velocity, obj)
        else
            CircRect(float3(t.x, t.y, t.z), float4(o.x - o.z / 2f, o.y - o.w / 2f, o.z, o.w), target.velocity, target)
            
                
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

def ResolveRR(var obj, target : GameObject?)
    var contactTime : float
    var contactPoint, contactNormal: float2
    var expandTarget: float4 = float4(target.pos.x - target.colliderSize.x / 2f - obj.colliderSize.x / 2f,
                                      target.pos.y - target.colliderSize.y / 2f - obj.colliderSize.y / 2f,
                                      target.colliderSize.x + obj.colliderSize.x,
                                      target.colliderSize.y + obj.colliderSize.y)

    var rayStart: float2 = float2(obj.pos.x, obj.pos.y)
    var rayDirection: float2 = float2(obj.pos.x + obj.velocity.x * get_delta_time(), obj.pos.y + obj.velocity.y * get_delta_time())
    
    if RayRect(rayStart, rayDirection, expandTarget, contactPoint, contactNormal, contactTime)
        if contactTime <= 1f
            //print("\n rS {rayStart.x},{rayStart.y}")
            //print("\n rD {rayDirection.x},{rayDirection.y}")
            //print("\nContact normal {contactNormal.x},{contactNormal.y}")
            //print("\nContact point {contactPoint.x},{contactPoint.y}")
            var vel:float2 = float2(obj.velocity.x, obj.velocity.y)
            if vel.x == 0f && vel.y == 0f
                vel.x = target.velocity.x
                vel.y = target.velocity.y
            obj -> Move(contactNormal * float2(abs(vel.x), (abs(vel.y))) * (1f - contactTime) * 0.5f)
            //target -> Move(- contactNormal * float2(abs(vel.x), (abs(vel.y))) * (1f - contactTime))

def RayRect(p1, p2: float2; rect:float4; var contactPoint, contactNormal: float2&; var tHitNear: float&) : bool
    contactNormal = float2(0f, 0f)
    contactPoint = float2(0f, 0f)

    var inv: float2 = 1f / p2

    if p2.x == 0f || p2.y == 0f
        return false

    var tNear : float2 = (float2(rect.x, rect.y) - p1) * inv
    var tFar  : float2 = (float2(rect.x, rect.y) + float2(rect.z, rect.w) - p1) * inv

    if tNear.x > tFar.x
        swap(tNear.x, tFar.x)
    if tNear.y > tFar.y
        swap(tNear.y, tFar.y)

    if tNear.x > tFar.y || tNear.y > tFar.x
        return false

    tHitNear = max(tNear.x, tNear.y)
    var tHitFar: float = min(tFar.x, tFar.y)

    if tHitFar < 0f
        return false

    contactPoint = p1 + tHitNear * p2

    if tNear.x > tNear.y
        if inv.x < 0f
            contactNormal = float2(1f, 0f)
        else
            contactNormal = float2(-1f, 0f)
    elif tNear.x < tNear.y
        if inv.y < 0f
            contactNormal = float2(0f, 1f)
        else
            contactNormal = float2(0f, -1f)

    return true

def CircRect(c:float3; r: float4; v:float2; var obj: GameObject?): bool
    var nearestPoint: float2
    nearestPoint.x = max(r.x, min(c.x + v.x * get_delta_time(), r.x + r.z))
    nearestPoint.y = max(r.y, min(c.y + v.y * get_delta_time(), r.y + r.w))

    var rayToNearest: float2
    rayToNearest.x = nearestPoint.x - (c.x + v.x * get_delta_time())
    rayToNearest.y = nearestPoint.y - (c.y + v.y * get_delta_time())
    var overlap: float = c.z - length(rayToNearest)
    if overlap > 0f
        var vX = c.x + v.x * get_delta_time()
        var vY = c.y + v.y * get_delta_time()
        obj.pos = float2(vX,vY) - normalize(rayToNearest)  * overlap
        return true
    return false

def CircleCircle(c1: float3; c2: float3): bool
    return (DistanceSquared(float2(c1.x, c1.y), float2(c2.x, c2.y)) < (c1.z + c2.z) * (c1.z + c2.z))

def RectRect(r1: float4; r2: float4): bool
    return (r1.x < r2.x + r2.z) && (r1.x + r1.z > r2.x) && (r1.y < r2.y + r2.w) && (r1.y + r1.w > r2.y)

def Distance(p1, p2: float2): float
    return sqrt(DistanceSquared(float2(p1.x, p1.y), float2(p2.x, p2.y)))

def DistanceSquared(p1: float2; p2: float2): float
    return (p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y)