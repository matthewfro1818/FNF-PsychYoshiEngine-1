function createInFront() {
    PlayState.scripts.executeFunc('setCamType', ['snap']);
}

function updatePost() {
    notes.forEachAlive(function(note) {
        var strum = (note.mustPress ? playerStrums.members : cpuStrums.members)[(note.noteData % PlayState_.SONG.keyNumber) % song.keyNumber];

        if ((!note.mustPress || note.wasGoodHit) && note.isSustainNote && Conductor.songPosition > note.strumTime - (note.swagWidth / (0.45 * FlxMath.roundDecimal(strum.getScrollSpeed(), 2)) / 2)) {
            note.visible = false; //if I were to kill it immediately, Dad's animation only would play once. I tried.
            //But then why not try onDadHit? It's used after sustains are done disappearing, which is not what I wanted.
        }
    });
}

function onPlayerHit(note) {
    if (note.isSustainNote) {
        note.active = note.visible = false;
		note.kill();
		notes.remove(note, true);
		note.destroy();
    }
}