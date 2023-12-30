//this is not a modchart lmfaoo
function onGuiPopup() {
	for (i in unspawnNotes) {
		if (!i.mustPress) i.cameras = [camGame];
	}
	for (i in strumLineNotes) if (!playerStrums.members.contains(i)) i.cameras = [camGame];
	for (i in cpuStrums) i.x -= 200;
}
function giveBirthToThe3rd() {
	for (i in strumLineNotes) {
		FlxTween.cancelTweensOf(i);
	}
	for (i in 0...cpuStrums.length) {
		cpuStrums.members[i].cameras = [camGame];

		if (i > 3) {
			cpuStrums.members[i].x = cpuStrums.members[i % PlayState.SONG.keyNumber].x;
			FlxTween.tween(cpuStrums.members[i], {x: cpuStrums.members[4].x - (270 + Note.swagWidth * (4-i * 1.1)), notesScale: cpuStrums.members[i].notesScale * 1.1, y: cpuStrums.members[i].y + 100}, Conductor.crochet / 1000, {ease: FlxEase.backOut});
		} else
			FlxTween.tween(cpuStrums.members[i], {x: cpuStrums.members[0].x + (270 + Note.swagWidth * (i * 0.9)), notesScale: cpuStrums.members[i].notesScale * 0.9}, Conductor.crochet / 1000, {ease: FlxEase.backOut});
	}
}