var allStrums = [];
var allStrumsX = [];

function createPost() {
    if (!PlayState.engineSettings.middleScroll) { for (i in PlayState.cpuStrums.members) {allStrums.push(i); allStrumsX.push(i.x);} }
    for (i in PlayState.playerStrums.members) {allStrums.push(i); allStrumsX.push(i.x);}

    switchModchart(save.data.vs_bamber_modChart[PlayState.SONG.song.toLowerCase()]);
}

function update60(elapsed) {
    var i = 0;
    for (strum in allStrums) {
        strum.x = FlxMath.lerp(strum.x, 
            (save.data.vs_bamber_modChart[PlayState.SONG.song.toLowerCase()] && engineSettings.watermark) ? allStrumsX[i] - ((Math.sin(Conductor.songPosition/1000) * 1.5)) * 125 * ((strum.isCpu && !PlayState.engineSettings.middleScroll) || (i < 2 && PlayState.engineSettings.middleScroll) ? -1 : 1) - ((Math.sin(Conductor.songPosition/1000) * 100 * (i % 2 == 0 ? 1 : -1))) : allStrumsX[i],
            0.5);
        i++;
    }
}

function switchModchart(switcher) {
    watermark.visible = (switcher && engineSettings.watermark);
}