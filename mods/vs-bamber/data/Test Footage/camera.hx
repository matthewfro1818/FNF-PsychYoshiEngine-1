var reminisce = new FlxSprite();
var ripple;

function createInFront() {
    PlayState.scripts.executeFunc('setCamType', ['snap']);

    reminisce.loadGraphic(Paths.image('reminiscence/bamber'));
    reminisce.scale.set(3.4, 3.4);
    reminisce.updateHitbox();
    reminisce.screenCenter();
    reminisce.cameras = [camHUD];
    reminisce.antialiasing = true;
    add(reminisce);
    reminisce.alpha = 0;

    ripple = PlayState.scripts.getVariable('rippleShader');
    reminisce.shader = ripple;
}

shaderTimer = 0;
function updatePost(elapsed) {
    if (reminisce.alpha > 0) {
        shaderTimer += elapsed;
    }
    ripple.data.uTime.value = [shaderTimer];

    notes.forEachAlive(function(note) {
        var strum = (note.mustPress ? playerStrums.members : cpuStrums.members)[(note.noteData % PlayState_.SONG.keyNumber) % song.keyNumber];

        if ((!note.mustPress || note.wasGoodHit) && note.isSustainNote && Conductor.songPosition > note.strumTime - (note.swagWidth / (0.45 * FlxMath.roundDecimal(strum.getScrollSpeed(), 2)) / 2)) {
            note.active = note.visible = false; //But as opposed to Placeholder, it doesn't matter here because the opponent is a fucking motionless square.
            note.kill();
            notes.remove(note, true);
            note.destroy();
        }
    });
}

function beatHit(curBeat) {
    if (curBeat == 88) rippleEffect('bamber');
    if (curBeat == 92) rippleEffect('davey');
}

function rippleEffect(image) {
    reminisce.alpha = 0.6;
    reminisce.loadGraphic(Paths.image('reminiscence/'+image));
    shaderTimer = 0;
    FlxTween.tween(reminisce, {alpha: 0}, Conductor.stepCrochet / 250 * 6);

    PlayState.scripts.executeFunc('changeScrollSpeed', ['multiply', 4, 'both', 0.001, 'quartIn']);
    PlayState.scripts.executeFunc('changeScrollSpeed', ['set', (engineSettings.customScrollSpeed ? engineSettings.scrollSpeed : PlayState.SONG.speed), 'both', 8, 'quartOut']);
}

function onPlayerHit(note) {
    if (note.isSustainNote) {
        note.active = note.visible = false;
		note.kill();
		notes.remove(note, true);
		note.destroy();
    }
}