package objects;

/**
 * 鑳芥樉绀轰腑鏂囩殑鑿滃崟鏂囧瓧鎺т欢锛堟浛浠?Alphabet 浣嶅浘瀛楀簱锛夈€? * 淇濈暀 Alphabet 鐨勮彍鍗曟粴鍔ㄨ涓猴細isMenuItem / targetY / startPosition銆? */
class ChineseText extends FlxText
{
	public var isMenuItem:Bool = false;
	public var targetY:Int = 0;
	public var startPosition:FlxPoint = new FlxPoint(0, 0);
	public var distancePerItem:FlxPoint = new FlxPoint(20, 56);
	public var changeX:Bool = true;
	public var changeY:Bool = true;

	public function new(x:Float, y:Float, text:String = '', size:Int = 32, ?fieldWidth:Float = 0)
	{
		super(x, y, fieldWidth, text, size);
		setFormat(Paths.font('simhei.ttf'), size, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		borderSize = 2.0;
		antialiasing = ClientPrefs.data.antialiasing;
		scrollFactor.set();
		startPosition.set(x, y);
	}

	public function setChineseScale(value:Float):Void
	{
		scale.set(value, value);
		updateHitbox();
	}

	override function update(elapsed:Float):Void
	{
		if (isMenuItem)
		{
			var lerpVal:Float = Math.exp(-elapsed * 9.6);
			if(changeX) x = FlxMath.lerp((targetY * distancePerItem.x) + startPosition.x, x, lerpVal);
			if(changeY) y = FlxMath.lerp((targetY * 1.3 * distancePerItem.y) + startPosition.y, y, lerpVal);
		}
		super.update(elapsed);
	}
}
