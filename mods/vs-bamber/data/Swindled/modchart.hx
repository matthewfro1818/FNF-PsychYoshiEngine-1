import flixel.math.FlxRandom;
import Conductor;
import CoolUtil;

var allStrums = [];
var allStrumsX = [];
var allStrumsY = [];
var allStrumsAngle = [];

var startTimer = 0;
var enableCircle = false;
var enableYWave = false;
var enableXScroll = false;
var enableKickBop = false;
var enableStillStrum = false;
var enableSpinAddon = false;
var enableStar = false;

var enableAtom = false;
var circler1 = new FlxSprite();
var circler2 = new FlxSprite();
var circler3 = new FlxSprite();
circler1.cameras = [camHUD];circler2.cameras = [camHUD];circler3.cameras = [camHUD];
add(circler1);add(circler2);add(circler3);
var circlerObjects = [circler1, circler2, circler3];

var mod_spacing = 1.0;
var mod_speed = 1.0;
var mod_yAmount = 50;
var mod_xAmount = 500;

var defaultStrumX = [];
var defaultStrumY = 0;

function createPost() {
    if (!engineSettings.middleScroll) { for (i in cpuStrums.members) {allStrums.push(i); allStrumsX.push(i.x); allStrumsY.push(i.y); defaultStrumX.push(i.x); allStrumsAngle.push(0);} }
    for (i in playerStrums.members) {allStrums.push(i); allStrumsX.push(i.x); allStrumsY.push(i.y); defaultStrumX.push(i.x); defaultStrumY = i.y; allStrumsAngle.push(0);}
}

var time:Float = 0;
function update60(elapsed) {
    if (curBeat <= 513) time = Conductor.songPosition / 450;
    else if (time >= 20) time -= (Conductor.crochet / 1000);
    
    var i:Int = 0;

    if (save.data.vs_bamber_modChart[PlayState.SONG.song.toLowerCase()]) {
        if (enableAtom) {
            for (circle in 0...circlerObjects.length) {
                circlerObjects[circle].y = allStrumsY[0] + Math.sin((Conductor.songPosition - startTimer) / 250 + (Math.PI / 3 * circle * mod_spacing)) * (mod_yAmount + mod_xAmount * 2) * (engineSettings.downscroll ? 1 : -1) + mod_xAmount / 8;
                circlerObjects[circle].x = allStrumsX[0] + Math.cos((Conductor.songPosition - startTimer) / 250 + (Math.PI / 3 * circle * mod_spacing)) * (mod_yAmount + mod_xAmount * 2) * mod_speed;

                circlerObjects[circle].x += allStrumsY[0] + Math.cos((Conductor.songPosition - startTimer) / 500 + (Math.PI / 3 * circle * mod_spacing)) * (mod_yAmount) * (engineSettings.downscroll ? 1 : -1) - (guiSize.x / 4);
                circlerObjects[circle].y += allStrumsX[0] + Math.cos((Conductor.songPosition - startTimer) / 500 + (Math.PI / 3 * circle * mod_spacing)) * (mod_yAmount) * mod_speed - guiSize.y / 2 * 1.65;
            }
        }

        for (strum in allStrums) {
            if (enableCircle) {
                strum.y = defaultStrumY + (mod_yAmount * (engineSettings.downscroll ? -1 : 1) + Math.sin((Conductor.songPosition - startTimer) / 500 + (Math.PI / 8 * (i + (i > 3 ? 4 : 0)) * mod_spacing)) * mod_yAmount * (engineSettings.downscroll ? 1 : -1));
                strum.x = (guiSize.x / 2 - strum.width / 2) + Math.cos((Conductor.songPosition - startTimer) / 500 + (Math.PI / 8 * (i + (i > 3 ? 4 : 0)) * mod_spacing)) * -mod_xAmount * mod_speed;
                strum.notesScale = 0.8 + Math.sin((Conductor.songPosition - startTimer) / 500 + (Math.PI / 8 * (i + (i > 3 ? 4 : 0)) * mod_spacing)) * 0.2;

                if (enableSpinAddon) {
                    strum.x += (mod_yAmount + Math.sin((Conductor.songPosition - startTimer) / 500 / 3 * 4 + (Math.PI * 2 / 8 * i * mod_spacing)) * mod_yAmount/2) - (guiSize.x / 4);
                    strum.y += (guiSize.x / 2 - strum.width / 2) + Math.sin((Conductor.songPosition - startTimer) / 500 / 3 * 4 + (Math.PI * 2 / 8 * i * mod_spacing)) * -mod_xAmount/2 * mod_speed * (engineSettings.downscroll ? 1 : -1) - guiSize.y / 2 * 1.58;
                }
            }

            if (enableYWave) {
                allStrumsY[i] = defaultStrumY + (Math.sin((Conductor.songPosition - startTimer) / 500 + (Math.PI * 2 / 8 * i * mod_spacing))) * mod_yAmount * (engineSettings.downscroll ? -1 : 1);
            }

            if (enableXScroll) {
                if (mod_speed < 0 && allStrumsX[i] <= 0 - strum.width) { 
                    allStrumsX[i] = guiSize.x;
                    strum.x = allStrumsX[i];
                }
                else if (mod_speed >= 0 && allStrumsX[i] >= guiSize.x) {
                    allStrumsX[i] = 0 - strum.width;
                    strum.x = allStrumsX[i];
                }

                allStrumsX[i] += mod_xAmount * mod_speed;
                strum.angle = mod_xAmount * mod_speed * 4 * (engineSettings.downscroll ? -1 : 1);
                strum.x = FlxMath.lerp(strum.x, allStrumsX[i], 0.4);
            }

            if (enableStillStrum) {
                allStrumsY[i] += Math.pow(FlxMath.roundDecimal(strum.getScrollSpeed(), 2), 2) * (engineSettings.downscroll ? -2 : 2);
                strum.y = allStrumsY[i];
            }

            if (enableStar) {
                strum.x = FlxMath.lerp(strum.x, allStrumsX[i] - (strum.ID == 0 || strum.ID == 3 ? mod_spacing * (strum.ID == 0 ? 1 : -1) : 0), 0.4);
                strum.y = FlxMath.lerp(strum.y, allStrumsY[i] - (strum.ID == 1 || strum.ID == 2 ? mod_spacing * (strum.ID == 2 ? 1 : -1) : 0), 0.4);
                strum.notesScale = 0.7;
            }

            if (enableAtom) {
                if (strum.ID == 0) {
                    strum.y = allStrumsY[0] + Math.sin((Conductor.songPosition - startTimer) / 1000 + (Math.PI * 2 / (8 / 4) * (i % 3) * mod_spacing)) * mod_yAmount;
                    strum.x = allStrumsX[0] + Math.cos((Conductor.songPosition - startTimer) / 1000 + (Math.PI * 2 / (8 / 4) * (i % 3) * mod_spacing)) * mod_yAmount * mod_speed;
                    strum.notesScale = 0.8 + Math.sin((Conductor.songPosition - startTimer) / 1000 + (Math.PI * 2 / (8 / 4) * (i % 3) * mod_spacing)) * 0.2;
                } else {
                    strum.y = circlerObjects[(i - 1) % 4].y + Math.sin((Conductor.songPosition - startTimer) / 750 + (Math.PI * 2 / (8 / 4) * ((i - strum.ID) % 3) * mod_spacing)) * mod_xAmount;
                    strum.x = circlerObjects[(i - 1) % 4].x + Math.cos((Conductor.songPosition - startTimer) / 750 + (Math.PI * 2 / (8 / 4) * ((i - strum.ID) % 3) * mod_spacing)) * mod_xAmount * mod_speed;
                    strum.notesScale = 0.6 + Math.sin((Conductor.songPosition - startTimer) / 750 + (Math.PI * 2 / (8 / 4) * ((i - strum.ID) % 3) * mod_spacing)) * 0.2;
                }
            }

            //Default
            strum.x = FlxMath.lerp(strum.x, allStrumsX[i] + FlxG.random.float((curBeat <= 160 || curBeat >= 224 && curBeat <= 352 ? -30 : -20 + (time * (curBeat >= 224 && curBeat <= 415 ? (curBeat <= 352 ? 0.03 : 0.01) : 0.04))), (curBeat <= 160 || curBeat >= 224 && curBeat <= 352 ? 30 : 20 - (time * (curBeat >= 224 && curBeat <= 415 ? (curBeat <= 352 ? 0.03 : 0.01) : 0.04)))) * (time * (curBeat >= 224 && curBeat <= 415 ? (curBeat <= 352 ? 0.03 : 0.01) : 0.04)), 0.2);
            strum.y = FlxMath.lerp(strum.y, allStrumsY[i] + FlxG.random.float((curBeat <= 160 || curBeat >= 224 && curBeat <= 352 ? -30 : -20 + (time * (curBeat >= 224 && curBeat <= 415 ? (curBeat <= 352 ? 0.03 : 0.01) : 0.04))), (curBeat <= 160 || curBeat >= 224 && curBeat <= 352 ? 30 : 20 - (time * (curBeat >= 224 && curBeat <= 415 ? (curBeat <= 352 ? 0.03 : 0.01) : 0.04)))) * (time * (curBeat >= 224 && curBeat <= 415 ? (curBeat <= 352 ? 0.03 : 0.01) : 0.04)), 0.2);
            strum.angle = FlxMath.lerp(strum.angle, allStrumsAngle[i] + FlxG.random.float((curBeat <= 160 || curBeat >= 224 && curBeat <= 352 ? -15 : -2), (curBeat <= 160 || curBeat >= 224 && curBeat <= 352 ? 15 : 2)), 0.2);
            strum.scale.set(FlxMath.lerp(strum.scale.x, 0.7, 0.1), FlxMath.lerp(strum.scale.y, 0.7, 0.1));
            strum.notesScale = FlxMath.lerp(strum.notesScale, 1, 0.1);
            
            i++;
        } 
    } else {
        for (strum in allStrums) {
            strum.x = FlxMath.lerp(strum.x, defaultStrumX[i], 0.2);
            strum.y = FlxMath.lerp(strum.y, defaultStrumY, 0.2);
            strum.angle = FlxMath.lerp(strum.angle, allStrumsAngle[i], 0.2);
            strum.scale.set(FlxMath.lerp(strum.scale.x, 0.7, 0.1), FlxMath.lerp(strum.scale.y, 0.7, 0.1));
            strum.notesScale = FlxMath.lerp(strum.notesScale, 1, 0.1);

            i++;
        }
    }
}

function stepHit(curStep) {
    if (save.data.vs_bamber_modChart[PlayState.SONG.song.toLowerCase()]) {
        if (enableStillStrum && (curStep % 16 == 0 || curStep % 16 == 6 || curStep % 16 == 10)) {
            var i = 0;

            for (strum in allStrums) {
                allStrumsY[i] = defaultStrumY + (curStep % 16 == 0 ? 60 : curStep % 16 == 6 ? 100 : 200) * (engineSettings.downscroll ? 1 : -1);
                strum.y = allStrumsY[i];
                i++;
            }
        }

        if (enableKickBop && (curStep % 16 == 0 || curStep % 16 == 6 || curStep % 16 == 10)) {
            var i = 0;

            for (strum in allStrums) {
                if (curStep % 16 == 0 || curStep % 16 == 10) {
                    strum.y = defaultStrumY + 60 * ((strum.ID == 1 || strum.ID == 2) ? 1 : -0.3) * (engineSettings.downscroll ? 1 : -1);
                    strum.x = defaultStrumX[i];

                    strum.scale.y = 0.7 * 1.2 * ((strum.ID == 1 || strum.ID == 2) ? 1.2 : 0.9);
                    strum.scale.x = 0.7 * 0.8 * ((strum.ID == 1 || strum.ID == 2) ? 0.8 : 1.1);

                    FlxTween.tween(strum.scale, {x:0.7, y:0.7}, 0.2, {ease: FlxEase.quartOut});
                } else {
                    strum.y = defaultStrumY - 18 * ((strum.ID == 1 || strum.ID == 2) ? 1 : 0) * (engineSettings.downscroll ? 1 : -1);
                    strum.x = defaultStrumX[i] - 60 * (strum.ID == 0 ? 1 : strum.ID == 3 ? -1 :0 );

                    strum.scale.y = 0.7 * 0.8 * ((strum.ID == 0 || strum.ID == 3) ? 0.6 : 1.2);
                    strum.scale.x = 0.7 * 1.2 * ((strum.ID == 0 || strum.ID == 3) ? 1.2 : 0.6);

                    FlxTween.tween(strum.scale, {x:0.7, y:0.7}, 0.2, {ease: FlxEase.quartOut});
                }
                i++;
            }
        }
    }
}

var switcher:Bool = false;
function bigboom() {
    if (save.data.vs_bamber_modChart[PlayState.SONG.song.toLowerCase()]) {
        var i:Int = 0;
        for (strum in allStrums) {
            strum.x += FlxG.random.float(-125, 125);
            strum.y += FlxG.random.float(-125, 125);
            strum.angle += FlxG.random.float(-90, 90);
            strum.scale.set((i % 2 == 0 && switcher || i % 2 == 1 && !switcher ? 1. : 0.5), (i % 2 == 0 && switcher || i % 2 == 1 && !switcher ? 1. : 0.5));
            i++;
        }
    }
    switcher = !switcher;
}

function prepareForSpin(loop) {
    if (save.data.vs_bamber_modChart[PlayState.SONG.song.toLowerCase()]) {
        var i:Int = 0;
        switch (loop) {
            case '1':
                for (strum in allStrums) {
                    strum.y = allStrumsY[i] - (120 / 4 * (4 - strum.ID)) * (engineSettings.downscroll ? 1 : -1);
                    strum.scale.set(0.95 - (0.05 * (4 - strum.ID)), 1.05 + (0.05 * (4 - strum.ID)));
                    i++;
                }
            case '2':
                for (strum in allStrums) {
                    strum.y = allStrumsY[i] + (30 * strum.ID) * (engineSettings.downscroll ? 1 : -1);
                    strum.scale.set(0.95 - (0.05 * strum.ID), 1.05 + (0.05 * strum.ID));
                    i++;
                }
            case '3':
                for (strum in allStrums) {
                    strum.y = allStrumsY[i];
                    strum.angle = -20;
                    strum.scale.set(0.5, 1.5);
                    strum.x = guiSize.x - 30 - (10 * (8 - i));
                    allStrumsX[i] = guiSize.x - 100 - (100 * (8 - i));
                    i++;
                }
            case '4':
                for (strum in allStrums) {
                    strum.angle = 20;
                    strum.scale.set(0.5, 1.5);
                    strum.x = 30 + (10 * i);
                    allStrumsX[i] = 40 + (10 * i);

                    FlxTween.tween(strum, {x: guiSize.x / 2 - (20 * (8 - i)), angle: -35}, Conductor.stepCrochet / 500, {ease: FlxEase.circIn, startDelay: Conductor.stepCrochet / 500});
                    FlxTween.tween(strum.scale, {x: 1.4, y: 0.6}, Conductor.stepCrochet / 500, {ease: FlxEase.circIn, startDelay: Conductor.stepCrochet / 500});
                    i++;
                }
        }
    }
}

function tweenVars(vars) {
    var varArray = vars.split(',');

    for (i in 0...varArray.length) {
        if (i % 5 == 4) {
            var variable = varArray[i - 4];
            var newValue = Std.parseFloat(varArray[i - 3]);
            var allowBoom = varArray[i - 2];
            var usedEase = CoolUtil.getEase(varArray[i - 1]);
            var stepAmount = Std.parseFloat(varArray[i]);

            if (allowBoom == 'true') bigboom();
            switch (variable) { //Fuck this, I can't get isolating this to work for some fucking reason
                case 'speed': FlxTween.num(mod_speed, newValue, Conductor.stepCrochet / (250 / stepAmount), {ease: usedEase}, function(value) {mod_speed = value;});
                case 'spacing': FlxTween.num(mod_spacing, newValue, Conductor.stepCrochet / (250 / stepAmount), {ease: usedEase}, function(value) {mod_spacing = value;});
                case 'xAmount': FlxTween.num(mod_xAmount, newValue, Conductor.stepCrochet / (250 / stepAmount), {ease: usedEase}, function(value) {mod_xAmount = value;});
                case 'yAmount': FlxTween.num(mod_yAmount, newValue, Conductor.stepCrochet / (250 / stepAmount), {ease: usedEase}, function(value) {mod_yAmount = value;});
            }
        }
    }
}

function clump() {
    if (save.data.vs_bamber_modChart[PlayState.SONG.song.toLowerCase()]) {
        var i = 0;
        for (strum in allStrums) {
            allStrumsX[i] = guiSize.x / 2 - strum.width / 2;
            allStrumsY[i] = guiSize.y / 2 - strum.height / 2;
            FlxTween.tween(strum, {x: allStrumsX[i], y: allStrumsY[i]}, Conductor.stepCrochet / 250, {ease: FlxEase.quartIn});
            i++;
        }
        bigboom();
    }
}

function switchModchartMovement(selectedMovements:String, allowBoom:String, disableEverything:String) {
    if (allowBoom == 'true') bigboom();
    var movementArray = selectedMovements.split(',');

    //reset every modchart movement variable to their defaults
    if (disableEverything == 'true') {
        enableCircle = false;
        enableYWave = false;
        enableXScroll = false;
        enableYWave = false;
        enableKickBop = false;
        enableStillStrum = false;
        enableSpinAddon = false;
        enableStar = false;
        enableAtom = false;
    }

    startTimer = Conductor.songPosition;

    for (option in 0...movementArray.length) {
        var curOption = movementArray[option];
        var index = 0;

        switch (curOption) {
            case 'static':
                allStrumsX = defaultStrumX.copy();
                for (strum in allStrums) {
                    allStrumsY[index] = defaultStrumY;
                    index++;
                }
            case 'spin3d':
                for (strum in allStrums) {
                    if (save.data.vs_bamber_modChart[PlayState.SONG.song.toLowerCase()]) strum.x = guiSize.x / 2 - strum.width / 2;
                    allStrumsX[index] = strum.x;
                    index++;
                }
                enableCircle = true;
                if (save.data.vs_bamber_modChart[PlayState.SONG.song.toLowerCase()]) PlayState.scripts.executeFunc('changeScrollSpeed', ['set', 'Scroll Speed', 'both', 4, 'quartInOut']);
            case 'spinAddon':
                enableSpinAddon = true;
            case 'YWave':
                enableYWave = true;
            case 'XScroll':
                for (strum in allStrums) {
                    allStrumsX[index] = (guiSize.x + 60) / 8 * index;
                    index++;
                }
                enableXScroll = true;
            case 'kickBop':
                enableKickBop = true;
                if (save.data.vs_bamber_modChart[PlayState.SONG.song.toLowerCase()]) PlayState.scripts.executeFunc('changeScrollSpeed', ['set', 3, 'both', 4, 'quartInOut']);
            case 'stillStrum':
                enableStillStrum = true;
            case 'star':
                enableStar = true;
                for (strum in allStrums) {
                    allStrumsX[index] = guiSize.x / 2 - strum.width / 2 - (strum.ID == 0 || strum.ID == 3 ? (strum.width * 0.6) * (strum.ID == 0 ? 1 : -1) : 0);
                    allStrumsY[index] = guiSize.y / 2 - strum.height / 2 - (strum.ID == 1 || strum.ID == 2 ? (strum.height * 0.6) * (strum.ID == 2 ? 1 : -1) : 0);

                    strum.notesAngle = save.data.vs_bamber_modChart[PlayState.SONG.song.toLowerCase()] ? (switch (strum.ID) {
                        case 0: 270;
                        case 1: 180;
                        case 2: 0;
                        case 3: 90;
                    } + (engineSettings.downscroll ? 0 : 180)) : 0;

                    index++;
                }
            case 'atom':
                enableAtom = true;
                for (strum in allStrums) {
                    strum.notesAngle = 0;
                }
        }
    }
}

function switchModchart(switcher) {
    if (switcher && enableCircle) {
        var index = 0;

        for (strum in allStrums) {
            strum.x = guiSize.x / 2 - strum.width / 2;
            allStrumsX[index] = strum.x;
            index++;
        }
    }

    if (enableStar) {
        for (strum in allStrums) {
            strum.notesAngle = switcher ? (switch (strum.ID) {
                case 0: 270;
                case 1: 180;
                case 2: 0;
                case 3: 90;
            } + (engineSettings.downscroll ? 0 : 180)) : 0;
        }
    }

    if (save.data.vs_bamber_modChart[PlayState.SONG.song.toLowerCase()] && (enableKickBop || enableStillStrum)) PlayState.scripts.executeFunc('changeScrollSpeed', ['set', 3, 'both', 1, 'quartInOut']);
    else PlayState.scripts.executeFunc('changeScrollSpeed', ['set', 'Scroll Speed', 'both', 1, 'quartInOut']);
}