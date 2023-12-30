function doShowDeath(doI) {
    if (doI) boyfriend.animation.play('firstDeath'); else boyfriend.dance(true);
    PlayState.scripts.executeFunc('setCamType', [doI == 'true' ? 'snap' : 'default']);
}