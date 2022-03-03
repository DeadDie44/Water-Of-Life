require gameObject

class ObjectManager
    objectContainer:array<GameObject>

    def AddObject(obj: GameObject)
        print("Adding object")
        //objectContainer |> push(obj)