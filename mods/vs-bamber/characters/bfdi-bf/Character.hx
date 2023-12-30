var noteColors = [new FlxColor(character.getColors()[1]),
				  new FlxColor(character.getColors()[2]), 
				  new FlxColor(character.getColors()[3]), 
				  new FlxColor(character.getColors()[4])];

var rawnoteColors = [character.getColors()[1],
					 character.getColors()[2], 
					 character.getColors()[3], 
					 character.getColors()[4]];

function create() {
	character.frames = Paths.getCharacter(character.curCharacter);
	character.loadJSON(true);
}

//first condition for current animation being one of directional ones
//second if there is an end animation
//third if we're playing right now instead of being in character editor
//fourth if we just released a key related to the note anim
if (PlayState != null) {
	function update(elapsed:Float) {
		if (['singUP', 'singDOWN', 'singLEFT', 'singRIGHT'].contains(character.animation.curAnim.name) && character.animation.exists(character.animation.curAnim.name+'-end')
		&& PlayState != null && PlayState.lastKeys.justReleasedArray[['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'].indexOf(character.animation.curAnim.name)]) { //when key just released and note animation is playing, play note end anim
			character.playAnim(character.animation.curAnim.name+'-end');
		}

		if (['singLEFTmiss', 'singRIGHTmiss', 'singUPmiss', 'singDOWNmiss'].contains(character.animation.curAnim.name) && character.animation.curAnim.curFrame == 0) { //hold timer does not reset to 0 with each miss for some reason
			character.holdTimer = 0; //I would have done an onmiss check in a global script but for some reason the onMiss callback did not work
		}
		for (note in PlayState.notes)
		{
			var noteData = note.noteData % PlayState.SONG.keyNumber;
			if (note.mustPress && note.shader.data.enabled.value != [true])
			{
				note.shader.data.enabled.value = [true];
				note.shader.setColors(noteColors[noteData].red,noteColors[noteData].green,noteColors[noteData].blue);
				note.splashColor = rawnoteColors[noteData];
				
				//note.splash = Paths.splashes("bfdi-splash");
			}
		}
		for (i in 0...PlayState.playerStrums.length) {
			if (!PlayState.playerStrums.members[i].colored)
				PlayState.playerStrums.members[i].colored = true;
		}
	}

	function onAnim(animationName:String) {
		if (character.animation.exists(animationName) && character.animation.curAnim != null) {
			if (character.animation.curAnim.name == animationName && character.holdTimer > 0) { // no sustain stutter
				return true;
			}
			if (animationName == 'idle' && ((['singUP-end', 'singDOWN-end', 'singLEFT-end', 'singRIGHT-end'].contains(character.animation.curAnim.name) && !character.animation.curAnim.finished) //if note end is playing
			|| (['singUP', 'singDOWN', 'singLEFT', 'singRIGHT'].contains(character.animation.curAnim.name) && character.animation.exists(character.animation.curAnim.name+'-end') //or if we just gonna have note end anim
			&& PlayState != null && PlayState.lastKeys.justReleasedArray[['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'].indexOf(character.animation.curAnim.name)]))) {
				return true;
			}
		}
	}
}