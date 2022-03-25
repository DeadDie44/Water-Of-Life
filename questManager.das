require strings

require helpers/textHelper

//Пусть реплики будут идти парами: сначала идёт вступительная реплика для текущей стадии, а потом реплика повтороного разговора на той же стадии
struct Quest
    NPCName: string
    trigger: string
    progress: int
    dialogText: array<string>

var
    questContainer: array<Quest?>

def ProgressQuest(var quest: Quest?)
    if quest.progress % 2 != 0
        quest.progress += 1
    else 
        quest.progress += 2

def InitQuests
    MakeTable()
    questContainer |> push (MakeQuest("Old Lady", "Old Key"))
    questContainer |> push (MakeQuest("Baba Yaga", ""))
    questContainer |> push (MakeQuest("Leshy", "Verlioka"))

def MakeQuest(NPCName, trigger: string): Quest?
    var quest: Quest? = new Quest
    quest.NPCName = NPCName
    quest.trigger = trigger

    var i: int = 1
    while (key_exists(textTable, "{NPCName}.Intro{i}"))
        quest.dialogText |> push(textTable["{NPCName}.Intro{i}"])
        quest.dialogText |> push(textTable["{NPCName}.Reminder{i}"])
        i++
    return quest

def GetQuestByName(NPCName: string): Quest?
    var quest: Quest?
    for q in questContainer
        if q.NPCName == NPCName
            return q
    return quest

def GetQuestByTrigger(trigger: string): Quest?
    var quest: Quest?
    for q in questContainer
        if q.trigger == trigger
            return q
    return quest
