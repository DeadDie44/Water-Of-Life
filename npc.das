require daslib/media

require gameObject
require objectFactory
require helpers/objectHelper
require myFont

class NPC: GameObject

    def NPC (desc: ObjectDescriptor; position: float2; i: int)
        GameObject`GameObject(self, desc, position, i)

    def override init (desc: ObjectDescriptor; position: float2)
        GameObject`init(self, desc, position)

    def override InteractWith: string
        print("\n I am {objName} id {id}, i've been interacted")

        return objName

    def override DrawObject
        GameObject`DrawObject(self)
        if drawable
            if objName == "Old Lady"
                DrawText("Press 'E' to interact", pos + float2(-60f, -20f), 0)
