# 来源与署名

Integrated HUD 0.5.4：2375120981。加载和启停交给 MDL3，数据通过 GameSession 读取；未包含 HD2 Data Hub 或 Chef 加载器。

- **Based on NarrowHUD 2.0.0 by luka189**，来源 https://github.com/luka189/NarrowHUD 。提取并适配武器字段数据、学习种子、对象归属、姿态／行为关联、弹匣与膛内弹整理、背包供弹、热量模型及模式／射速解析。读取模块由自有 MDL 适配器驱动，不使用原菜单、布局和 HUD 绘制。完整许可与原始源码哈希见 `third_party/narrowhud200/`。衍生代码必须免费提供、保留署名和许可，不适用 DRIVER 核心的 MIT 许可。
- **DRIVER HUD 1.6 by FireScallion**：`src/vendor/driver_hud_160.lua` 保留原始核心，构建时注入本项目载具布局、机甲关联／绘制、座位修复、坦克发现及既有性能精简，并改为 MDL 管理的回调。完整 MIT 许可及第三方范围见 `third_party/driver_hud/`。
- **Helldivers 2 Mech part HUD**：早期机甲界面设计参考。当前机甲展示为本项目统一整体剪影，显示当前总血量。
- **HD2 HUD+ by DDRK1NG**：圆弧外观与环带三角形拼接方案参考；本项目自行实现圆弧，不包含其 FFI、人物、队友或战备模块。`assets/driver_hud` 材质沿用 DRIVER HUD 包，原贡献者声明保留在 `third_party/driver_hud/CREDITS.txt`，不重新授权。
- **Monocraft by Idrees Hassan**，来源 https://github.com/IdreesInc/Monocraft ，采用 SIL Open Font License 1.1。字体源、许可和固定版本记录见 `third_party/monocraft/`，运行时使用有限字形几何。
- **MDL3 by M!ni$try0fSc!eиce**：单独安装的加载器依赖。请前往 [官方发布页](https://ayakamods.com/mods/mdl3-preview-%E9%BA%A6%E5%BD%93%E5%8A%B33-%E9%A2%84%E8%A7%88%E7%89%88%EF%BC%81.5710/) 阅读说明、条款并下载；本仓库不复制或分发 MDL3／Data Hub 组件及代码。

游戏资源、名称、武器图标和接口标识属于各自权利人。本仓库不包含游戏 DLL、原版 boot 或完整游戏资源包。第三方素材不因本项目发布而重新许可。
