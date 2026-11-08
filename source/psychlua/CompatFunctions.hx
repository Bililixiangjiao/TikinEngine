package psychlua;

import states.PlayState;

/**
 * 兼容层：补齐 Psych 1.0 里存在、但本引擎（0.7.x 系）没有的 Lua API。
 * 目的是让按 1.0 写的模组脚本不再抛 "attempt to call a nil value"。
 */
class CompatFunctions
{
	public static function implement(funk:FunkinLua)
	{
		// 1.0 的转场贴纸系统，0.7.x 没有对应概念，做成空实现
		funk.addLocalCallback("changeTransStickers", function(?name:String, ?sticker:String):Dynamic {
			return null;
		});

		// 1.0 的相机跟随点
		funk.addLocalCallback("setCameraFollowPoint", function(x:Float, y:Float):Dynamic {
			if(PlayState.instance != null && PlayState.instance.camFollow != null)
				PlayState.instance.camFollow.setPosition(x, y);
			return null;
		});

		// 该构建没启用 DISCORD_ALLOWED，Discord 相关调用一律空实现
		funk.addLocalCallback("changeDiscordClientID", function(id:String):Dynamic {
			return null;
		});
		funk.addLocalCallback("changeDiscordPresence", function(?details:String, ?state:String, ?largeImage:String,
			?largeImageText:String, ?smallImage:String, ?smallImageText:String):Dynamic {
			return null;
		});

		// 1.0 可直接拿 lua 精灵对象；这里返回 null（脚本自身会判空）
		funk.addLocalCallback("getLuaObject", function(tag:String):Dynamic {
			return null;
		});

		// Lua 的 trace() 在 0.7.x 里不存在，映射到控制台
		funk.addLocalCallback("trace", function(v:Dynamic):Dynamic {
			Sys.println(Std.string(v));
			return null;
		});

		// 1.0 提供的 clock()（CPU 时间）
		funk.addLocalCallback("clock", function():Float {
			return Sys.cpuTime();
		});
	}
}
