# 武器运行数据

- `weapon_narrow.json`：当前构建使用的 NarrowHUD 1.0.5 武器字段、网络类型、学习种子和初次关联映射，依 third_party/narrowhud/LICENSE.txt 使用。
- `weapon_models.json`：重新导入传感器数据时使用的已确认模型映射；运行需要的内容已包含在 weapon_narrow.json。
- `weapon_art.json`：Monocraft 有限字形与13个功能图标的预生成几何。由 tools/bake_weapon_art.py 使用仓库中的字体和 PNG 生成，普通构建直接使用此文件。
- `weapon_presentation.json`：字体、图标尺寸及美术来源记录；原版资源路径不用于运行时查询。

常规构建不需要参考 ZIP 或研究目录。tools/import_narrowhud.py 和 src/narrowhud_sensor_tail.lua 仅用于从合法取得的 NarrowHUD 1.0.5 原始包更新衍生传感器，当前生成结果已随仓库提供。

容量采用类型种子与对象观察校准，膛内弹单独计算；热量结合网络读数与预测纠偏。换弹状态用于隐藏武器 HUD，不计算换弹进度。只使用供弹背包数据，不绘制独立背包界面。

0.3.11：增加最后通牒（36fcbd00）的既有模型事实，用于每0.1秒对右手模型和携带对象进行交叉校验。模型位置无法唯一确认且姿态存在多个候选时隐藏武器 HUD，不根据滚轮次数选择。

0.4.1：增加APW-1（b697955d）的模型映射，用于区分姿态52下的多个网络类型，资源事实来自此前已有映射，不引入旧读取器。
