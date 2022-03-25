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
        print("\n Sup player {Distance(pos, player.pos)}")
        if Distance(pos, player.pos) < colliderSize.x
            print("\n Touch me player")
            if player -> HasItem("Old Key")
                print("\n You got the thing player")
                LoseHealth(health)
            else
                print("\n You ain't no good")
        return