function create() {
	character.frames = Paths.getCharacter(character.curCharacter);
	character.loadJSON(true);
}

//bfdi boyfriend's animation script, but for CPUs
function update(elapsed:Float) {
	if (['singUP', 'singDOWN', 'singLEFT', 'singRIGHT'].contains(character.animation.curAnim.name) && character.animation.exists(character.animation.curAnim.name+'-end') && character.animation.curAnim.finished
	&& character.holdTimer > 0.13) { //0.13 seems to be just enough for no stuttering but also for smoothness with single notes
		character.playAnim(character.animation.curAnim.name+'-end');
	}
	for (note in PlayState.notes)
		{
			var noteData = note.noteData % PlayState.SONG.keyNumber + 1;
			if (!note.mustPress && note.shader.data.enabled.value != [true])
			{
				note.shader.data.enabled.value = [true];
				note.shader.setColors(new FlxColor(PlayState.dad.getColors()[noteData]).red,new FlxColor(PlayState.dad.getColors()[noteData]).green,new FlxColor(PlayState.dad.getColors()[noteData]).blue);
				note.splashColor = PlayState.dad.getColors()[noteData];
			}
		}
		for (i in 0...PlayState.cpuStrums.length) {
			if (!PlayState.cpuStrums.members[i].colored)
				PlayState.cpuStrums.members[i].colored = true;
		}
}

function onAnim(animationName:String) {
	if (character.animation.exists(animationName) && character.animation.curAnim != null) {
		if (character.animation.curAnim.name == animationName && character.holdTimer > 0.05) { // this works but it doesn't hold so well with jacks, not like it's anything major anyways
			character.holdTimer = 0;
			return true;
		}
		if (animationName == 'idle' && ['singUP-end', 'singDOWN-end', 'singLEFT-end', 'singRIGHT-end'].contains(character.animation.curAnim.name) && !character.animation.curAnim.finished) {
			return true;
		}
	}
}