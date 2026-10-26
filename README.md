# 集成HUD（Integrated HUD）

当前版本：**0.3.0**。独立加载的《HELLDIVERS 2》载具和机甲 HUD，基于已验证的 0.2.16 实现定版，版本升级不增加功能。

## 功能

- FRV：车体、轮胎状态、四个座位及当前血量；本地座位橙色，其他占座灰白。
- 坦克：车体与履带、四个座位及当前血量；支持五子对象坦克首次炮手位进入。
- 机甲：所有型号共用整体剪影、视觉分割线和放大的当前血量整数，整体按血量比例变色；不显示百分比、上限、弹药或模块血量。
- 保留快速候选确认、下车隐藏、补给 FRV 后座映射修复及读取/日志性能优化。

本版仅包含载具与机甲 HUD，不含潜兵武器 HUD。无需 BSL、Chef、FFI 或外部采样器。

## 安装

导入构建生成的 `dist/IntegratedHUD-0.3.0.zip`，选择“集成HUD”并部署。替换时关闭游戏，禁用旧版集成 HUD 及提供相同 DRIVER HUD 核心的冲突包。

构建目标为 Steam Build **26088801**。若游戏更新导致构建指纹不匹配，应先适配接口，不应删除指纹校验强行打包。新出现的载具尚未完成初次识别时，HUD 可能短暂等待。

## 构建

需要 Python 3.10+ 和本机合法安装的游戏。依赖仅供构建，玩家不需要安装 Python。

```powershell
python -m pip install -r requirements.txt
python tools/build.py --game-root "D:\steam\steamapps\common\Helldivers 2"
```

也可设置环境变量 `HD2_GAME_ROOT` 后执行 `python tools/build.py`。默认输出到 `dist/`；可用 `--output-dir` 指定目录。构建器不会修改游戏或自动部署。

构建会进行必要的 Lua 5.1 编译、有限座位/血量/退出/绘制缓存模拟、原 boot 保留和包体完整性检查。没有压力测试，不生成 sha256 侧车文件。`VERIFICATION.json` 中的哈希是构建记录。

## 目录

| 目录 | 内容 |
|---|---|
| `src/` | 当前运行源码与必要 DRIVER 原始核心 |
| `layout/` | 构建使用的最终坦克/机甲坐标 |
| `assets/` | 运行需要的几何绘制材质 |
| `tools/` | 当前构建器、资源读取与归档/几何工具 |
| `tests/` | 构建使用的必要基本模拟检查 |
| `third_party/` | 必要的第三方版权及许可声明 |

`dist/` 为本地构建输出，不提交仓库。研究报告、可行性分析、参考模组、旧测试包、日志、截图、内存采样器及个人工具环境不在仓库中。

来源及许可范围见 [CREDITS.md](CREDITS.md) 和 [LICENSE.md](LICENSE.md)。
