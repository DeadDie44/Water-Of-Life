require strings

require helpers/textHelper

//Пусть реплики будут идти парами: сначала идёт вступительная реплика для текущей стадии, а потом реплика повтороного разговора на той же стадии
struct Quest
    NPCName: string
    progress: int
    dialogText: array<string>

var
    questContainer: array<Quest?>

def InitQuests
    MakeTable()
    questContainer |> push (MakeQuest("Old Lady"))
    questContainer |> push (MakeQuest("Baba Yaga"))
    questContainer |> push (MakeQuest("Leshy"))

def MakeQuest(NPCName: string): Quest?
    var quest: Quest? = new Quest
    quest.NPCName = NPCName
    for k, v in keys(textTable), values(textTable)
        if starts_with(k, NPCName)
            quest.dialogText |> push (v)
    return quest

def GetQuest(NPCName: string): Quest?
    var quest: Quest?
    for q in questContainer
        if q.NPCName == NPCName
            return q
    return quest
