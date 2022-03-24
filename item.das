require daslib/media

var
    items: array<Item?>

struct Item
    itemName: string
    sprite: int

def MakeItems()
    items |> push (MakeItem("Old Key", 0))

def MakeItem(itemName: string; sprite: int): Item?
    var item: Item? = new Item
    item.itemName = itemName
    item.sprite = sprite
    return item