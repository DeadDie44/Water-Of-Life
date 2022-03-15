require daslib/media
require daslib/random

var seed: int4 = random_seed(0)

def getSpriteRect(index, nColumns, nRows : int; tileWidth, tileHeight: float): float4
    var x, y: float

    x = float(index % nRows)
    y = float(index / nColumns)

    return float4(x * tileWidth, y * tileHeight, tileWidth, tileHeight)

def random_int(a: int)
    randomize_seed(seed)
    return random_int(seed) % a

def random_float(a,b:float)
    randomize_seed(seed)
    return a + random_float(seed) * (b-a)