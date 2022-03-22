require daslib/media
require helpers/spriteHelper

let
    lowerCases = [[string[26] "a";"b";"c";"d";"e";"f";"g";"h";"i";"j";"k";"l";
                    "m";"n";"o";"p";"q";"r";"s";"t";"u";"v";"w";"x";"y";"z"]]

    upperCases = [[string[26] "A";"B";"C";"D";"E";"F";"G";"H";"I";"J";"K";"L";
                    "M";"N";"O";"P";"Q";"R";"S";"T";"U";"V";"W";"X";"Y";"Z"]]

    numbers = [[string[10] "0"; "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9"]]

    punctuationsMarks = [[string[6] "."; ":"; ";"; "!"; "?"; "-"]]

    symbolSize: int2 = int2(5, 10)
var
    fontImage: ImageHandle

def InitFont()
    fontImage <- create_managed_image(FONT)
    ProcessText("Hello world!")

def TestDrawFont(pos: float2)
    draw_image(fontImage, pos.x, pos.y)

def ProcessText(text: string)
    if text |> length > 0
        for char in text
            print("\n >> {to_char(char)}")
            if to_char(char) == " "
                print("\nThat's a space")
            if to_char(char) == "!"
                print("\nThat's a exclamation mark")       
        var j = 0

def GetLowerCase(index: int): float4
    return float4(0f,0f,0f,0f)

def GetUpperCase(index: int): float4
    return float4(0f,0f,0f,0f)

def GetNumber(index: int): float4
    return float4(0f,0f,0f,0f)

def GetPunctuation(index: int): float4
    return float4(0f,0f,0f,0f)