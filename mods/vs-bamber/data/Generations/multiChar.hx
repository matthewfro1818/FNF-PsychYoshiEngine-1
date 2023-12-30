var screwer;
var joker;

var secondIcon;
var thirdIcon;

//So the preloaded characters must be drawn on the screen firstly because otherwise the caching system will not be aware of their existence.
//To reinforce this, I made sure their alpha was set to a really low non-zero float. It will think there is something to draw to the GPU, but it will be invisible enough to not be noticable at all.
//This will make it remember and not cause lag spikes whenever those preloads are needed.

//Yes I tried it with alpha 0. Yes I tried it with visible off. Yes I tried it with making them completely opaque, but moving them outside the screen ASAP. None of those methods provided lag-less results.
//That's my word of advice.

//Just remember, this is for preloading what is meant to exist later during the song, not when you want these characters from the start. Then you're fine with ignoring the alpha stuff.
function createInFront() {
    screwer = new Character(dad.x - dad.charGlobalOffset.x, dad.y - dad.charGlobalOffset.y,mod+':gen-screwer');
    add(screwer);
    screwer.alpha = 0.000001;
    screwer.color = 0xFF000000;

    joker = new Character(dad.x - dad.charGlobalOffset.x, dad.y - dad.charGlobalOffset.y,mod+':gen-joker');
    add(joker);
    joker.alpha = 0.000001;
    joker.color = 0xFF000000;

    secondIcon = new HealthIcon(mod+':gen-screwer', false);
    add(secondIcon);
    secondIcon.alpha = 0.000001;
    secondIcon.color = 0xFF000000;

    thirdIcon = new HealthIcon(mod+':gen-joker', false);
    add(thirdIcon);
    thirdIcon.alpha = 0.000001;
    thirdIcon.color = 0xFF000000;

    PlayState.scripts.executeFunc('setCamType', ['classic']);
}

//Now only if that preloading would work on the fly without lag. Then we could have some awesome memory management whenever there's going to be tons of objects in a song in general.
//Imagine a song with lots of scenes like if it was a music video.

function onPreSongStart() {
    screwer.x -= 1800;
    screwer.alpha = 1;
    joker.x -= 3000;
    joker.alpha = 1;
}

function beatHit(beat) {
    if (beat == 64) {
        FlxTween.tween(screwer, {x: dad.x}, 1, {ease: FlxEase.backOut});
        FlxTween.tween(dad, {x: dad.x + 200, y: dad.y - 30}, 0.5, {ease: FlxEase.backInOut});
        dads[0] = screwer;

        FlxTween.tween(secondIcon, {alpha: 1}, 0.5, {ease: FlxEase.backInOut});
        PlayState.scripts.executeFunc('setCamType', ['snap']);
    }
    if (beat == 80) {
        screwer.color = 0xFFFFFFFF;
        secondIcon.color = 0xFFFFFFFF;
        PlayState.scripts.executeFunc('setCamType', ['classic']);
    }
    if (beat == 129) {
        FlxTween.tween(joker, {x: screwer.x + 100}, 1, {ease: FlxEase.backOut});
        FlxTween.tween(screwer, {x: screwer.x - 200, y: screwer.y - 50}, 0.5, {ease: FlxEase.backInOut});
        dads[0] = joker;

        FlxTween.tween(thirdIcon, {alpha: 1}, 0.5, {ease: FlxEase.backInOut});
        PlayState.scripts.executeFunc('setCamType', ['snap']);
    }
    if (beat == 136) {
        joker.color = 0xFFFFFFFF;
        thirdIcon.color = 0xFFFFFFFF;
        PlayState.scripts.executeFunc('setCamType', ['classic']);
    }
}