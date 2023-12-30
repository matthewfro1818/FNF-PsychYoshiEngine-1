import Note;
import flixel.math.FlxPoint;

function createInFront() {
    PlayState.scripts.executeFunc('setCamType', ['classic']);
}

var lastScaleY;

function beatHit(curBeat) {
    if (curBeat == 192) {
        PlayState.scripts.executeFunc('changeNoteskin', [Paths.getSparrowAtlas('characters/joke_davey_obj/NOTE_assets', mod, false), 'both']);

        for (i in [unspawnNotes, notes.members]) {
            for (a in i) {
                if (a.isSustainNote) a.alpha = 1;
            }
        }
    }
}