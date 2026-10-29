# 绑定自定义域名 peiyuan.me，托管仍留在 GitHub Pages

站点对外使用自定义域名 peiyuan.me，托管与构建方式不变（GitHub Pages + Actions，见 ADR-0001）。自定义域名让网址独立于托管平台：未来若迁出 GitHub，读者手中的链接与已发布的文章地址不变；站点同时从 project 子路径改为根路径服务，`baseurl` 置空，本地与线上地址结构一致。

配置要点：

- DNS 托管在阿里云万网（NS：dns9/dns10.hichina.com）。apex 用四条 A 记录指向 GitHub Pages（185.199.108-111.153），www 用 CNAME 指向 peiyuanchen.github.io；GitHub Pages 后台绑定自定义域并开启 Enforce HTTPS。
- 仓库根目录的 `CNAME` 文件（内容一行 `peiyuan.me`）是 Pages 识别自定义域的依据，Jekyll 构建时原样拷入站点产物，切勿删除或改名。
- `_config.yml` 的 `url` 为 `https://peiyuan.me`，供 sitemap 与手写 feed.xml 生成绝对链接；工作流构建显式传 `--baseurl ""`，不使用 configure-pages 对 project 仓库推断的子路径。

旧地址 `https://peiyuanchen.github.io/this-is-peiyuan/*` 由 GitHub 自动 301 到新域名同路径（2026-10-29 验证，含 `/essays/` 等深层链接），满足 spec 中「旧链接不失效」的要求；www 与 http 同样 301 到 https apex。该自动跳转依赖仓库仍由 GitHub Pages 提供服务——未来迁出时须在新平台自行接管这些跳转。代价是多了一项长期运维：域名按时续费（注意阿里云账户的到期与续费方式），换托管平台时 DNS 记录与 `CNAME` 文件要一起改。
