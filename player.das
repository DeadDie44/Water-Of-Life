require daslib/media

require gameObject
require animator
require objectFactory

class Player: GameObject

    def Player (desc: ObjectDescriptor; position: float2; i: int)
        GameObject`GameObject(self, desc, position, i)

    def override init (desc: ObjectDescriptor; position: float2)
        GameObject`init(self, desc, position)
    
    def override UpdateObject(dt: float): void
        GameObject`UpdateObject(self, dt)
        var move = float2(0f,0f)

        if get_key(VK_W) || get_key(VK_UP) || get_axis(AXIS_PRIMARY_Y) < 0f
            move.y = -1f
        if get_key(VK_S) || get_key(VK_DOWN) || get_axis(AXIS_PRIMARY_Y) > 0f
            move.y = 1f
        if get_key(VK_A) || get_key(VK_LEFT) || get_axis(AXIS_PRIMARY_X) < 0f
            move.x = -1f
        if get_key(VK_D) || get_key(VK_RIGHT) || get_axis(AXIS_PRIMARY_X) > 0f
            move.x = 1f

        //move = normalize(move)

        if get_key(VK_SPACE) || get_key(VK_SPACE) || get_key(GP_A)
            print("\nPLAYER POS: {pos}")
            Attack()
        
        Move(move)
        setup_2d_camera(pos, float(get_screen_width()/270))