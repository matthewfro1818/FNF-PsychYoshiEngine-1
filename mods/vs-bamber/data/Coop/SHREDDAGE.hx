var shredder;
var defaultDad;

function createInFront() {
    shredder = new Character(dad.x - dad.charGlobalOffset.x, dad.y - dad.charGlobalOffset.y,mod+':davey-shred');
    insert(PlayState.members.indexOf(dad), shredder);
    shredder.alpha = 0.00001;
    defaultDad = dad;
}

function beatHit(beat) {
    if (beat == 285) dad.playAnim('shredTransition', true);
    else if (beat == 346) shredder.playAnim('shredTransition', true);
    else if (beat == 413) dad.playAnim('shredTransition', true);
    else if (beat == 434) shredder.playAnim('shredTransition', true);
    
    if (beat == 288 || beat == 416) {
        dad.alpha = 0;
        shredder.alpha = 1;
        dads[0] = shredder;
    }
    if (beat == 349 || beat == 437) {
        shredder.alpha = 0;
        defaultDad.alpha = 1;
        dads[0] = defaultDad;
    }
}