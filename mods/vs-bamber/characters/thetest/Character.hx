import Settings;

function create() {
	// character settings
	character.frames = Paths.getCharacter(character.curCharacter);
	character.loadJSON(true);
}