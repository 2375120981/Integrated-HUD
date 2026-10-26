# Integrated HUD 武器图标与字体

本目录 PNG 为用户要求随包携带的武器功能图标，直接从本机游戏原始资源包 `033fd51c0660afa2` 导出。图标属于 HELLDIVERS 2 的原始游戏资源，不因放入本模组而重新许可。未使用 HUD+ 自制图集。

运行时使用 `data/weapon_art.json` 中预生成的图标覆盖几何和Monocraft 字形几何，经模组已有的纯色三角形材质绘制。无需加载原版功能图标、字体材质，也不调用 Gui.text 或 Gui.bitmap。

Monocraft 由 Idrees Hassan 制作，采用 SIL Open Font License 1.1。构建源字体和来源记录位于 third_party/monocraft；发布包包含许可和来源，运行时只使用有限字形几何。

`tools/bake_weapon_art.py` 可重新生成绘制数据，普通构建无需加载字体文件。
