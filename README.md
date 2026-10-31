# 集成HUD（Integrated HUD）

当前版本：**0.5.4**，用户已确认实机可用。使用 **MDL3 加载和启停**，通过游戏 GameSession 接口读取数据；武器部分基于 NarrowHUD 2.0.0 的读取与学习方案，不依赖 HD2 Data Hub 或 Chef Shared Loader。

## 功能

- **武器 HUD**：准星右侧单圆弧显示弹匣余量或热量；弹匣武器下方显示“弹匣内余量 / 备用弹匣量”，热量武器显示百分比，换弹时隐藏武器 HUD。
- **模式与射速**：圆弧右侧显示解析得到的功能模式及射速设置；内置模式采用随包图标，其余已解析模式回退为文字。不显示半自动／全自动，没有有效数据时不显示占位。
- **背包供弹**：读取独立背包对象的剩余量，结合归属及消耗关联；不额外绘制背包面板。
- **乘员探头**：个人武器 HUD 使用同一读取路径，不因乘坐载具而统一隐藏。
- **FRV／坦克 HUD**：显示载具外形、座位占用和当前血量，标记本地玩家座位；FRV 额外显示轮胎状态。
- **机甲 HUD**：统一整体机甲剪影，显示当前总血量，并随血量变化调整颜色。
- **字体与启停**：数字和文字采用 Monocraft，支持 MDL 实时启停，停用时清理绘制对象与缓存。

武器状态每 0.1 秒整理一次，热量显示在读数之间更新。武器识别综合姿态、携带状态、开火及切枪输入。未知备用量显示“-”；同型武器或背包首次接触可能需要关联学习。圆弧不显示换弹进度。

## 前置与安装

需要 **MDL3**，适配目标为 `3.0.0-dev.21 preview`、Steam Build **26251122**。

MDL3 作者：M!ni$try0fSc!eиce。请前往 [MDL3 官方发布页](https://ayakamods.com/mods/mdl3-preview-%E9%BA%A6%E5%BD%93%E5%8A%B33-%E9%A2%84%E8%A7%88%E7%89%88%EF%BC%81.5710/) 阅读安装说明及条款并下载依赖。本仓库和构建包不附带 MDL3、HD2 Data Hub 或 Chef 加载器。

关闭游戏，停用旧版集成 HUD 和提供重复武器／载具界面的冲突模组，再用支持 MDL 的管理器导入 `IntegratedHUD-MDL-0.5.4.zip` 并部署。保留 MDL3 启用；其他模组需要 HD2 Data Hub 时可继续保留，它不是本模组的前置。首次部署材质后重启游戏。之后可通过 MDL 启停本模组。

本包不覆盖游戏 boot，不调用 FFI，也不需要玩家安装 Python 或外部采样器。

## 构建

需要 Python 3.10+ 和本机合法安装的游戏。Python 及依赖仅用于构建。

```powershell
python -m pip install -r requirements.txt
python tools/build.py --game-root "D:\steam\steamapps\common\Helldivers 2"
```

默认输出到 `dist/`，可使用 `--output-dir` 指定其他目录。构建器核对游戏版本及 PE 指纹，进行 Lua 5.1 编译、有限武器／座位／血量／启停模拟和包体完整性检查；不自动部署，不生成 sha256 侧车文件。`VERIFICATION.json` 中的哈希用于记录构建输入；`runtime_verified=false` 表示构建器自身未运行游戏，不否定用户此前对 0.5.4 的实机确认。

仓库已包含生成后的武器传感器与字体／图标几何，普通构建不需要 NarrowHUD 原始压缩包。重新导入上游源码时，使用合法取得的 NarrowHUD 2.0.0 包运行 `tools/import_narrowhud200.py <压缩包路径>`。重新生成美术数据时，额外安装 `fonttools`、`Pillow` 并运行 `tools/bake_weapon_art.py`。

## 日志与目录

武器日志：`%APPDATA%/Arrowhead/Helldivers2/IntegratedHUD-MDL-0.5.4.log`。

载具日志：同目录的 `driver_hud_lua51.log`；学习缓存为 `IntegratedHUD-Narrow200-learned.txt`，不覆盖原 NarrowHUD 缓存。

`src/`、`layout/`、`data/`、`assets/`、`tools/`、`tests/` 和 `third_party/` 保存当前构建所需源码、布局、资源、检查与许可。旧版代码、参考模组、验证过程记录、日志及本地测试包保存在被 Git 忽略的 `开发记录/` 中，不推送仓库。旧版发布源码可从 Git 历史获取。

## 来源与项目

Based on **NarrowHUD 2.0.0 by luka189**：复用并适配读取、关联学习与武器数据整理模块，未引入原 HUD 绘制或 Chef 加载器。

**DRIVER HUD by FireScallion**：沿用载具纯 Lua 核心与几何材质，构建时接入本项目样式、座位修复和机甲适配。

**Helldivers 2 Mech part HUD**：机甲界面设计参考；当前实现使用本项目统一整体剪影，只显示总血量。

**HD2 HUD+ by DDRK1NG**：圆弧外观参考；字体采用 **Monocraft by Idrees Hassan**。

项目地址：[2375120981/Integrated-HUD](https://github.com/2375120981/Integrated-HUD)。详细归属及许可范围见 [CREDITS.md](CREDITS.md) 和 [LICENSE.md](LICENSE.md)。
