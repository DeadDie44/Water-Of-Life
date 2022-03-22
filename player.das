require daslib/media

require gameObject
require animator
require objectFactory
require helpers/objectHelper
require helpers/spriteHelper
require util/util  

let
    weaponsList = [[string[4] WEAPON_CLUB; WEAPON_MACE; WEAPON_AXE; WEAPON_SWORD]]

var
    weaponSheet: ImageHandle
    
class Player: GameObject
    private weaponIndex: int = 0

    def Player (desc: ObjectDescriptor; position: float2; i: int)
        GameObject`GameObject(self, desc, position, i)

    def override init (desc: ObjectDescriptor; position: float2)
        GameObject`init(self, desc, position)
        animator -> SetTeleTimer(0.15f)
        faction = int(Faction PLAYER)
        UpdateWeapon()

    def UpdateWeapon()
        print("\n length {weaponsList |> length}, weapon {weaponsList[weaponIndex]}")
        weaponSheet <- create_managed_image(weaponsList[weaponIndex])

    def override GetDamage: int
        return 1 + 1 * weaponIndex

    def override UpdateObject(dt: float): bool
        if GameObject`UpdateObject(self, dt)
            var move = float2(0f,0f)

            if get_key(VK_W) || get_key(VK_UP) || get_axis(AXIS_PRIMARY_Y) < 0f
                move.y = -1f
                //direction.y = -1f
            if get_key(VK_S) || get_key(VK_DOWN) || get_axis(AXIS_PRIMARY_Y) > 0f
                move.y = 1f
                //direction.y = 1f
            if get_key(VK_A) || get_key(VK_LEFT) || get_axis(AXIS_PRIMARY_X) < 0f
                move.x = -1f
                //direction.x = -1f
            if get_key(VK_D) || get_key(VK_RIGHT) || get_axis(AXIS_PRIMARY_X) > 0f
                move.x = 1f
                //direction.x = 1f

            if get_key(VK_1)
                SetWeapon(0)
                if weaponIndex > weaponsList |> length - 1
                    SetWeapon (0)
                UpdateWeapon()

            if get_key(VK_2)
                SetWeapon(1)
                if weaponIndex > weaponsList |> length - 1
                    SetWeapon (0)
                UpdateWeapon()

            if get_key(VK_3)
                SetWeapon(2)
                if weaponIndex > weaponsList |> length - 1
                    SetWeapon (0)
                UpdateWeapon()

            if get_key(VK_4)
                SetWeapon(3)
                if weaponIndex > weaponsList |> length - 1
                    SetWeapon (0)
                UpdateWeapon()

            if get_key(VK_SPACE) || get_key(GP_A)
                print("\n Stamina {stamina}")
                Attack()
                //print("\n Player pos {pos}")

            if get_key(VK_LSHIFT) || get_key(GP_B)
                Roll()

            Move(move)
        return true

    def Roll()
        if !isRolling && !isAttacking && !isTelegraph && stamina >= rollCost
            print("\nRoll out?")
            LoseStamina(rollCost)
            isRolling = true
            animator -> SetAnimationState(AnimState ROLLING)
            

    def override Move(move:float2)
        if !isAlive   
            return
        if isAttacking || isTelegraph
            return
        var m = normalize(move)
        if isRolling
            vel = direction * (Speed() * 2f) * get_delta_time()
        else
            if m == float2(0f, 0f)
                animator -> SetAnimationState(AnimState IDLE)
            else
                vel = m * Speed() * get_delta_time()
                animator -> SetAnimationState(AnimState RUNNING)
                direction = move
    
    def override DrawObject(): void
        GameObject`DrawObject(self)
        if !drawable
            return
        if  isAttacking || isTelegraph
            if direction.x > 0f && direction.x > direction.y
                draw_image_transformed(weaponSheet, displace.x + pos.x + spriteSize.x / 2f, displace.y + pos.y - spriteSize.y / 2f,
                getSpriteRect(animator -> FrameIndex(), weaponSheet.width / int(spriteSize.x), weaponSheet.height / int(spriteSize.y), spriteSize.x, spriteSize.y), 
                0xFFFFFFFF, float2(-spriteSize.x, spriteSize.y), 0f, 0f, 0f)
            else
                draw_image_region(weaponSheet, displace.x + pos.x - spriteSize.x / 2f, displace.y + pos.y - spriteSize.y / 2f, 
                getSpriteRect(animator -> FrameIndex(), weaponSheet.width / int(spriteSize.x), weaponSheet.height / int(spriteSize.y), spriteSize.x, spriteSize.y))

        return

    def override GetWeapon(): int
        return weaponIndex

    def SetWeapon(index:int)
        weaponIndex = index