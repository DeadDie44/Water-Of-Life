require daslib/media
require strings

require helpers/spriteHelper

let
    lowerCases = [[string[26] "a";"b";"c";"d";"e";"f";"g";"h";"i";"j";"k";"l";
                    "m";"n";"o";"p";"q";"r";"s";"t";"u";"v";"w";"x";"y";"z"]]

    upperCases = [[string[26] "A";"B";"C";"D";"E";"F";"G";"H";"I";"J";"K";"L";
                    "M";"N";"O";"P";"Q";"R";"S";"T";"U";"V";"W";"X";"Y";"Z"]]

    numbers = [[string[10] "0"; "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9"]]

    punctuationsMarks = [[string[9] "."; ","; ":"; ";"; "!"; "?"; "-"; "'"; "*"]]

    lineLimit: int = 5

    symbolSize: float2 = float2(5, 10)
    symbolLimit: int2 = int2(50, 5)

var
    fontImage: ImageHandle
    textBox: Image
    textLines: array<string>
    currentLine: int = 0
    showText: bool

def InitFont()
    fontImage <- create_managed_image(FONT)
    textBox <- create_image(TEXT_BOX)
    
def InitText(text: string)
    textLines <- ProcessText(text)
    showText = true

def DrawTextBox(center: float2)
    if !showText
        return

    var boxPos: float2 = float2(center.x - 156f, center.y + 20f )
    var fontPos: float2 = float2(boxPos.x + 5f, boxPos.y + 5f)
    draw_image(textBox, boxPos.x, boxPos.y)

    for line in range (0, lineLimit)
        if currentLine + line < textLines |> length
            DrawText(textLines[currentLine + line], fontPos, line)

def ScrollText (var DialogOn: bool&)
    if !DialogOn
        return
    currentLine = currentLine + lineLimit < textLines |> length ? currentLine + lineLimit : 0

    if currentLine == 0
        showText = false
        DialogOn = false

def ProcessText(text: string): array<string>
    var textArray: array<string>
    if text |> length - 1 > symbolLimit.x
        var remnant: int = text |> length
        var tick: int

        while(remnant >= 0)
            var sliceDelta: int = 0
            var sliceLength: int = remnant < symbolLimit.x ? remnant : symbolLimit.x
            var sliceStart = text |> length - remnant
            var sliceEnd = sliceStart + sliceLength

            if remnant >= symbolLimit.x && !is_white_space(character_at(text, sliceEnd)) && !is_white_space(character_at(text, sliceEnd - 1))
                sliceDelta += FindWordStart(text, sliceEnd)

            textArray |> push(slice(text, sliceStart, sliceEnd - sliceDelta))
            remnant -= symbolLimit.x - sliceDelta
            tick++   
    else
        textArray |> push(text)

    return <- textArray

def FindWordStart(text: string&; index: int&): int
    var firstChar: int = 0  

    while true
        if (is_white_space(character_at(text, index - firstChar - 1)))
            break
        firstChar++

    return firstChar

def DrawText(text: string; pos: float2; line: int)
    if text |> length > 0   
        var x: int = 0
        var y: int = 0
        for char in text
            for i in range(0, lowerCases |> length)
                if lowerCases[i] == to_char(char)
                    draw_image_region(fontImage, GetPos(pos, x, line).x, GetPos(pos, x, line).y, GetLowerCase(i))
            for i in range(0, upperCases |> length)
                if upperCases[i] == to_char(char)
                    draw_image_region(fontImage, GetPos(pos, x, line).x, GetPos(pos, x, line).y, GetUpperCase(i))
            for i in range(0, numbers |> length)
                if numbers[i] == to_char(char)
                    draw_image_region(fontImage, GetPos(pos, x, line).x, GetPos(pos, x, line).y, GetNumber(i))
            for i in range(0, punctuationsMarks |> length)
                if punctuationsMarks[i] == to_char(char)
                    draw_image_region(fontImage, GetPos(pos, x, line).x, GetPos(pos, x, line).y, GetPunctuation(i))
            x++

def GetPos(pos: float2; x, y: int): float2
    return float2(1f + float(x) + pos.x + symbolSize.x * float(x), 1f + float(y) + pos.y + symbolSize.y * float(y))

def GetLowerCase(index: int): float4
    return float4(symbolSize.x * float(index), 0f, symbolSize.x, symbolSize.y)

def GetUpperCase(index: int): float4
    return float4(symbolSize.x * float(index), symbolSize.y, symbolSize.x, symbolSize.y)

def GetNumber(index: int): float4
    return float4(symbolSize.x * float(index), symbolSize.y * 2f, symbolSize.x, symbolSize.y)

def GetPunctuation(index: int): float4
    return float4(symbolSize.x * 11f + symbolSize.x * float(index), symbolSize.y * 2f, symbolSize.x, symbolSize.y)