package backend;

import haxe.Json;
import lime.utils.Assets;

import backend.Section;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var events:Array<Dynamic>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	@:optional var gfVersion:String;
	var stage:String;

	@:optional var gameOverChar:String;
	@:optional var gameOverSound:String;
	@:optional var gameOverLoop:String;
	@:optional var gameOverEnd:String;
	
	@:optional var disableNoteRGB:Bool;

	@:optional var arrowSkin:String;
	@:optional var splashSkin:String;
	@:optional var validScore:Bool;
	@:optional var player3:String;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var events:Array<Dynamic>;
	public var bpm:Float;
	public var needsVoices:Bool = true;
	public var arrowSkin:String;
	public var splashSkin:String;
	public var gameOverChar:String;
	public var gameOverSound:String;
	public var gameOverLoop:String;
	public var gameOverEnd:String;
	public var disableNoteRGB:Bool = false;
	public var speed:Float = 1;
	public var stage:String;
	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var gfVersion:String = 'gf';
	public var validScore:Bool = true;

	private static function onLoadJson(songJson:Dynamic) // Convert old charts to newest format
	{
		// 图表必须是对象；字符串/数组直接放弃，避免 hxcpp 抛 "Invalid field:xxx"
		if(songJson == null || Type.typeof(songJson) != TObject)
			return;

		// 旧图表用 player3 存 GF，统一迁移到 gfVersion
		if(Reflect.field(songJson, 'gfVersion') == null)
		{
			var player3:Dynamic = Reflect.field(songJson, 'player3');
			var gfName:String = (Std.isOfType(player3, String) && (player3:String).length > 0) ? (player3:String) : 'gf';
			Reflect.setField(songJson, 'gfVersion', gfName);
		}
		if(Reflect.field(songJson, 'player3') != null)
			Reflect.setField(songJson, 'player3', null);

		if(Reflect.field(songJson, 'notes') == null) Reflect.setField(songJson, 'notes', []);
		if(Reflect.field(songJson, 'events') == null) Reflect.setField(songJson, 'events', []);

		var sections:Array<Dynamic> = Reflect.field(songJson, 'notes');
		if(sections == null) return;

		var chartEvents:Array<Dynamic> = Reflect.field(songJson, 'events');
		if(chartEvents == null) chartEvents = [];

		for (secNum in 0...sections.length)
		{
			var sec:Dynamic = sections[secNum];
			if(sec == null || Type.typeof(sec) != TObject)
				continue;

			if(Reflect.field(sec, 'sectionNotes') == null) Reflect.setField(sec, 'sectionNotes', []);
			if(Reflect.field(sec, 'sectionBeats') == null) Reflect.setField(sec, 'sectionBeats', 4);

			var sectionNotes:Array<Dynamic> = Reflect.field(sec, 'sectionNotes');
			if(sectionNotes == null) continue;

			// 旧格式把事件塞在 notes 里（note[1] < 0），这里拆出来
			var i:Int = 0;
			var len:Int = sectionNotes.length;
			while(i < len)
			{
				var note:Array<Dynamic> = sectionNotes[i];
				if(note != null && note.length > 4 && note[1] < 0)
				{
					chartEvents.push([note[0], [[note[2], note[3], note[4]]]]);
					sectionNotes.remove(note);
					len = sectionNotes.length;
				}
				else i++;
			}
		}

		// Psych 1.0 的 psych_v1 图表用绝对阵营编码音符，本引擎是相对 mustHitSection 判断的，
		// 不转换的话对手/玩家的谱面会整体互换。
		var chartFormat:String = Reflect.field(songJson, 'format');
		if(chartFormat != null && StringTools.startsWith(chartFormat, 'psych_v1'))
		{
			convertPsychV1Notes(songJson);
			Reflect.setField(songJson, 'format', 'legacy_converted'); // 不能以 psych_v1 开头，否则会二次转换
		}
	}

	// psych_v1: note[1] 0-3 = 玩家、4-7 = 对手（与 mustHitSection 无关）
	// 旧版编码: note[1] 0-3 = 与 mustHitSection 同侧、4-7 = 另一侧
	private static function convertPsychV1Notes(songJson:Dynamic):Void
	{
		var sections:Array<Dynamic> = Reflect.field(songJson, 'notes');
		if(sections == null) return;

		for (sec in sections)
		{
			if(sec == null || Type.typeof(sec) != TObject) continue;

			var mustHit:Bool = Reflect.field(sec, 'mustHitSection') == true;
			var sectionNotes:Array<Dynamic> = Reflect.field(sec, 'sectionNotes');
			if(sectionNotes == null) continue;

			for (note in sectionNotes)
			{
				if(note == null || note.length < 2) continue;

				var data:Int = Std.int(note[1]);
				if(data < 0) continue; // 事件行（已单独处理）

				var column:Int = data % 4;
				var isPlayerSide:Bool = data < 4;
				note[1] = column + ((isPlayerSide == mustHit) ? 0 : 4);
			}
		}
	}

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		var rawJson = null;
		
		var formattedFolder:String = Paths.formatToSongPath(folder);
		var formattedSong:String = Paths.formatToSongPath(jsonInput);
		#if MODS_ALLOWED
		var moddyFile:String = Paths.modsJson(formattedFolder + '/' + formattedSong);
		if(FileSystem.exists(moddyFile)) {
			rawJson = File.getContent(moddyFile).trim();
		}
		#end

		if(rawJson == null) {
			var path:String = Paths.json(formattedFolder + '/' + formattedSong);

			#if sys
			if(FileSystem.exists(path))
				rawJson = File.getContent(path).trim();
			else
			#end
				rawJson = Assets.getText(Paths.json(formattedFolder + '/' + formattedSong)).trim();
		}

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
			// LOL GOING THROUGH THE BULLSHIT TO CLEAN IDK WHATS STRANGE
		}

		var songJson:Dynamic = parseJSONshit(rawJson);
		if(jsonInput != 'events') StageData.loadDirectory(songJson);
		onLoadJson(songJson);
		return songJson;
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var parsed:Dynamic = Json.parse(rawJson);
		if(parsed == null)
			return null;

		// 新格式: { "song": { ... } }，直接取里层对象
		var inner:Dynamic = Reflect.field(parsed, 'song');
		if(inner != null && Type.typeof(inner) == TObject)
			return cast inner;

		// 旧版扁平格式: JSON 根对象就是歌曲数据，它的 "song" 只是歌名字符串
		return cast parsed;
	}
}
