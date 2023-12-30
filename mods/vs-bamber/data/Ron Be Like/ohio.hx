function onDadHit(note) { if (!note.isSustainNote && curBeat >= 72 && curBeat <= 111) dad.angle = FlxG.random.int(0, 360); }
function beatHit(curBeat) { if (curBeat == 112) dad.angle = 0; }
function onDeath() { dad.angle = 0; }