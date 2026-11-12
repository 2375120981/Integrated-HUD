# 本地化翻译 / Localization

每种语言对应一个 UTF-8 JSON 文件。`name` 为语言本地名称，`strings` 为固定键名对应的翻译。

以 `en.json` 为模板，复制为语言代码文件，例如 `ja.json`。只翻译文字，保持键名不变；缺失项回退英文。不要添加重复键、空字符串或代码。新增语言文件后需重新构建模组，再通过 PR 合并。

设置提供“跟随 MDL / 简体中文 / English”。跟随模式优先读取 MDL 的界面语言；中文暂使用简体文案，其他未提供的语言回退英文。语言选项值、功能开关 ID 和强化显示内部值不随翻译改变。

首次升级到动态菜单文案后请重启游戏一次。之后切换语言无需重新注册设置。独立准星工具和管理器安装选项不使用此运行时语言设置。

Each UTF-8 JSON file contains a native language `name` and a `strings` dictionary. Copy `en.json` to a language-code filename, translate values only, and submit a PR. Missing entries fall back to English. Duplicate keys, empty strings and unknown keys fail the build.
