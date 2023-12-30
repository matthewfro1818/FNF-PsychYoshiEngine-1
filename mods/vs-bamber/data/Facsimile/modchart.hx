//still not a modchart lmfao
import flixel.addons.util.FlxSimplex;
function updatePost60(elapsed) {
	FlxG.camera.angle += 5 * 0.5 * FlxSimplex.simplex(Conductor.songPosition/1000 * 25.5, Conductor.songPosition/1000 * 25.5);
	FlxG.camera.scroll.x += 50 * 0.04 * FlxSimplex.simplex(Conductor.songPosition/1000 * 100, 10);
	FlxG.camera.scroll.y += 50 * 0.04 * FlxSimplex.simplex(10, Conductor.songPosition/1000 * 100);
}