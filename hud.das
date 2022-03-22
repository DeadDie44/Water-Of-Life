require daslib/media
require helpers/spriteHelper

var
    hudSheet : ImageHandle
    healthBar, healthBarEdge, healthFill, healthHalfFill: float4
    staminaBar, staminaBarEdge, staminaFill, staminaHalfFill: float4
    equipFrame, clubIcon, maceIcon, axeIcon, swordIcon: float4

def InitHUD
    var i = 0
    hudSheet <- create_managed_image(HUD_SHEET)

    healthBarEdge = float4(0f, 0f, 6f, 12f)
    healthBar = float4(1f, 0f, 5f, 12f)
    healthFill = float4(6f, 0f, 5f, 12f)
    healthHalfFill = float4(11f, 11f, 5f, 12f)

    staminaBarEdge = float4(0f, 12f, 6f, 9f)
    staminaBar = float4(1f, 12f, 5f, 9f)
    staminaFill = float4(6f, 12f, 5f, 9f)
    staminaHalfFill = float4(11f, 12f, 5f, 9f)

    equipFrame = float4(0f, 40f, 32f, 96f)
    clubIcon = float4(16f, 0f, 24f, 40f)
    maceIcon = float4(40f, 0f, 24f, 40f)
    axeIcon = float4(64f, 0f, 24f, 40f)
    swordIcon = float4(88f, 0f, 24f, 40f)

def DrawHud(originPoint: float2&; health, healthCap, stamina, staminaCap, weapon: int)
    var barPos: float2 = float2(originPoint.x - 155f, originPoint.y - 85f)
    DrawBar(health, healthCap, barPos, healthBar, healthBarEdge, healthFill)
    DrawBar(stamina, staminaCap, float2(barPos.x, barPos.y + healthBarEdge.w + 1f), staminaBar, staminaBarEdge, staminaFill)

    var equipPos: float2 = float2(originPoint.x - 155f, originPoint.y + 31f)
    DrawElement(equipPos, equipFrame)

    var weapons = [[float4[4] clubIcon; maceIcon; axeIcon; swordIcon]]
    DrawElement(float2(equipPos.x + 4f, equipPos.y + 14f), weapons[weapon])

def DrawBar(value, valueCap: int; origin: float2; bar, barEdge, fill: float4)
    DrawElement(origin, barEdge)
    for i in range(0, valueCap)
        if i == valueCap - 1
            DrawElement(origin + float2(1f + barEdge.z + bar.z * float(i), 0f), barEdge, -1f)
        elif i < valueCap - 2
            DrawElement(origin + float2(barEdge.z + bar.z * float(i), 0f), bar)

    for i in range(0, value)
        DrawElement(origin + float2(1f + bar.z * float(i), 0f), fill, 1f)

def DrawElement(pos: float2; rect: float4)
    DrawElement(pos, rect, 1f)

def DrawElement(pos: float2; rect: float4; flip: float)
    draw_image_region(hudSheet, pos.x, pos.y, rect, 0xffffffff, float2(rect.z * flip, rect.w))