require math

class CollisionManager
  
    def CircleCollision(c1:float3; c2:float3): bool
        return (DistanceBetweenPointsSquared(float2(c1.x, c1.y), float2(c2.x, c2.y)) > (c1.z + c2.z) * (c1.z + c2.z))

    def DistanceBetweenPointsSquared(p1: float2; p2: float2) : float
        return (p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y)