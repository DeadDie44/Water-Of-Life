require daslib/media

var
    items: array<Item?>

struct Item
    itemName: string
    sprite: int

def MakeItems()
    items |> push (MakeItem("Old Key", 0))
    items |> push (MakeItem("Arrow", 1))

def MakeItem(itemName: string; sprite: int): Item?
    var item: Item? = new Item
    item.itemName = itemName
    item.sprite = sprite
    return item

def GetItemByIndex(index: int): Item?
    return items[index - 1]