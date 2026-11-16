package states;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import backend.Paths;
import backend.Highscore;
import backend.Song;
import ReplayUtil;

class ReplaySelectSubstate extends FlxSubState
{
var songName:String;
var diff:Int;
var files:Array<String> = [];
var texts:Array<FlxText> = [];
var cur:Int = 0;
var scroll:Int = 0;
var rowH:Float = 54;
var listTop:Float = 0;
var maxRows:Int = 1;
var cam:FlxCamera;
var W:Float = 0;
var H:Float = 0;

// 硬边沿状态：必须“松开过”才允许下次触发
var upArmed:Bool = true;
var downArmed:Bool = true;
var enterArmed:Bool = true;
var escArmed:Bool = true;
var lockFrames:Int = 3;

public function new(song:String, d:Int)
{
super();
songName = song;
diff = d;
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
trace("ReplaySelectSubstate v5 硬边沿");

// 打开瞬间把所有键当成“未按”，防止父状态穿透
upArmed = true;
downArmed = true;
enterArmed = true;
escArmed = true;
lockFrames = 3;

cam = pickCam();
W = cam.width;
H = cam.height;
FlxG.mouse.visible = true;
files = ReplayUtil.list(songName, diff);

var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(W), Std.int(H), FlxColor.BLACK);
bg.alpha = 0.96;
addUI(bg);

var fnt = Paths.font("vcr.ttf");

var title:FlxText = new FlxText(0, H * 0.07, W, "SELECT WARP  (" + files.length + ")  v5");
title.setFormat(fnt, 40, FlxColor.WHITE, "center");
addUI(title);

var line:FlxSprite = new FlxSprite(W * 0.10, H * 0.19);
line.makeGraphic(Std.int(W * 0.80), 3, FlxColor.WHITE);
addUI(line);

if (files.length == 0)
{
var t:FlxText = new FlxText(0, H * 0.42, W, "NULL REPLAY");
t.setFormat(fnt, 56, 0xFFAAAAAA, "center");
addUI(t);

var h:FlxText = new FlxText(0, H * 0.60, W, "THIS SONG HAS NO SAVED WARP");
h.setFormat(fnt, 24, 0xFF666666, "center");
addUI(h);

var b:FlxText = new FlxText(0, H * 0.84, W, "[ESC] BACK");
b.setFormat(fnt, 24, 0xFF888888, "center");
addUI(b);
return;
}

listTop = H * 0.26;
var listBottom:Float = H * 0.86;
maxRows = Std.int((listBottom - listTop) / rowH);
if (maxRows < 1) maxRows = 1;

for (i in 0...files.length)
{
var t:FlxText = new FlxText(0, listTop, W, ReplayUtil.displayName(files[i]));
t.setFormat(fnt, 30, 0xFF888888, "center");
addUI(t);
texts.push(t);
}
refresh();

var hint:FlxText = new FlxText(0, H * 0.90, W, "[UP/DOWN/SCROLL] SELECT    [ENTER/CLICK] PLAY    [ESC] BACK");
hint.setFormat(fnt, 20, 0xFF888888, "center");
addUI(hint);
}

override function destroy()
{
FlxG.mouse.visible = false;
super.destroy();
}

function refresh()
{
if (texts.length == 0) return;

if (cur < 0) cur = texts.length - 1;
if (cur >= texts.length) cur = 0;

var maxScroll:Int = Std.int(Math.max(0, texts.length - maxRows));
if (cur < scroll) scroll = cur;
if (cur >= scroll + maxRows) scroll = cur - maxRows + 1;
if (scroll < 0) scroll = 0;
if (scroll > maxScroll) scroll = maxScroll;

for (i in 0...texts.length)
{
var vis:Bool = (i >= scroll && i < scroll + maxRows);
texts[i].visible = vis;
if (vis) texts[i].y = listTop + rowH * (i - scroll);
if (i == cur)
{
texts[i].color = 0xFFFFFFFF;
texts[i].alpha = 1;
}
else
{
texts[i].color = 0xFF888888;
texts[i].alpha = 0.7;
}
}
}

override function update(elapsed:Float):Void
{
super.update(elapsed);

// 锁帧：前 3 帧完全不读键盘，吃掉系统重复事件
if (lockFrames > 0)
{
lockFrames--;
return;
}

if (_parentState != null) _parentState.persistentUpdate = false;

var upDown:Bool = FlxG.keys.pressed.UP || FlxG.keys.pressed.W;
var dnDown:Bool = FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S;
var enDown:Bool = FlxG.keys.pressed.ENTER;
var esDown:Bool = FlxG.keys.pressed.ESCAPE;

// 鼠标悬停高亮
for (i in 0...texts.length)
{
if (texts[i].visible && FlxG.mouse.overlaps(texts[i], cam) && cur != i)
{
cur = i;
refresh();
}
}

if (FlxG.mouse.justPressed)
{
for (i in 0...texts.length)
{
if (texts[i].visible && FlxG.mouse.overlaps(texts[i], cam))
{
cur = i;
refresh();
startReplay(files[cur]);
return;
}
}
}

if (FlxG.mouse.wheel != 0)
{
cur += (FlxG.mouse.wheel < 0 ? 1 : -1);
refresh();
}

// ===== 硬边沿：必须“先松开再按下”才触发一次 =====
// 向上
if (!upDown)
{
upArmed = true; // 键松开了，重新武装
}
else if (upDown && upArmed)
{
upArmed = false; // 消费这一次按下
cur--;
refresh();
}

// 向下
if (!dnDown)
{
downArmed = true;
}
else if (dnDown && downArmed)
{
downArmed = false;
cur++;
refresh();
}

// 回车
if (!enDown)
{
enterArmed = true;
}
else if (enDown && enterArmed)
{
enterArmed = false;
startReplay(files[cur]);
return;
}

// ESC
if (!esDown)
{
escArmed = true;
}
else if (esDown && escArmed)
{
escArmed = false;
close();
}
}

function startReplay(file:String)
{
if (file == null || file.length == 0) return;
PlayState.replayFileName = file;
PlayState.replayMode = true;
PlayState.storyDifficulty = diff;
var poop:String = Highscore.formatSong(songName, diff);
PlayState.SONG = Song.loadFromJson(poop, songName);
PlayState.isStoryMode = false;
LoadingState.loadAndSwitchState(new PlayState());
}
}