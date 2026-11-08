# TikinEngine v1.1.4

一个基于 FNF (Friday Night Funkin') Psych Engine 改造的自制引擎，附带自制模组。

## 版本特性 (v1.1.4)

* 兼容新格式谱面
* gfVersion 容错修复
* 全面汉化界面
* 自制判定系统

## 简介

本引擎基于 Psych Engine 开发。Psych Engine 是一个社区驱动的强大 FNF 引擎，支持自定义周目、角色、Lua/HScript 脚本、内置图表编辑器等丰富功能[1,2](@ref)。

TikinEngine 在此基础上进行了深度定制，修复了部分原版问题，并加入了专属的自制模组和玩法。

## 编译与运行

1. 确保安装了最新版的 Haxe (不要用 4.1.5) 以及 Haxelib 依赖[7](@ref)。
2. 如果需要运行 Lua 脚本，请安装 LuaJIT[7](@ref)：
\\\\ash
haxelib git linc\_luajit https://github.com/AndreiRudenko/linc\_luajit
\\\\
3. 在项目根目录运行：
\\\\ash
lime test windows
\\\\

## 许可证

请查看 LICENSE 文件。

