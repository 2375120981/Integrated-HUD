# 武器绘制数据

- `weapon_art.json`：Monocraft 有限字形与13个功能图标的预生成几何。普通构建直接读取。
- `weapon_presentation.json`：重新生成美术数据时使用的图标来源及绘制规格；原版资源路径不用于运行时查询。

NarrowHUD 2.0.0 的武器字段、网络类型及学习种子包含在生成后的 `src/vendor/narrowhud_weapon_200.lua` 中；来源及许可见 `third_party/narrowhud200/`。`tools/import_narrowhud200.py` 从合法取得的原始包重新生成传感器，普通构建无需原始 ZIP。

读取模块结合对象观察与学习整理弹匣、膛内弹、背包供弹、热量及功能模式。构建所需游戏版本和 PE 指纹统一保存在根目录 `version.json`。不依赖 HD2Data 字段或旧版手部模型映射。
