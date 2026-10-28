# 10: 首页改版：leerob 式短简介 + 相册/随感分区 + 装饰图

**What to build:** 参考 https://leerob.com/ 的首页形态重排首页：大标识之下是短简介（可展开长版），随后「相册」「随感」两个独立区块——相册保留缩略图行，随感为纯文字标题+日期列表；桌面端右侧有一张竖幅装饰图（移动端隐藏）。替代票据 06 的自我介绍长文 + 混合流形态。

**参考决策（与作者确认）：**
- 自我介绍：首页默认短版，`<details>` 展开长版（零 JS）；原文全部保留
- 相册与随感分开两区：相册在上保留缩略图（同 06 样式），随感在下用 leerob Blogs 式纯文字列
- 装饰图先用作者自己的摄影作品（2025 相册封面 IMG01740，竖裁取右侧椰林人物），图片位可随时替换

**Blocked by:** 06（首页混合最新流，本次改版替换其产出）

**Status:** resolved

- [x] 短 bio 文案（起草，作者可改）+ 长版 details 展开
- [x] 相册区：缩略图 + 标题 + 日期，独立区块
- [x] 随感区：纯文字列表，标题左日期右（移动端折行），分隔线
- [x] 桌面端两栏，右侧竖幅装饰图；移动端单栏、装饰图隐藏
- [x] `_plugins/home_feed.rb` 改为提供 `site.home_albums`（随感直接在模板遍历 collection）
- [x] playwright 桌面 1280 / 移动 390 双视口验证

## Answer

本地 `jekyll build` + Playwright（系统 Edge headless）1280 / 390 双视口截图验证，内链全部 200：

- index.md：front matter 的 `title` 置空（主题不再输出页面 H1，浏览器标题回落 site.title），自建两栏结构：左栏 H1「This is Peiyuan」+ 两段短 bio + `<details class="bio-toggle">` 长版（summary 文案用两个 span + CSS 随 open 状态切换「阅读长版/收起」，零 JS）+「相册」「随感」两 section；右栏 `<aside class="home-art">` 装饰图，移动端隐藏
- 短 bio 为起草文案（陈培源 / 服务端近二十年 / 摄影书法皮艺 / 2026 建站），作者可直接改 index.md
- 装饰图用 2025 封面 `assets/photos/2025/medium/IMG01740.jpg`（横图竖裁，`object-position: 68%` 取右侧椰林滩涂人物）；换图只改 index.md 的 src 与 home.scss 的 object-position
- _plugins/home_feed.rb：不再构建合并流，改为 `site.home_albums`（封面 thumb 解析保留，日期倒序）；随感模板内 `site.essays | sort | reverse | limit:6`
- assets/css/home.scss 重写：grid 两栏（620px + 1fr，gap 56px，max-width 1120 居中），相册行沿用 06 缩略图样式去掉「相册」类型标记，随感行为 leerob 式 baseline flex 行；≤900px 单栏隐藏图，≤600px 缩略图缩至 84×56、随感日期折行
- 踩坑：① 主题 single 布局宽屏下 `article.page` 是右浮动固定 936px 宽 + 左 margin + 右 padding 300px（为侧栏预留），需在首页用同特异性选择器重置 float/width/margin/padding，否则右栏塌缩为 0；② 主题宽屏根字号为 22px，尺寸不能用 rem（会放大 37%），统一 px/em；③ chinese.scss 的 `.page__content ul/p/li` 会给首页列表加缩进和行距，首页类选择器需带 `.page__content` 前缀压过
- kramdown 的 `markdown="1"` 属性在嵌套 HTML 块上工作正常，details/section 内的中文段落正常渲染为 `<p>`（构建后检查 HTML 确认）

## 调整记录（2026-10-28，作者反馈）

1. 浏览器标签标题 This is Peiyuan → **Peiyuan**：改 _config.yml 第 1 行 `title`；它同时驱动左上角站名、页脚版权、RSS/sitemap 品牌名，首页大字 H1 在 index.md 不受影响
2. Bio 切换从 `<details>` 改为 leerob 式标签行：大字「Bio」与 Default/Long 同一行，下接浅灰分割线（rgba(0,0,0,.10)），活动标签深色 #2b2b2b 并以 2px 下划线压住分割线。实现为两个隐藏 radio（`#bio-default/#bio-long`）+ CSS 兄弟选择器切换 `.bio-short/.bio-long`，零 JS，键盘可达（focus-visible 有外框提示）
3. 区块顺序：随感在上、相册在下
4. 「全部随感 / 全部摄影」从默认蓝链接弱化为 #9a9a9a（比日期灰 #8a8a8a 稍浅一点）、无下划线、不斜体；hover 只加深到 #6f6f6f
5. 作者同步修改了短 bio 文案（两段）与 H1（This is Peiyuan → Bio），长文个别字句微调，均保留其原文
- Playwright 1280/390 截图验证：tab 切换状态机、区块顺序、弱化链接、移动端均符合预期

## 装饰图的反复（2026-10-28）

- 第一版：2025 相册封面 IMG01740 横图竖裁作右栏装饰
- 第二版：手写原创 SVG（SMIL 动画海滩），作者评估不好看，弃用删除，一度恢复单栏
- 第三版（当前）：作者提供的精细原创 SVG `assets/images/beach.svg`（816×1488 竖式，约 12KB）：渐变天空/海/沙滩 + feTurbulence 颗粒层，三朵云漂移、海面七条波线与碎光、帆船 CSS alternate 往返（34s）并轻微颠簸、三棵椰树树干与叶片分层摇摆（相位错开）、三把橘伞、躺椅小人，含 prefers-reduced-motion 降级。两栏布局恢复，插画 max-width 430px 贴右
- 1280/390 双视口截图验证通过；动画在浏览器中可见（img 引用的 SVG 内联 CSS 动画照常运行）
- 同期：站点 title 由 This is Peiyuan 改为 Peiyuan（见上面调整记录 1）
