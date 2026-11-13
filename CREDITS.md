# 来源与署名

Integrated HUD 0.8.5：2375120981。加载、启停和全部绘制使用 MDL3；武器身份／弹药／热量／换弹使用 HD2 Data Hub 0.6.0；载具及武器设置保留 GameSession 补充读取。未包含 HD2 Data Hub、MDL 或 Chef 加载器。

- **Based on NarrowHUD 2.0.0 by luka189**，来源 https://github.com/luka189/NarrowHUD 。本版提取武器字段／类型数据、射速种子及模式／射速规则，仅在 Hub 指定槽位与本地携带网络对象唯一关联后补充读取。原姿态／行为关联、开火与切枪识别、弹药整理和热量模型已停用且不打入运行包；历史来源文件仍用于构建元数据。不使用原菜单、布局和 HUD 绘制。完整许可与原始源码哈希见 `third_party/narrowhud200/`。衍生代码必须免费提供、保留署名和许可，不适用 DRIVER 核心的 MIT 许可。
- **DRIVER HUD 1.6 by FireScallion**：`src/vendor/driver_hud_160.lua` 保留原始核心，构建时注入本项目载具布局、机甲关联／绘制、座位修复、坦克发现及既有性能精简，并改为 MDL 管理的回调和 MDL3.gui 绘制；数字改用游戏菜单字体。完整 MIT 许可及第三方范围见 `third_party/driver_hud/`。
- **Helldivers 2 Mech part HUD**：早期机甲界面设计参考。当前机甲展示为本项目统一整体剪影，显示当前总血量。
- **HD2 HUD+ by DDRK1NG**：圆弧外观与环带三角形拼接方案参考；本项目自行实现圆弧，不包含其 FFI、人物、队友或战备模块。旧版本材质沿用 DRIVER HUD 包（本版已不再使用），原贡献者声明保留在 `third_party/driver_hud/CREDITS.txt`，不重新授权。
- **Monocraft by Idrees Hassan**，来源 https://github.com/IdreesInc/Monocraft ，采用 SIL Open Font License 1.1。字体源、许可和固定版本记录保留在 0.7.5 及更早的 Git 历史 `third_party/monocraft/`，历史版本运行时使用有限字形几何；0.8.0 不再打包或使用此字体。
- **Fusion Pixel Font by TakWolf and upstream font authors**：历史延迟面板的中英文字体；0.8.0 不再打包或使用此字体。来源 https://github.com/TakWolf/fusion-pixel-font ，固定 2026.10.25 的 12px proportional zh_hans 版本；SIL OFL 1.1。转换为按需加载的位图字形页，原字体、来源哈希及完整上游许可保留在 0.7.5 及更早的 Git 历史 `third_party/fusion_pixel/`。
- **MDL3 by M!ni$try0fSc!eиce**：单独安装的加载器依赖；HD2 Data Hub 由同一作者开发，为本版武器 HUD 与网络延迟的数据依赖。请前往 [官方发布页](https://ayakamods.com/mods/mdl3-preview-%E9%BA%A6%E5%BD%93%E5%8A%B33-%E9%A2%84%E8%A7%88%E7%89%88%EF%BC%81.5710/) 阅读说明、条款并下载；本仓库不复制或分发 MDL3／Data Hub 组件及代码。

游戏资源、名称、武器图标和接口标识属于各自权利人。本仓库不包含游戏 DLL、原版 boot 或完整游戏资源包。第三方素材不因本项目发布而重新许可。


- **强化图标**：来自本地游戏原生 `content/ui/shared/resources/generated_icons/booster_icons`，构建时保持原始矢量图案与颜色转换为 MDL GUI 图片；图标权利归游戏及其权利人所有。仅分发所需小图标，不附带完整原生资源。

0.9.1 不再分发独立狙击准星工具及其依赖；历史版本的相关署名与完整许可保留在 Git 历史及本地归档中。

- **俄语本地化与语言识别改进 / Russian localization and language detection:** [alishaaryni](https://github.com/alishaaryni)，通过 [PR #2](https://github.com/2375120981/Integrated-HUD/pull/2) 贡献，整合于 0.9.4。
