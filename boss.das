require daslib/media

require gameObject
require animator
require objectFactory
require util/util
require helpers/objectHelper
require collisionManager
require gameMap

class Boss: GameObject
    agro       : bool
    destination: float2
    previousPos: float2
    fPointer: function
    invoked: bool = false

    def Boss (desc: ObjectDescriptor; position: float2; i: int)
        GameObject`GameObject(self, desc, position, i)

    def override init (desc: ObjectDescriptor; position: float2)
        GameObject`init(self, desc, position)
        destination = pos
        previousPos = pos
        faction = int(Faction ENEMY)
        staminaCap = 10
        stamina = staminaCap
        agro = true
    
    def override UpdateObject(dt: float): bool
        if GameObject`UpdateObject(self, dt)
            var move: float2 = float2(0f, 0f)
            if agro
                destination = targetPos
                if Distance(pos, targetPos) < colliderSize.x + attackRadius
                    Attack()

            move = (destination - pos) / Distance(destination, pos) * Speed() * dt
            Move(move)
        return true

    def override LoseHealth(dmg: int; source: string)
        GameObject`LoseHealth(self, dmg, source)
        if !isAlive && !invoked
            print("\n Are we calling it twice?")
            invoke(fPointer)
            invoked = true

    def override SpotPlayer(player: GameObject?)
        targetPos = player.pos