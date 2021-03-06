require daslib/media

require animator
require gameObject
require myFont
require objectFactory
require helpers/objectHelper
require helpers/spriteAtlas
require helpers/soundAtlas
require util/util  

let
    weaponsList = [[ImageHandle[4] WEAPON_CLUB_SPRITE; WEAPON_MACE_SPRITE; WEAPON_AXE_SPRITE; WEAPON_SWORD_SPRITE]]

var
    weaponSheet: ImageHandle
    
class Player: GameObject
    private weaponIndex: int = 0
    gameOver: function
    changeRespawn: function

    def Player (desc: ObjectDescriptor; position: float2; i: int)
        GameObject`GameObject(self, desc, position, i)

    def override init (desc: ObjectDescriptor; position: float2)
        GameObject`init(self, desc, position)
        animator -> SetTeleTimer(0.12f)
        faction = int(Faction PLAYER)
        UpdateWeapon()

    def UpdateWeapon()
        weaponSheet := weaponsList[weaponIndex]

    def override LoseHealth(dmg: int; source: string)
        GameObject`LoseHealth(self, dmg, source)
        PAIN3_SOUND |> play_sound(1f)
        if source == "VerliokaFirst"
            invoke(changeRespawn)

    def override GetDamage: int
        return damage + 1 * weaponIndex

    def override UpdateObject(dt: float): bool
        if!isAlive && animator.currentFrame == animator.deathAnimation |> length - 2
            invoke(gameOver)

        if GameObject`UpdateObject(self, dt)
            isInteracting = false

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

            if get_key(VK_SPACE) || get_key(GP_A)
                Attack()

            if get_key_up(VK_E)
                isInteracting = true

            if get_key(VK_LSHIFT) || get_key(GP_B)
                Roll()

            if get_key_up(VK_I)
                print("\nInventory length {inventory |> length}")
                if inventory |> length > 0
                    for item in inventory
                        print("\nI got: {item.itemName}")
                else
                    print("\nThere is no items")

            Move(move)
        return true

    def Roll()
        if !isRolling && !isAttacking && !isTelegraph && stamina >= rollCost
            LoseStamina(rollCost)
            isRolling = true
            animator -> SetAnimationState(AnimState ROLLING)
            GRUNT2_SOUND |> play_sound(0.7f)

    def override Move(move:float2)
        if !isAlive   
            return
        if isAttacking || isTelegraph
            return
        var m = normalize(move)
        if isRolling
            vel = normalize(direction) * Speed() * 2.2f * get_delta_time()
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
        UpdateWeapon()

    def CheckForWeapon(index: int): bool
        if index >= 5 && index <= 7 && weaponIndex < index - 4
            SetWeapon(index - 4)
            return true
        return false

    def override PickUpItem(index: int)
        if CheckForWeapon(index)
            return
        elif index == 3
            healthCap += 1
            health = healthCap
        elif index == 4
            staminaCap += 1
        else
            GameObject`PickUpItem(self, index)