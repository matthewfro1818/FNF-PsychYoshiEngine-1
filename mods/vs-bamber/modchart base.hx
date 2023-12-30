var allStrums = [];
var allStrumsX = [];
var allStrumsY = 0;
function createPost() {
    for (i in playerStrums.members) {allStrums.push(i); allStrumsX.push(i.x); allStrumsY = i.y;}
    for (i in cpuStrums.members) {allStrums.push(i); allStrumsX.push(i.x);}
}
var time:Float = 0;
function update(elapsed) {
	time = Conductor.songPosition / 1000;
	var i:Int = 0;
	for (strum in allStrums) {
		strum.y = FlxMath.lerp(strum.y, allStrumsY, 0.2*(60/engineSettings.fpsCap));
		strum.x = FlxMath.lerp(strum.x, allStrumsX[i], 0.2*(60/engineSettings.fpsCap));
		i++;
	}
}
//im horribly lazy