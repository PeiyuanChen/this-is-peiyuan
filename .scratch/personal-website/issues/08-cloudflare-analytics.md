# 08: Cloudflare 访问统计

**What to build:** 作者能在 Cloudflare 后台看到站点的访问情况（PV、UV、访客地区、设备、来源、热门内容）。统计脚本只在线上生效，本地写作预览不触发、不污染数据。站点编号通过配置项管理，未来替换统计方案只需改配置与模板。

**作者需先完成（仅有人能做的步骤）：** 注册 Cloudflare 账号，添加 site 获得 Web Analytics 的统计编号（无需迁移域名或服务器）。

**Blocked by:** 01（站点骨架与自动部署管线）

**Status:** ready-for-agent

- [ ] Cloudflare beacon 在 JEKYLL_ENV=production 时注入所有页面
- [ ] 本地预览（非 production）不加载统计脚本
- [ ] 统计编号存放在 `_config.yml` 配置项中
- [ ] 作者在 Cloudflare 后台能看到测试访问数据
