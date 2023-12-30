function create() {
	// character settings
	character.frames = Paths.getCharacter(character.curCharacter);
	character.loadJSON(true);
	character.addCameraOffset("singLEFT", -35, 0);
    character.addCameraOffset("singDOWN", 0, 35);
    character.addCameraOffset("singUP", 0, -35);
    character.addCameraOffset("singRIGHT", 35, 0);
}
function update(elapsed:Float) {
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