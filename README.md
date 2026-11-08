# TikinEngine v1.1.5

一个基于 Friday Night Funkin' Psych Engine 改造的自制引擎，附带自制模组。

## 版本特性

- 兼容新格式谱面（自动展开 {`"song`": {...}} 包装）
- 修复 gfVersion / validScore 缺失导致的 Invalid field 崩溃
- 全面汉化界面
- 自制判定系统
- 按键精准度提示：命中时显示偏早/偏晚多少秒
- 2hot 周末关卡支持（喷漆罐机制）

## 简介

本引擎基于 Psych Engine 开发。Psych Engine 是一个社区驱动的强大 FNF 引擎，支持自定义周目、角色、Lua/HScript 脚本、内置图表编辑器等丰富功能。

TikinEngine 在此基础上进行了深度定制，修复了部分原版问题，并加入了专属的自制模组和玩法。

## 编译与运行

1. 确保安装了最新版的 Haxe（不要用 4.1.5）以及 Haxelib 依赖。
2. 如果需要运行 Lua 脚本，请安装 LuaJIT：
## 许可证

请查看 LICENSE 文件。
