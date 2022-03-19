require daslib/media
require daslib/random

var seed: int4 = random_seed(0)

def getSpriteRect(index, nColumns, nRows : int; tileWidth, tileHeight: float): float4
    var pos: float2 = indexToCoord(index, nColumns, nRows)
    return float4(pos.x * tileWidth, pos.y * tileHeight, tileWidth, tileHeight)

def indexToCoord(index, nColumns, nRows: int): float2
    return float2(index % nRows, index / nColumns)

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