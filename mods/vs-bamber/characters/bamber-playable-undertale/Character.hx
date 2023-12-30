function create() {
	character.frames = Paths.getCharacter(character.curCharacter);
	character.loadJSON(true);
}

function update(elapsed:Float) {
	for (note in PlayState.notes)
	{
		var noteData = note.noteData % PlayState.SONG.keyNumber + 1;
		if (note.mustPress && note.shader.data.enabled.value != [true])
		{
			note.shader.data.enabled.value = [true];
			note.shader.setColors(new FlxColor(PlayState.boyfriend.getColors()[noteData]).red,new FlxColor(PlayState.boyfriend.getColors()[noteData]).green,new FlxColor(PlayState.boyfriend.getColors()[noteData]).blue);
			note.splashColor = PlayState.boyfriend.getColors()[noteData];
		}
	}
	for (i in 0...PlayState.playerStrums.length) {
		PlayState.playerStrums.members[i].colored = (PlayState.playerStrums.members[i].animation.curAnim.name == 'confirm');
	}
}