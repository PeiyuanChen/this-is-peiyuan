# 06: 首页混合最新流

**What to build:** 朋友打开网站第一眼看到作者的简短自我介绍，以及按时间混合排列的最新随感与最新相册（相册显示封面缩略图），一眼感知近况。整体保持极简、安静。

**Blocked by:** 02（「随感」栏目）、05（「摄影」栏目与灯箱）

**Status:** resolved

- [x] 首页顶部为简短自我介绍
- [x] 最新随感与最新相册按日期合并、倒序排列
- [x] 相册条目显示封面缩略图，随感条目显示标题与日期
- [x] 点击条目可进入对应文章或相册
- [x] 移动端显示正常，整体极简

## Answer

提交 e7d0d87，首页上线（Actions 部署，本地 playwright 桌面 1400px / 移动 390px 双视口截图验证）：

- index.md 替换"站点建设中"占位：作者自我介绍原文 + 「最新」混合流 + 「全部随感 · 摄影」入口
- _plugins/home_feed.rb：pre_render 钩子构建 site.latest_feed，相册（封面取 album.cover 对应照片的 thumb）与 essays collection 按日期合并倒序，取前 6 条（HomeFeed::LIMIT）；data 文件日期为 Date、collection 文档为 Time，统一转 Time 排序
- assets/css/home.scss：分隔线列表，缩略图 120x80（移动 84x56）；随感无封面，用等宽灰底「随感」占位块保持行首对齐
- 踩坑：chinese.scss 的 .page__content img { margin: 1.6em auto } 在 flex 行内会把封面图推到中间，用 .latest-feed .feed-thumb（双类选择器）置 margin:0 抵消
- 当前真实内容：随感《开篇》、腾格尔沙漠、二〇二五，三条合并倒序正确
