require gameObject

class public GameCharacter: GameObject
    private healthPoints, healthCap:int
    
    def LoseHealth(damage:int)
        healthPoints -= damage

    def GetCurrentHealth : int
        return healthPoints

    def GetHealthCap : int
        return healthCap