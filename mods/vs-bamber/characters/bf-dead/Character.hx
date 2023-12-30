function create() {
	character.frames = Paths.getCharacter(character.curCharacter);
	character.loadJSON(true);
}

function onAnim(animationName) {
	if (PlayState != null && animationName == 'idle') return true; //pesky errors
}