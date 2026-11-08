package backend;

/**
 * 界面语言：'中文' / 'English'（存在 ClientPrefs.data.language 里）。
 * 界面上要显示的文本用 Language.tr('English original') 包一层。
 */
class Language
{
	public static inline var ZH:String = '中文';
	public static inline var EN:String = 'English';

	public static var dict:Map<String, String> = [
		'Gameplay Settings' => '游戏设置',
		'Visuals and UI' => '视觉与界面',
		'Graphics' => '画面设置',
		'Options' => '设置',
		'Downscroll' => '下滚',
		'If checked, notes go Down instead of Up, simple enough.' => '开启后音符从上往下落。',
		'Middlescroll' => '中置',
		'If checked, your notes get centered.' => '开启后玩家音符显示在屏幕中央。',
		'Opponent Notes' => '显示对手音符',
		'If unchecked, opponent notes get hidden.' => '关闭后隐藏对手的音符。',
		'Ghost Tapping' => '空敲无伤',
		'If checked, you won\'t get misses from pressing keys
while there are no notes able to be hit.' => '开启后，没有可击打的音符时按键不会判定 Miss。',
		'Auto Pause' => '自动暂停',
		'If checked, the game automatically pauses if the screen isn\'t on focus.' => '开启后，窗口失去焦点时自动暂停。',
		'Disable Reset Button' => '禁用重置键',
		'If checked, pressing Reset won\'t do anything.' => '开启后按重置键不会生效。',
		'Hitsound Volume' => '打击音音量',
		'Funny notes does "Tick!" when you hit them.' => '击中音符时的“哒”声音量。',
		'Rating Offset' => '判定偏移',
		'Changes how late/early you have to hit for a "Sick!"
Higher values mean you have to hit later.' => '调整 Sick! 的判定时机，数值越大越偏晚。',
		'Sick! Hit Window' => 'Sick! 判定窗口',
		'Changes the amount of time you have
for hitting a "Sick!" in milliseconds.' => 'Sick! 判定的时间窗口（毫秒）。',
		'Good Hit Window' => 'Good 判定窗口',
		'Changes the amount of time you have
for hitting a "Good" in milliseconds.' => 'Good 判定的时间窗口（毫秒）。',
		'Bad Hit Window' => 'Bad 判定窗口',
		'Changes the amount of time you have
for hitting a "Bad" in milliseconds.' => 'Bad 判定的时间窗口（毫秒）。',
		'Safe Frames' => '安全帧数',
		'Changes how many frames you have for
hitting a note earlier or late.' => '允许提前或延后击打的帧数。',
		'Sustains as One Note' => '长键视为单音符',
		'If checked, Hold Notes can\'t be pressed if you miss,
and count as a single Hit/Miss.
Uncheck this if you prefer the old Input System.' => '开启后长键漏按就无法再按，且只算一次命中/失误。',
		'Sick' => 'Sick（长键加分）',
		'If checked, every piece of a Hold Note counts as 15 Sick! hits:
the first arrow is always a Sick! (no matter the timing)
and each following piece adds 15x accuracy and score (unless you miss).' => '开启后长键每一小段记 15 次 Sick!，首个箭头无视准度记为 Sick!，加准确度与分数（漏掉不算）。',
		'Note Skins:' => '音符皮肤：',
		'Select your prefered Note skin.' => '选择你喜欢的音符皮肤。',
		'Note Splashes:' => '音符水花：',
		'Select your prefered Note Splash variation or turn it off.' => '选择音符水花样式，或关闭。',
		'Note Splash Opacity' => '音符水花透明度',
		'How much transparent should the Note Splashes be.' => '音符水花的透明程度。',
		'Hide HUD' => '隐藏 HUD',
		'If checked, hides most HUD elements.' => '开启后隐藏大部分界面元素。',
		'Time Bar:' => '时间条：',
		'What should the Time Bar display?' => '时间条显示什么内容？',
		'Flashing Lights' => '闪烁光效',
		'Uncheck this if you\'re sensitive to flashing lights!' => '对闪烁光敏感请关闭此项！',
		'Camera Zooms' => '镜头缩放',
		'If unchecked, the camera won\'t zoom in on a beat hit.' => '关闭后踩点镜头不再放大。',
		'Score Text Zoom on Hit' => '击中分数跳动',
		'If unchecked, disables the Score text zooming
everytime you hit a note.' => '关闭后击中音符时分数文字不再放大。',
		'Health Bar Opacity' => '血条透明度',
		'How much transparent should the health bar and icons be.' => '血条和头像的透明程度。',
		'FPS Counter' => 'FPS 显示',
		'If unchecked, hides FPS Counter.' => '关闭后隐藏帧率显示。',
		'Pause Screen Song:' => '暂停菜单音乐：',
		'What song do you prefer for the Pause Screen?' => '暂停菜单播放哪首音乐？',
		'Check for Updates' => '检查更新',
		'On Release builds, turn this on to check for updates when you start the game.' => '开启后启动游戏时检查更新。',
		'Discord Rich Presence' => 'Discord 状态显示',
		'Uncheck this to prevent accidental leaks, it will hide the Application from your "Playing" box on Discord' => '关闭后不在 Discord 上显示正在游玩。',
		'Combo Stacking' => '连击堆叠',
		'If unchecked, Ratings and Combo won\'t stack, saving on System Memory and making them easier to read' => '关闭后判定与连击不再叠加，更省内存也更好读。',
		'Low Quality' => '低画质',
		'If checked, disables some background details,
decreases loading times and improves performance.' => '开启后关闭部分背景细节，加载更快、性能更好。',
		'Anti-Aliasing' => '抗锯齿',
		'If unchecked, disables anti-aliasing, increases performance
at the cost of sharper visuals.' => '关闭后提升性能，但画面边缘会更锐利。',
		'Shaders' => '着色器',
		'If unchecked, disables shaders.
It\'s used for some visual effects, and also CPU intensive for weaker PCs.' => '关闭后禁用着色器，可减轻低配电脑负担。',
		'GPU Caching' => 'GPU 缓存',
		'If checked, allows the GPU to be used for caching textures, decreasing RAM usage.
Don\'t turn this on if you have a shitty Graphics Card.' => '开启后用 GPU 缓存贴图，降低内存占用。显卡较差请勿开启。',
		'Framerate' => '帧率',
		'Pretty self explanatory, isn\'t it?' => '字面意思，游戏帧率上限。',
		'Note Colors' => '音符颜色',
		'Controls' => '按键设置',
		'Adjust Delay and Combo' => '延迟与连击调整',
	];

	public static var menuDict:Map<String, String> = [
		'story_mode' => '故事模式',
		'freeplay' => '自由模式',
		'credits' => '制作人员',
		'options' => '设置',
		'mods' => '模组',
		'awards' => '成就',
		'donate' => '赞助',
	];

	public static var menuEnglish:Map<String, String> = [
		'story_mode' => 'STORY MODE',
		'freeplay' => 'FREEPLAY',
		'credits' => 'CREDITS',
		'options' => 'OPTIONS',
		'mods' => 'MODS',
		'awards' => 'AWARDS',
		'donate' => 'DONATE',
	];

	public static inline function isEnglish():Bool
		return ClientPrefs.data.language == EN;

	public static function tr(en:String):String
	{
		if(isEnglish()) return en;
		return dict.exists(en) ? dict.get(en) : en;
	}

	public static function menu(key:String):String
	{
		var map:Map<String, String> = isEnglish() ? menuEnglish : menuDict;
		if(map.exists(key)) return map.get(key);
		return isEnglish() ? key.toUpperCase() : (menuDict.exists(key) ? menuDict.get(key) : key);
	}
}
