function create() {
	character.frames = Paths.getCharacter(character.curCharacter);
	character.loadJSON(true);
}

//No recoloring notes since he's a secondary
function update(elapsed:Float) {
	if (['singUP', 'singDOWN', 'singLEFT', 'singRIGHT'].contains(character.animation.curAnim.name) && character.animation.exists(character.animation.curAnim.name+'-end') && character.animation.curAnim.finished
	&& character.holdTimer > 0.13) { //0.13 seems to be just enough for no stuttering but also for smoothness with single notes
		character.playAnim(character.animation.curAnim.name+'-end');
	}
}

function onAnim(animationName:String) {
	if (character.animation.exists(animationName) && character.animation.curAnim != null) {
		if (character.animation.curAnim.name == animationName && character.holdTimer > 0.05) { // this works but it doesn't hold so well with jacks, not like it's anything major anyways
			character.holdTimer = 0;
			return true;
		}
		if (['danceRight', 'danceLeft'].contains(animationName) && ['singUP-end', 'singDOWN-end', 'singLEFT-end', 'singRIGHT-end'].contains(character.animation.curAnim.name) && !character.animation.curAnim.finished) {
			return true;
		}
	}
}