function create() {
	character.frames = Paths.getCharacter(character.curCharacter);
	character.loadJSON(true);
}

var lastElapsedTime = 0;
function update(elapsed:Float) {
	lastElapsedTime += elapsed;
	if (lastElapsedTime >= 1) {
		lastElapsedTime = 0;
		for (note in PlayState.notes)
		{
			var noteData = note.noteData % PlayState.SONG.keyNumber;
			if (!note.mustPress && note.shader.data.enabled.value != [true])
			{
				note.shader.data.enabled.value = [true];
				note.shader.setColors(new FlxColor(character.getColors()[noteData]).red,new FlxColor(character.getColors()[noteData]).green,new FlxColor(character.getColors()[noteData]).blue);
				note.splashColor = character.getColors()[noteData];
			}
		}
		for (i in 0...PlayState.playerStrums.length) {
			if (!PlayState.playerStrums.members[i].colored)
				PlayState.playerStrums.members[i].colored = true;
		}
	}
}