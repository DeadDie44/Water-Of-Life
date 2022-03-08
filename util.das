def getSpriteRect(index, nColumns, nRows : int; tileWidth, tileHeight: float): float4
    var x, y: float

    x = float(index % nRows)
    y = float(index / nColumns)

    return float4(x * tileWidth, y * tileHeight, tileWidth, tileHeight)