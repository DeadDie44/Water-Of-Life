require daslib/media
require daslib/random

var seed: int4 = random_seed(0)

def getSpriteRect(index, nColumns, nRows : int; tileWidth, tileHeight: float): float4
    var x, y: float

    x = float(index % nRows)
    y = float(index / nColumns)

    return float4(x * tileWidth, y * tileHeight, tileWidth, tileHeight)

def iterateSeed()
    seed.x += 1
    seed.y += 1
    seed.z += 1
    seed.w += 1

def random_int(a: int)
    iterateSeed()
    return random_int(seed) % a

def random_float(a,b:float)
    iterateSeed()
    return a + random_float(seed) * (b-a)