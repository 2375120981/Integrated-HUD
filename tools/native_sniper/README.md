# 原生狙击准星交互切换工具 v0.2.0

独立工具，用于离线定位并切换 APW-1、R-40、AMW-20 的原生第三人称准星。不需要 MDL、Hub 或安装 Python。不会修改 Integrated HUD 的局内 HUD 功能。

## 使用

1. 退出游戏，等待 Steam 更新／验证完成。关闭旧版准星启动安装器，避免它下次启动时重新应用相反设置。
2. 将 ZIP 完整解压到游戏目录以外，双击 `IntegratedHUD-NativeSniper-Toggle.exe`。
3. 工具自动查找游戏，定位三个准星字段，并逐一显示状态。
4. 全部未启用时询问是否启用；全部已启用时询问是否禁用。输入 `YES` 才继续，其他输入取消。状态混合、未知或定位不完整时不自动修改。
5. 候选文件通过结构、内部校验与加密认证检查后才写入。显示 `SUCCESS` 后，下次启动游戏生效。

读取字段值 0 表示目标准星类型，3 表示原来的狙击类型；其他值不会覆盖。字段状态不能证明游戏画面已经生效，仍需启动游戏验证。

## 备份与恢复

写入前会把原始完整文件保存在：

`游戏目录/data/game/IntegratedHUD-NativeSniper-Backups/`

备份名为原文件 SHA256 加 `.dl_bin`，旁边 JSON 记录切换前后摘要及事务状态。不要删除备份，直到确定无需恢复。

禁用时，若当前文件与本工具一次启用结果完全相符，优先精确恢复那次备份。否则会尝试按同一结构路线把三个准星字段恢复为 3，并重建校验；这种恢复保证目标字段还原，不保证整个文件与原厂文件逐字节相同。兼容性检查失败会停止。

候选文件先写入游戏数据目录内的临时文件，确认输入未发生改变后再原子替换。异常退出时检查报告与备份；若报告显示写入发生但未成功校验，请先退出游戏，根据对应 JSON 的 `backup` 路径将备份复制回 `generated_entities.dl_bin`，或让 Steam 验证游戏完整性。恢复前应确认不会覆盖后来安装的其他数据修改。

## 兼容性与限制

不再用固定文件长度、固定偏移或已知文件 SHA256 作为定位条件。通过匹配的 DL 类型库、武器资源索引和字段类型定位，再检查游戏 DLL 是否认可源数据的内部校验值。仅修改三个准星枚举及用于重建内部校验的保留块头字节，不修改 DLL。

仍不是任意版本通用修改器：加密配置、类型格式、块结构、对齐或校验方式变化会导致拒绝。其他客户端那份相差 12 字节的数据目前没有原文件供测试，不能保证可写；请在对应客户端运行后提供报告。

报告存放在工具旁 `reports/时间戳/`。只需分享 `SniperToggle.json` 和 `结果说明.txt`，不要上传备份、游戏 DLL 或游戏数据。包内不包含游戏数据，不产生 `.sha256` 文件。

## 源码与依赖

`source/` 包含 Python 源码、离线解码配置，以及校验求解器 C++ 源码与独立可执行文件。PyNaCl/libsodium、cffi、Python、PyInstaller 的许可证见 `licenses/`。字段定义参考：

- https://github.com/xypwn/filediver/blob/master/datalibrary/weapon_data_component.go
- https://github.com/xypwn/filediver/blob/master/datalibrary/enum/crosshair_weapon_type.go

离线容器解码参考用户提供的 SHODAN Stat Editor Offline。此工具随 Integrated HUD 发布包独立提供；离线解码配置不进入 HUD Lua 模块。

源码运行需 Python 3.10+ 和 PyNaCl；同目录保留 `solve.exe`：

```powershell
python sniper_toggle.py --game-root "D:\steam\steamapps\common\Helldivers 2"
```

可用 `--inspect-only` 仅检查而不询问切换；`--output-dir` 指定尚不存在且不在游戏目录内的报告目录；`--no-pause` 取消结束等待。不提供跳过确认或强制覆盖参数。
