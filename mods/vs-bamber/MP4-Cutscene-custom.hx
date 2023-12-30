// TO USE, ADD A "yoursong-cutscene.mp4" FILE IN YOUR VIDEOS FOLDER. IT WILL BE HANDLED AUTOMATICALLY
import openfl.utils.Assets;
function create() {
	if (FlxG.save.data.vs_bamber_hasDiedInThisSong || PlayState.fromCharter) {
        startCountdown();
        return false;
    }

    var mFolder = Paths_.modsPath;
    
    var path = Paths.video(PlayState.song.song.toLowerCase() + "-cutscene", 'mods/' + PlayState_.songMod);
    trace(path);
    if (!Assets.exists(path)) {
        trace("Video not found.");
        if (!Assets.exists(Paths.json(PlayState.SONG.song + '/dialogue'))) startCountdown(); else PlayState.scripts.executeFunc('startDialog');
        return;
    }

    var wasWidescreen = PlayState.isWidescreen;
    var videoSprite:FlxSprite = null;
    
    PlayState.isWidescreen = false;
    PlayState.camHUD.bgColor = 0xFF000000;
    videoSprite = MP4Video.playMP4(Assets.getPath(path),
        function() {
            PlayState.remove(videoSprite);
            PlayState.isWidescreen = wasWidescreen;
            PlayState.camHUD.bgColor = 0x00000000;
            PlayState.inCutscene = false;
            if (!Assets.exists(Paths.json(PlayState.SONG.song + '/dialogue'))) startCountdown(); else PlayState.scripts.executeFunc('startDialog');
        },
        // If midsong.
        false, FlxG.width, FlxG.height);

    videoSprite.cameras = [PlayState.camHUD];
    videoSprite.scrollFactor.set();
    PlayState.add(videoSprite);
}