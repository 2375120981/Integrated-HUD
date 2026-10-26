# 来源与署名

Integrated HUD 0.3.0 沿用已确认稳定的载具与机甲实现。

- `src/vendor/driver_hud_160.lua`：FireScallion 的 DRIVER HUD 1.6 原始核心。其项目自有代码采用 MIT，版权及完整许可见 `third_party/driver_hud/LICENSE.txt`。
- 本项目在构建时注入最终载具布局、机甲关联/绘制、座位修复、五子对象坦克发现与性能精简逻辑。原始核心文件保持原样，构建器明确校验所有补丁位置。
- `assets/driver_hud`：沿用 DRIVER HUD 随包的几何绘制材质资源。HD2 HUD+（DDRK1NG）及其他原始贡献者的归属与使用声明完整保留在 `third_party/driver_hud/CREDITS.txt`。第三方素材不因本项目发布而重新授权。
- 游戏资源、名称、接口及标识符属于各自权利人。原版 boot 从构建者本机游戏读取，源码仓库不包含游戏 DLL、原版 boot 或完整游戏资源包。

本仓库未集成 BAHUD 或其他潜兵武器 HUD 的实现，不包含研究阶段使用的参考模组、采集结果或过程资料。DRIVER 核心和必要材质作为实际构建依赖保留，而不是作为研究附件上传。
