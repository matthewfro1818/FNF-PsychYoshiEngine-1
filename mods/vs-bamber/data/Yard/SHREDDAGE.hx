import Conductor;

var shredder;
var defaultDad;

function createInFront() {
    shredder = new Character(dad.x - dad.charGlobalOffset.x, dad.y - dad.charGlobalOffset.y,mod+':davey-shred');
    insert(PlayState.members.indexOf(dad), shredder);
    shredder.alpha = 0.00001;
    defaultDad = dad;
}

function beatHit(beat) {
    if (beat == 89) dad.playAnim('shredTransition', true);
    else if (beat == 184) shredder.playAnim('shredTransition', true);
    
    if (beat == 92) {
        dad.alpha = 0;
        shredder.alpha = 1;
        dads[0] = shredder;
    }
    if (beat == 187) {
        shredder.alpha = 0;
        defaultDad.alpha = 1;
        dads[0] = defaultDad;
    }

    if (beat == 384) {
        PlayState.scripts.executeFunc('changeScrollSpeed', ['multiply', 0.75, 'both', 2, 'quartInOut']);
    }
}