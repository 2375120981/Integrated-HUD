# 集成HUD（Integrated HUD）

当前验证版本：**0.3.9**，潜兵武器 HUD、载具与机甲 HUD 已通过局内验证。武器数字和文字采用 Monocraft。

## 功能

- **武器 HUD**：准星右侧单圆弧显示弹匣余量或热量，配合弹药数字、功能模式图标及射速设置；换弹时自动隐藏，文字采用 Monocraft 字体。
- **FRV／坦克 HUD**：显示载具外形、座位占用和当前血量，突出标记本地玩家座位；FRV 额外显示轮胎状态。
- **机甲 HUD**：统一机甲剪影，显示当前血量，并随血量变化调整颜色。

独立加载，无需 Chef、BSL、FFI 或外部采样器。

## 安装

导入构建生成的 `dist/IntegratedHUD-0.3.9.zip`，选择“集成HUD”并部署。替换时关闭游戏，禁用旧版集成 HUD 及提供相同 DRIVER HUD 核心的冲突包。核对武器界面时也停用 NarrowHUD、HUD+ 等同类 HUD。其他模组是否需要其加载器取决于其各自前置，本模组不需要。

构建目标为 Steam Build **26088801**。若游戏更新导致构建指纹不匹配，应先适配接口，不应删除指纹校验强行打包。新出现的载具尚未完成初次识别时，HUD 可能短暂等待。

## 构建

需要 Python 3.10+ 和本机合法安装的游戏。依赖仅供构建，玩家不需要安装 Python。

```powershell
python -m pip install -r requirements.txt
python tools/build.py --game-root "D:\steam\steamapps\common\Helldivers 2"
```

字体和图标的预生成数据已包含在仓库中。若需重新生成，安装 `fonttools`、`Pillow` 后运行 `python tools/bake_weapon_art.py`；字体源与13个图标 PNG 均已随仓库提供。

也可设置环境变量 `HD2_GAME_ROOT` 后执行 `python tools/build.py`。默认输出到 `dist/`；可用 `--output-dir` 指定目录。构建器不会修改游戏或自动部署。

构建会进行必要的 Lua 5.1 编译、有限座位/血量/退出/绘制缓存模拟、原 boot 保留和包体完整性检查。没有压力测试，不生成 sha256 侧车文件。`VERIFICATION.json` 中的哈希是构建记录。

## 目录

| 目录 | 内容 |
|---|---|
| `src/` | 当前运行源码与必要 DRIVER 原始核心 |
| `layout/` | 载具/机甲与武器圆弧坐标 |
| `data/` | 当前武器传感器数据、字体和图标绘制几何 |
| `assets/` | 运行需要的几何绘制材质 |
| `tools/` | 当前构建器、资源读取与归档/几何工具 |
| `tests/` | 构建使用的必要基本模拟检查 |
| `third_party/` | 必要的第三方版权及许可声明 |

`dist/` 为本地构建输出，不提交仓库。研究报告、可行性分析、参考模组、旧测试包、日志、截图、内存采样器及个人工具环境不在仓库中。

来源及许可范围见 [CREDITS.md](CREDITS.md) 和 [LICENSE.md](LICENSE.md)。
