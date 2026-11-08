package substates;

/**
 * 启动公告：加载 images/g.png，按 ESC 或 6 秒后自动关闭。
 * 用 Substate 实现，天然盖在标题画面之上，也不会阻断标题的更新。
 */
class AnnouncementSubstate extends MusicBeatSubstate
{
	var spr:FlxSprite;
	var timer:FlxTimer;
	var closing:Bool = false;

	public function new()
	{
		super();
	}

	override function create():Void
	{
		super.create();

		if(!Paths.fileExists('images/g.png', IMAGE))
		{
			dismiss();
			return;
		}

		spr = new FlxSprite().loadGraphic(Paths.image('g'));
		var fit:Float = Math.min(FlxG.width / spr.width, FlxG.height / spr.height);
		spr.setGraphicSize(Std.int(spr.width * fit), Std.int(spr.height * fit));
		spr.updateHitbox();
		spr.screenCenter();
		spr.scrollFactor.set();
		spr.antialiasing = ClientPrefs.data.antialiasing;
		spr.alpha = 0;
		add(spr);

		FlxTween.tween(spr, {alpha: 1}, 0.25, {ease: FlxEase.quadOut});
		timer = new FlxTimer().start(6, function(tmr:FlxTimer) dismiss());
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if(controls.BACK || FlxG.keys.justPressed.ESCAPE)
			dismiss();
	}

	function dismiss():Void
	{
		if(closing) return;
		closing = true;

		if(timer != null)
		{
			timer.cancel();
			timer = null;
		}

		var s:FlxSprite = spr;
		spr = null;
		if(s != null)
			FlxTween.tween(s, {alpha: 0}, 0.2, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween) {
				if(s != null) s.visible = false;
			}});

		closeSubState();
	}
}
