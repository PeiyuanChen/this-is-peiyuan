# 02: 「随感」栏目端到端

**What to build:** 作者可以发表一篇完整的随感，朋友可以在手机和电脑上舒适地阅读。随感作为独立栏目存在，有导航入口、按时间（可按年）浏览的列表页、`/essays/:year/:slug/` 永久链接、适合中文长文的排版，文内图片自然混排，文章显示发布日期。

**作者需提供素材：** 2 篇真实短文（现成文字即可，几百到几千字，纯文本/Word 均可，由实施方转成 Markdown），每篇可含 1–3 张配图（如有）。需要 2 篇是为了让首页混合流（票据 06）有真实效果。

**Blocked by:** 01（站点骨架与自动部署管线）

**Status:** resolved

## Answer

提交 1b63ade，两篇随感已上线（Actions 部署，线上页面 200、与本地预览一致）：

- 列表页 https://peiyuanchen.github.io/this-is-peiyuan/essays/ ，按年分组、组内倒序（已用临时 2024 年文章验证多年份分组与排序后删除）
- /essays/2026/two-keats-poems/（济慈诗两首，诗歌保留换行、不做两端对齐）
- /essays/2026/tyrant-leaders-and-corporate-culture/（长文，多级小节）

实现要点：
- essays collection，permalink `/essays/:year/:slug/`；导航「随感」置于「摄影」之前
- 中文衬线排版（assets/css/chinese.scss，经 head/custom.html 挂接，未来笔记共用）：正文 18px/行距 1.9、约 40em 行长、两端对齐、hanging-punctuation 渐进增强；移动端 16.5px
- 修正 new_essay 脚手架：collection 文档 slug 取文件名，故去掉日期前缀、日期入 front matter；new_note 同类问题一并修正（scaffold minitest 同步更新，3 tests / 16 assertions 通过）
- 顺手清理：Jekyll exclude temp/（旧 playwright 环境曾被拷入 _site）；essay-source/ 与 photo-source/ 同等处理，gitignore 不入库
- 唯一未用真实素材验证项：文内图片混排（本次素材无图），样式已就位，留待首张配图文章实际检验


- [x] essays collection 生效，永久链接为 `/essays/:year/:slug/`，slug 为英文/拼音
- [x] 导航出现中文「随感」入口
- [x] 随感列表页按时间倒序、可按年分组
- [x] 中文长文排版：中文字体栈、字号、行距、留白、标点处理得当
- [x] 移动端响应式，长文阅读舒适
- [ ] 文章页显示发布日期，文内图片与文字自然混排（日期已验证；本次素材无配图，混排样式已就位，待首张配图文章实际检验）
- [x] 2 篇真实随感上线，本地预览与线上一致
