package states;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import backend.Paths;
import backend.CoolUtil;
import backend.Highscore;
import ReplayUtil;

class ReplaySaveSubstate extends FlxSubState
{
public static var decided:Bool = false;
public static var acc:Float = 0.0;
public static var misses:Int = 0;
public static var maxCombo:Int = 0;
public static var scr:Int = 0;
public static var songName:String = '';
public static var diff:Int = 1;

var done:Bool = false;
var cam:FlxCamera;

public function new()
{
super();
}

function pickCam():FlxCamera
{
var list:Array<FlxCamera> = FlxG.cameras.list;
var i:Int = list.length - 1;
while (i >= 0)
{
var c:FlxCamera = list[i];
if (c != null && Math.abs(c.zoom - 1) < 0.001) return c;
i--;
}
return FlxG.camera;
}

function addUI(o:FlxSprite):Void
{
o.cameras = [cam];
o.scrollFactor.set(0, 0);
add(o);
}

override function create()
{
super.create();
cam = pickCam();

var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(cam.width), Std.int(cam.height), FlxColor.BLACK);
bg.alpha = 0.92;
addUI(bg);

var W:Float = cam.width;
var H:Float = cam.height;
var fnt = Paths.font('pixel.otf');

var title:FlxText = new FlxText(0, H * 0.07, W, 'SONG CLEARED');
title.setFormat(fnt, 52, FlxColor.WHITE, 'center');
addUI(title);

var line:FlxSprite = new FlxSprite(W * 0.10, H * 0.20);
line.makeGraphic(Std.int(W * 0.80), 3, FlxColor.WHITE);
addUI(line);

var ly:Float = H * 0.28;
var gap:Float = H * 0.085;
var lx:Float = W * 0.10;
var leftArr:Array<String> = [
'ACCURACY    ' + CoolUtil.floorDecimal(acc * 100, 2) + '%',
'MISSES      ' + misses,
'MAX COMBO   ' + maxCombo,
'SCORE       ' + scr
];
for (i in 0...leftArr.length)
{
var t:FlxText = new FlxText(lx, ly + gap * i, Std.int(W * 0.42), leftArr[i]);
t.setFormat(fnt, 30, FlxColor.WHITE, 'left');
addUI(t);
}

var bestScore:Int = 0;
var bestAcc:Float = 0.0;
try { bestScore = Highscore.getScore(songName, diff); } catch (e:Dynamic) {}
try { bestAcc = Highscore.getRating(songName, diff); } catch (e:Dynamic) {}

var dScore:Int = scr - bestScore;
var dAcc:Float = (acc - bestAcc) * 100;
var rightArr:Array<String> = [
'BEST SCORE   ' + bestScore,
'BEST ACC     ' + CoolUtil.floorDecimal(bestAcc * 100, 2) + '%',
'DELTA SCORE  ' + (dScore >= 0 ? '+' : '') + dScore,
'DELTA ACC    ' + (dAcc >= 0 ? '+' : '') + CoolUtil.floorDecimal(dAcc, 2) + '%'
];
for (i in 0...rightArr.length)
{
var t:FlxText = new FlxText(Std.int(W * 0.48), ly + gap * i, Std.int(W * 0.42), rightArr[i]);
t.setFormat(fnt, 30, 0xFF9AD0FF, 'right');
addUI(t);
}

var by:Float = H * 0.80;
var bw:Float = 340;
var bh:Float = 84;
var cx:Float = W / 2;

var s1:FlxSprite = new FlxSprite(cx - bw - 30, by);
s1.makeGraphic(Std.int(bw), Std.int(bh), 0x33FFFFFF);
addUI(s1);
var t1:FlxText = new FlxText(cx - bw - 30, by + 26, Std.int(bw), '[F6] SAVE');
t1.setFormat(fnt, 30, FlxColor.WHITE, 'center');
addUI(t1);

var s2:FlxSprite = new FlxSprite(cx + 30, by);
s2.makeGraphic(Std.int(bw), Std.int(bh), 0x33FFFFFF);
addUI(s2);
var t2:FlxText = new FlxText(cx + 30, by + 26, Std.int(bw), '[F7] NO SAVE');
t2.setFormat(fnt, 30, FlxColor.WHITE, 'center');
addUI(t2);
}

override function update(elapsed:Float)
{
super.update(elapsed);
if (done) return;
if (FlxG.keys.justPressed.F6) { done = true; doSave(); }
else if (FlxG.keys.justPressed.F7) { done = true; doNoSave(); }
}

function doSave()
{
if (PlayState.replayData != null && PlayState.replayData.length > 0)
ReplayUtil.save(songName, diff, PlayState.replayData);
PlayState.replayData = null;
decided = true;
close();
var p:PlayState = cast _parentState;
new FlxTimer().start(0.1, function(_) { if (p != null) p.endSong(); });
}

function doNoSave()
{
PlayState.replayData = null;
decided = true;
close();
var p:PlayState = cast _parentState;
new FlxTimer().start(0.1, function(_) { if (p != null) p.endSong(); });
}
}