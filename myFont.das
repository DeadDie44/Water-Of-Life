require daslib/media
require helpers/spriteHelper

let
    lowerCases = [[string[26] "a";"b";"c";"d";"e";"f";"g";"h";"i";"j";"k";"l";
                    "m";"n";"o";"p";"q";"r";"s";"t";"u";"v";"w";"x";"y";"z"]]

    upperCases = [[string[26] "A";"B";"C";"D";"E";"F";"G";"H";"I";"J";"K";"L";
                    "M";"N";"O";"P";"Q";"R";"S";"T";"U";"V";"W";"X";"Y";"Z"]]

    numbers = [[string[10] "0"; "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9"]]

    punctuationsMarks = [[string[8] "."; ","; ":"; ";"; "!"; "?"; "-"; "'"]]

    textContainer = [[string[2]"Hello world! I am a testing text, because somebody doesn't want to use standart fonts with built-in methods. And so here we have a text made with sprites. I am here for testing, for if not tested this would look really bad. In fact it's probably not looking good right this moment. But oh well, I am sure it can be fixed in a week... while trying to finish core mechanics during the very same week and putting everythin in place and stuff... Fun! And since we at it I might as well jsut kepp going, after all it is important to have proper test cases. I mean if it managed to slice text properly in two parts, that doesn't mean it can keep going indefinitely. I mean mistake in algorithm and callculations might not show up on low number of passes, but what if it's just a concidentaly satisfy those conditions. So yeah let's hope I won't need to write longer texts for this demo, because I just couldn't be bothered.";
    "The quick brown fox jumps over the lazy dog. THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG. For a reason I want to see all letters to make sure the shapes are alright."]]

    symbolSize: float2 = float2(5, 10)
    symbolLimit: int2 = int2(50, 5)

var
    fontImage: ImageHandle
    textBox: Image
    textSegments: array<string>
    currentSegment: int
    testTimer: float = 0f

def InitFont()
    fontImage <- create_managed_image(FONT)
    textBox <- create_image(TEXT_BOX)

def InitText(id: int)
    textSegments <- ProcessText(textContainer[id])

def DrawText(center: float2)
    var boxPos: float2 = float2(center.x - 156f, center.y + 20f )
    var fontPos: float2 = float2(boxPos.x + 5f, boxPos.y + 5f)
    draw_image(textBox, boxPos.x, boxPos.y)

    DisplayText(textSegments[currentSegment], fontPos)
    testTimer += get_delta_time()
    if testTimer > 2f
        testTimer = 0f
        currentSegment++
        if currentSegment > textSegments |> length - 1
            currentSegment = 0

def ProcessText(text: string): array<string>
    var textArray: array<string>
    if text |> length > symbolLimit.x * symbolLimit.y
        var remnant: int = text |> length
        var tick: int
        while(remnant >= 0)
            var sliceDelta: int
            if remnant < symbolLimit.x * symbolLimit.y
                sliceDelta = remnant
            else
                sliceDelta = symbolLimit.x * symbolLimit.y
            textArray |> push(slice(text, tick * (symbolLimit.x * symbolLimit.y), tick * (symbolLimit.x * symbolLimit.y) + sliceDelta))
            remnant -= symbolLimit.x * symbolLimit.y

            tick++
    else
        textArray |> push(text)
    return <- textArray
            
def DisplayText(text: string; pos: float2)
    if text |> length > 0
        var x: int = 0
        var y: int = 0
        for char in text
            for i in range(0, lowerCases |> length)
                if lowerCases[i] == to_char(char)
                    draw_image_region(fontImage, GetPos(pos, x, y).x, GetPos(pos, x, y).y, GetLowerCase(i))
            for i in range(0, upperCases |> length)
                if upperCases[i] == to_char(char)
                    draw_image_region(fontImage, GetPos(pos, x, y).x, GetPos(pos, x, y).y, GetUpperCase(i))
            for i in range(0, numbers |> length)
                if numbers[i] == to_char(char)
                    draw_image_region(fontImage, GetPos(pos, x, y).x, GetPos(pos, x, y).y, GetNumber(i))
            for i in range(0, punctuationsMarks |> length)
                if punctuationsMarks[i] == to_char(char)
                    draw_image_region(fontImage, GetPos(pos, x, y).x, GetPos(pos, x, y).y, GetPunctuation(i))
            x++
            if x == symbolLimit.x
                x = 0
                y++

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