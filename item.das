require daslib/media

var
    items: array<Item?>

struct Item
    itemName: string
    sprite: int

def MakeItems()
    items |> push (MakeItem("NA", 7))
    items |> push (MakeItem("Old Key", 0))
    items |> push (MakeItem("Arrow", 1))
    items |> push (MakeItem("Health Up", 2))
    items |> push (MakeItem("Stamina Up", 3))
    items |> push (MakeItem("Mace", 8))
    items |> push (MakeItem("Axe", 9))
    items |> push (MakeItem("Sword", 10))

def MakeItem(itemName: string; sprite: int): Item?
    var item: Item? = new Item
    item.itemName = itemName
    item.sprite = sprite
    return item

def GetItemByIndex(index: int): Item?
    return items[index]