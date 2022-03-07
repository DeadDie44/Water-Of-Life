require daslib/media

require gameObject

class public GameCharacter: GameObject
    private healthPoints, healthCap: int
    
    shadowSprite: Image

    def loseHealth(damage: int)
        healthPoints -= damage

    def getCurrentHealth: int
        return healthPoints

    def getHealthCap: int
        return healthCap