import flixel.util.FlxGradient;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.particles.FlxTypedEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitterMode;
import flixel.math.FlxRandom;
import lime.utils.Assets;
import HeaderCompilationBypass;
import Main;
import openfl.text.TextFormat;
import Reflect;

var bamballer:FlxSprite;
var bg:FlxBackdrop;
var bgl:FlxBackdrop;
var gradient:FlxGradient;
var logoBl:FlxSprite;
var time:Float = 0;
var camTween:FlxTween;

FlxG.scaleMode.isWidescreen = false;

function create()
{
	//title window
    FlxG.stage.window.title = "Vs Bamber And Davey V2 | Title Screen";
	HeaderCompilationBypass.setWindowIcon(Paths.modsPath+'/'+mod+'/icon.ico'); //love it when like, you boot YCE with the mod, and the icon doesn't change, so I had to do this

	bg = new FlxBackdrop(Paths.image('titlescreen/checkerboard'), 0.2, 0.1, true, true);
	bg.scrollFactor.set(0.2,0.1);
	bg.screenCenter();
	bg.scale.set(2,2);
	bg.alpha = 0.2;
	add(bg);
	
	bgl = new FlxBackdrop(Paths.image('titlescreen/checkerboard'), 0.2, 0.1, true, true);
	bgl.scrollFactor.set(0.2,0.1);
	bgl.screenCenter();
	bgl.scale.set(4,4);
	bgl.alpha = 0.1;
	add(bgl);
	
	gradient = FlxGradient.createGradientFlxSprite(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), [0xFF5173f9, 0x00000000]);
	gradient.angle = 180;
	gradient.scrollFactor.set();
	gradient.screenCenter();
	add(gradient);
	
	var emitter = new FlxTypedEmitter(0, 0, 300);
	//add(emitter);
	for (i in 0...150)
	{
		var p = new FlxParticle();
		var p2 = new FlxParticle();
		p.makeGraphic(12,12,0xFF5173f9);
		p2.makeGraphic(24,24,0xFF5173f9);
					
		emitter.add(p);
		emitter.add(p2);
	}
	emitter.width = FlxG.width*1.5;
	emitter.launchMode = FlxEmitterMode.SQUARE;
	emitter.velocity.set(-10, -240, 10, -320);
	emitter.lifespan.set(5);
	emitter.start(true, 0.05);
	emitter.x = FlxG.camera.scroll.x;
	emitter.y = FlxG.camera.scroll.y-40;

	bamballer = new FlxSprite(0, 0).loadGraphic(Paths.image('titlescreen/bamballer'));
    bamballer.screenCenter();
	bamballer.scale.x = 0.8;
	bamballer.scale.y = 0.8;
	bamballer.x += 300;
    add(bamballer);

	logoBl = new FlxSprite();
	logoBl.scale.set(0.85,0.85);
	logoBl.screenCenter();
	logoBl.x -= 640;
	logoBl.y -= 360;
	logoBl.frames = Paths.getSparrowAtlas('modLogo');
	logoBl.animation.addByPrefix('bump', 'LogoDownscaled', 24, false);
	logoBl.animation.play('bump');
	logoBl.updateHitbox();
	add(logoBl);

	Main.fps.defaultTextFormat = new TextFormat(Paths.font('vcr'), 12, Main.fps.color);
}

function update(elapsed) 
{
	if (curBeat < 2 && textGroup.members.length == 0) createCoolText([introConf.authors[0]]); //make sure the first text always shows up (on occasion it didn't)

	time += elapsed;
	bamballer.angle = Math.sin(time)*5;
	bg.x -= 2;
	bg.y += 0.5;
	bgl.x -= 1;
	bgl.y += 0.25;
}

function beatHit(elapsed) 
{
	if ((curBeat % 2 == 0))
	{
		logoBl.animation.play('bump', true);
		if (camTween != null) camTween.cancel();
		FlxG.camera.zoom += 0.05;
		camTween = FlxTween.tween(FlxG.camera, {zoom: 1}, 1, {ease: FlxEase.backOut});
	}
}

var allTexts = getIntroTextShit();
var usedTexts = [];

function textShit(curBeat) {
    switch(curBeat) {
        case 1:
            deleteCoolText();
        case 2, 3, 4, 5:
            addMoreText(introConf.authors[curBeat-1]);
        case 6:
            addMoreText(introConf.present);
        case 8:
            deleteCoolText();
            createCoolText([introConf.assoc[0]]);
        case 10:
            addMoreText(introConf.assoc[1]);
        case 12:
            ngSpr.visible = true;
        case 14:
            addMoreText(introConf.newgrounds);
        case 16:
            ngSpr.visible = false;
            deleteCoolText();
            createCoolText([]);
        case 28:
            deleteCoolText();
            createCoolText([introConf.gameName[0]]);
        case 29, 30, 31:
            addMoreText(introConf.gameName[curBeat - 28]);
        case 32:
            skipBeat = 32;
			skipIntro();
            remove(credGroup);
    }

    if (curBeat >= 16 && curBeat < 28) {
        if (curBeat % 4 == 0) {
            var picked = new FlxRandom().int(0, allTexts.length-1, usedTexts);
            usedTexts.push(picked);
            curWacky = allTexts[picked];
            deleteCoolText();
            createCoolText([curWacky[0]]);
        } else if (curBeat % 4 == 2) {
            addMoreText(curWacky[1]);
        }
    }

    return false;
}