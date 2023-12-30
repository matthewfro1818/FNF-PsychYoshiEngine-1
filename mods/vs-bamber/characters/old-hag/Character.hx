function create() {
	character.frames = Paths.getCharacter(character.curCharacter);
	character.loadJSON(true); // Setting to true will override getColors() and dance().
}

function onAnim(animName:String) {
	if (animName == 'danceRight') {
		character.playAnim(Conductor.bpm < 140 || character.animation.curAnim.curFrame > 8 ? 'danceRight_140-' : 'danceRight_140+', true);
		return true;
	}
}