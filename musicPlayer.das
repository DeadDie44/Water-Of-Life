require daslib/media
//require sound

var
    currentMusic: SoundHandle
    currentVolume: float
    fadeTimer: float

def TransitionMusic(dt: float)
    fadeTimer += dt
    currentVolume -= dt
    //set_sound_volume(currentMusic, currentVolume)

def PlayMusic
    var i = 0
    //if currentMusic != null