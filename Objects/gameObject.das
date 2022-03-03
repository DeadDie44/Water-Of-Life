class GameObject
    
    private posX: int = 0
    private posY: int = 0

    coliderRect: int4

    def MakeCollider(rect:int4)
        coliderRect = rect

    def SetPosition(pos:int2)
        posX = pos.x
        posY = pos.y