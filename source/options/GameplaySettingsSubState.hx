package options;

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = Language.tr('Gameplay Settings');
		rpcTitle = 'Gameplay Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('语言 / Language',
			'切换界面语言，返回菜单后生效。\nSwitch the UI language, applies after you go back to the menus.',
			'language',
			'string',
			['中文', 'English']);
		addOption(option);

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option(Language.tr('Downscroll'), //Name
			Language.tr('If checked, notes go Down instead of Up, simple enough.'), //Description
			'downScroll', //Save data variable name
			'bool'); //Variable type
		addOption(option);

		var option:Option = new Option(Language.tr('Middlescroll'),
			Language.tr('If checked, your notes get centered.'),
			'middleScroll',
			'bool');
		addOption(option);

		var option:Option = new Option(Language.tr('Opponent Notes'),
			Language.tr('If unchecked, opponent notes get hidden.'),
			'opponentStrums',
			'bool');
		addOption(option);

		var option:Option = new Option(Language.tr('Ghost Tapping'),
			"开启后，没有可击打的音符时按键不会判定 Miss。",
			'ghostTapping',
			'bool');
		addOption(option);
		
		var option:Option = new Option(Language.tr('Auto Pause'),
			"开启后，窗口失去焦点时自动暂停。",
			'autoPause',
			'bool');
		addOption(option);
		option.onChange = onChangeAutoPause;

		var option:Option = new Option(Language.tr('Disable Reset Button'),
			"开启后按重置键不会生效。",
			'noReset',
			'bool');
		addOption(option);

		var option:Option = new Option(Language.tr('Hitsound Volume'),
			Language.tr('Funny notes does "Tick!" when you hit them.'),
			'hitsoundVolume',
			'percent');
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;

		var option:Option = new Option(Language.tr('Rating Offset'),
			Language.tr('Changes how late/early you have to hit for a "Sick!"
Higher values mean you have to hit later.'),
			'ratingOffset',
			'int');
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		addOption(option);

		var option:Option = new Option(Language.tr('Sick! Hit Window'),
			Language.tr('Changes the amount of time you have
for hitting a "Sick!" in milliseconds.'),
			'sickWindow',
			'int');
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 15;
		option.maxValue = 45;
		addOption(option);

		var option:Option = new Option(Language.tr('Good Hit Window'),
			Language.tr('Changes the amount of time you have
for hitting a "Good" in milliseconds.'),
			'goodWindow',
			'int');
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 15;
		option.maxValue = 90;
		addOption(option);

		var option:Option = new Option(Language.tr('Bad Hit Window'),
			Language.tr('Changes the amount of time you have
for hitting a "Bad" in milliseconds.'),
			'badWindow',
			'int');
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 15;
		option.maxValue = 135;
		addOption(option);

		var option:Option = new Option(Language.tr('Safe Frames'),
			Language.tr('Changes how many frames you have for
hitting a note earlier or late.'),
			'safeFrames',
			'float');
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);

		var option:Option = new Option(Language.tr('Sustains as One Note'),
			"开启后长键漏按就无法再按，且只算一次命中/失误。",
			'guitarHeroSustains',
			'bool');
		addOption(option);

		var option:Option = new Option(Language.tr('Sick'),
			"开启后长键每一小段记 15 次 Sick!，首个箭头无视准度记为 Sick!，加准确度与分数（漏掉不算）。",
			'sick',
			'bool');
		addOption(option);

		super();
	}

	function onChangeHitsoundVolume()
		FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.data.hitsoundVolume);

	function onChangeAutoPause()
		FlxG.autoPause = ClientPrefs.data.autoPause;
}