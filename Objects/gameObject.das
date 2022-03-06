require daslib/media
require physics/collisionManager

class GameObject

    showCollider:bool = true
    
    colliderType: int

    colliderSize: float
    pos: float2

    spriteSheet: ImageHandle

    speed: float = 75f
    currentFrame: int = 0
    fps: float = 12f
    frameTime: float
    direction: float2

    animationState: int = 0

    idleAnimationUp = [[int[1]25]]
    idleAnimationDown = [[int[1]26]]
    idleAnimationSide = [[int[1]24]]

    runAnimationUp = [[int[8]25;0;1;2;25;3;4;5]]
    runAnimationDown = [[int[8]26;12;13;14;26;15;16;17]]
    runAnimationSide = [[int[8]24;6;7;8;24;9;10;11]]
    
    attackAnimationUp = [[int[7]35;36;37;38;39;40;41]]
    attackAnimationDown = [[int[7]28;29;30;31;32;33;34]]
    attackAnimationSide = [[int[7]42;43;44;45;46;47;48]]
    
    currentAnimation: array<int>
    
    size: float = 32f