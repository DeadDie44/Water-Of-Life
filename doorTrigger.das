require daslib/media

require collisionManager
require gameObject
require objectFactory
require helpers/objectHelper

class DoorTrigger: GameObject

    def DoorTrigger (desc: ObjectDescriptor; position: float2; i: int)
        GameObject`GameObject(self, desc, position, i)

    def override init (desc: ObjectDescriptor; position: float2)
        GameObject`init(self, desc, position)

    def override SpotPlayer(var player: GameObject?)
        if Distance(pos, player.pos) < colliderSize.x
            LoseHealth(health)
            if player -> HasItem("Old Key")
                LoseHealth(health)
        return