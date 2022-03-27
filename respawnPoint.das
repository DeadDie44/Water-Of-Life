require daslib/media

require gameObject
require objectFactory
require helpers/objectHelper
require myFont

class RespawnPoint: GameObject
    respawnHere: function

    def RespawnPoint (desc: ObjectDescriptor; position: float2; i: int)
        GameObject`GameObject(self, desc, position, i)

    def override init (desc: ObjectDescriptor; position: float2)
        GameObject`init(self, desc, position)

    def override InteractWith: string
        print("\n I am {objName} id {id}, i've been interacted")
        invoke(respawnHere)
        return objName
