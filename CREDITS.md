# 来源与署名

0.3.9 武器数字和文字采用 Idrees Hassan 的 Monocraft，来源 https://github.com/IdreesInc/Monocraft，按 SIL Open Font License 1.1 使用；许可和固定版本来源见 third_party/monocraft。运行包仅包含有限字形几何。功能图标仍来自本机游戏资源，HUD+ 仅作圆弧外观参考。

0.3.4 武器数据处理：Based on NarrowHUD by luka189（1.0.5）。采用其武器姿态/行为关联、网络字段数据、弹匣与膛内弹归一化、背包供弹、热量学习/预测校正及模式解码。已裁去原绘制、菜单和独立背包状态 UI，改用本项目独立适配器和单圆弧。完整许可与来源见 `third_party/narrowhud/LICENSE.txt`、`third_party/narrowhud/ORIGIN.json`。其衍生代码必须免费提供、保留署名和许可，不以 DRIVER 核心的 MIT 许可替代。

圆弧几何方案参考用户提供的 DDRK1NG HUD+ 0.1.13 Ring 布局：三角形拼接环带、描边与部分段填充。本项目自行实现几何计算，复用既有 DRIVER 材质及 GUI 生命周期，没有引入 HUD+ 的 FFI、人物、队友、战备界面代码或其整套渲染器。

Integrated HUD 0.3.0 沿用已确认稳定的载具与机甲实现。

- `src/vendor/driver_hud_160.lua`：FireScallion 的 DRIVER HUD 1.6 原始核心。其项目自有代码采用 MIT，版权及完整许可见 `third_party/driver_hud/LICENSE.txt`。
- 本项目在构建时注入最终载具布局、机甲关联/绘制、座位修复、五子对象坦克发现与性能精简逻辑。原始核心文件保持原样，构建器明确校验所有补丁位置。
- `assets/driver_hud`：沿用 DRIVER HUD 随包的几何绘制材质资源。HD2 HUD+（DDRK1NG）及其他原始贡献者的归属与使用声明完整保留在 `third_party/driver_hud/CREDITS.txt`。第三方素材不因本项目发布而重新授权。
- 游戏资源、名称、接口及标识符属于各自权利人。原版 boot 从构建者本机游戏读取，源码仓库不包含游戏 DLL、原版 boot 或完整游戏资源包。
