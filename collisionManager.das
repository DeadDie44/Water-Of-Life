require daslib/media
require daslib/math

require gameObject
require helpers/collisionHelper
require gameMap
require util/util

def MapBoundaryCheck (var obj: GameObject?)
    if obj.colliderType == COLLIDER_CIRCLE
        if obj.pos.x - obj.colliderSize.x < 0f
            obj.pos.x = obj.colliderSize.x
        if obj.pos.y - obj.colliderSize.x < 0f
            obj.pos.y = obj.colliderSize.x

        if obj.pos.x + obj.colliderSize.x > float(mapWidth) * TILE_SIZE
            obj.pos.x = float(mapWidth) * TILE_SIZE - obj.colliderSize.x
        if obj.pos.y + obj.colliderSize.x > float(mapHeight) * TILE_SIZE
            obj.pos.y = float(mapHeight) * TILE_SIZE - obj.colliderSize.x
    else
        if obj.pos.x - obj.colliderSize.x / 2f < 0f
            obj.pos.x = obj.colliderSize.x / 2f
        if obj.pos.y - obj.colliderSize.y / 2f < 0f
            obj.pos.y = obj.colliderSize.y / 2f

        if obj.pos.x + obj.colliderSize.x / 2f > float(mapWidth) * TILE_SIZE
            obj.pos.x = float(mapWidth) * TILE_SIZE - obj.colliderSize.x / 2f
        if obj.pos.y + obj.colliderSize.y / 2f > float(mapHeight) * TILE_SIZE
            obj.pos.y = float(mapHeight) * TILE_SIZE - obj.colliderSize.y / 2f

def CheckAttack (var obj, target: GameObject?)
    if obj.faction == target.faction
        return

    var dirVec: float2 = float2(obj.direction.x, obj.direction.y)
    if obj.direction.y != 0f
        dirVec.x = 0f
        
    var attackPos: float2 = float2(obj.pos.x + dirVec.x * obj.attackPos.x, obj.pos.y + dirVec.y * obj.attackPos.y)
    if target.colliderType == COLLIDER_CIRCLE
        if CircleCircle(attackPos, target.pos, obj.attackRadius, target.colliderSize.x)
            target -> RecieveAttack(obj.id, obj -> GetDamage(), obj.objName)
            if (target.movable)
                target.vel = dirVec * 2f
    else
        var rayToNearest :float2 
        var overlap: float
        if CircRect(attackPos, obj.attackRadius, float4(target.pos.x - target.colliderSize.x / 2f, target.pos.y - target.colliderSize.y / 2f, target.colliderSize.x, target.colliderSize.y), obj.direction, rayToNearest, overlap)
            target -> RecieveAttack(obj.id, obj -> GetDamage(), obj.objName)

def TileCollision (var obj: GameObject?; activeArea: float4)
    if obj.colliderType != COLLIDER_CIRCLE
        return

    for y in range(int(activeArea.y) / 32, int(activeArea.y) / 32 + int(activeArea.w) / 32)
        for x in range(int(activeArea.x) / 32, int(activeArea.x) / 32 + int(activeArea.z) / 32)
            var index = y * mapWidth + x

            if x > 0 && y > 0 && x < mapWidth && y < mapHeight
                var tile: float4 = getSpriteRect(index, mapWidth, mapHeight, TILE_SIZE, TILE_SIZE)
                var tilePos: float2 = float2(tile.x, tile.y)

                if HasWalkableNeighbour(index)
                    if !Walkable(index)
                        var rayToNearest :float2 
                        var overlap: float
                        
                        if CircRect(obj.pos, obj.colliderSize.x, tile, obj.vel, rayToNearest, overlap)
                            ResolveCR(obj, rayToNearest, overlap)

// Напоминалка: будем считаться что двигаться могут только круги
def CheckCollision (var obj, target: GameObject?)
    if obj.colliderType == COLLIDER_CIRCLE && target.colliderType == COLLIDER_CIRCLE
        if CircleCircle(obj.pos, target.pos, obj.colliderSize.x, target.colliderSize.x)
            ResolveCC(obj, target)
    else
        var o: float4 = float4(obj.pos.x, obj.pos.y, obj.colliderSize.x, obj.colliderSize.y)
        var t: float4 = float4(target.pos.x, target.pos.y, target.colliderSize.x, target.colliderSize.y)
        var rayToNearest :float2 
        var overlap: float
        if obj.colliderType == COLLIDER_CIRCLE
            if CircRect(obj.pos, obj.colliderSize.x, float4(t.x - t.z / 2f, t.y - t.w / 2f, t.z, t.w), obj.vel, rayToNearest, overlap)
                ResolveCR(obj, rayToNearest, overlap)
        else
            if CircRect(target.pos, target.colliderSize.x, float4(o.x - o.z / 2f, o.y - o.w / 2f, o.z, o.w), target.vel, rayToNearest, overlap)
                ResolveCR(target, rayToNearest, overlap)
                
def ResolveCC(var obj, target : GameObject?)
    var distance: float = Distance(obj.pos, target.pos)
    if distance == 0f
        distance = 0.01f
    var overlap : float = 0.5f * (distance - obj.colliderSize.x - target.colliderSize.x)
    var x : float = overlap * (obj.pos.x - target.pos.x) / distance
    var y : float = overlap * (obj.pos.y - target.pos.y) / distance

    if (!obj.movable || !target.movable)
        x = 2f * overlap * (obj.pos.x - target.pos.x) / distance
        y = 2f * overlap * (obj.pos.y - target.pos.y) / distance
    obj.pos += obj.movable? float2(- x, - y) : float2(0f, 0f)
    target.pos += target.movable? float2(x, y) : float2(0f, 0f)

def ResolveCR(var obj: GameObject?; rayToNearest: float2&; overlap: float&)
    var vX = obj.pos.x + obj.vel.x * get_delta_time()
    var vY = obj.pos.y + obj.vel.y * get_delta_time()
    obj.pos = float2(vX,vY) - normalize(rayToNearest) * overlap

def CircRect(pos: float2&; radius: float&; rect: float4; v :float2&; var rayToNearest :float2&; var overlap: float&): bool
    var nearestPoint: float2
    
    nearestPoint.x = max(rect.x, min(pos.x + v.x * get_delta_time(), rect.x + rect.z))
    nearestPoint.y = max(rect.y, min(pos.y + v.y * get_delta_time(), rect.y + rect.w))
    
    rayToNearest.x = nearestPoint.x - (pos.x + v.x * get_delta_time())
    rayToNearest.y = nearestPoint.y - (pos.y + v.y * get_delta_time())

    overlap = radius - length(rayToNearest)
    if overlap > 0f
        return true
    return false

def CircleCircle(pos1, pos2: float2&; r1, r2: float&): bool
    return (DistanceSquared(pos1, pos2) < (r1 + r2) * (r1 + r2))

def PointRect(point: float2&; rect: float4): bool
    return (point.x > rect.x) && (point.x < rect.x + rect.z) && (point.y > rect.y) && (point.y < rect.y + rect.w)

def RectRect(r1, r2: float4): bool
    return (r1.x < r2.x + r2.z) && (r1.x + r1.z > r2.x) && (r1.y < r2.y + r2.w) && (r1.y + r1.w > r2.y)

def Distance(p1, p2: float2&): float
    return sqrt(DistanceSquared(p1, p2))    

def DistanceSquared(p1, p2: float2&): float
    return (p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y)