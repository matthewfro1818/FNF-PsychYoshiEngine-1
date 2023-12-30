if (PlayState != null) {
	function create() {
		character.frames = Paths.getCharacter(character.curCharacter);
		character.loadJSON(true);
		character.scale.set(13,13);
		character.camOffset.x -= 4000;
		character.camOffset.y -= 4000;
	}

	function update(elapsed) {
		character.y += Math.sin(Conductor.songPosition/1000) * 3.5;
	}

	function onAnim(animationName:String) {
		if (character.animation.exists(animationName) && character.animation.curAnim != null && ['singUP', 'singDOWN', 'singLEFT', 'singRIGHT'].contains(animationName)) PlayState.health -= PlayState.health > 0.02 ? 0.02 : 0;
	}
} else {
	function create() {
		character.frames = Paths.getCharacter(character.curCharacter);
		character.loadJSON(true);
	}
}