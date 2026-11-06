# 构建数据

- `weapon_art.json`：16 个功能模式图标的预生成几何；构建时转为 MDL GUI 图片，不含字体字形。
- `weapon_presentation.json`：图标来源及绘制规格记录；VG-70 的 AUTO／VOLLEY／TOTAL 为模组自绘弹头组合。
- `flamer_frv.json`：喷火 FRV 的精确网络类型、字段及前座定义。
- `native_sniper.json`：管理器一次性准星任务的校验和修改规格。

武器身份、弹量、热量与换弹状态来自 HD2 Data Hub 0.6.0。模式及射速的补充读取使用从 `src/vendor/narrowhud_weapon_200.lua` 提取的类型、字段和种子，来源及许可见 `third_party/narrowhud200/`；完整旧传感器不会打入运行包。

游戏版本及 PE 指纹见根目录 `version.json`。不包含游戏 DLL 或完整游戏资源。
