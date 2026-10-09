# 01: 站点骨架与自动部署管线

**What to build:** 一个可以访问的线上最小站点。仓库初始化，Jekyll + Bundler 锁定依赖，Minimal Mistakes 以 gem 方式接入，最小配置与占位首页就位；GitHub Actions 从第一次 push 起自动构建并部署到 GitHub Pages。作者以后只需 push，无需手动部署，构建失败能在 Actions 中看到明确原因。

**作者需先完成（仅有人能做的步骤）：** 在 GitHub 网页端创建一个空仓库，将 Pages 的 source 设置为 GitHub Actions；如需推送认证，配置好本机 git 凭据。

**Blocked by:** None (can start immediately)

**Status:** resolved

## Answer

线上地址：https://peiyuanchen.github.io/this-is-peiyuan/ （200，页面与 CSS 正常）。
过程中修复一处问题：Gemfile.lock 最初只有 Windows 平台，CI Linux 上 Setup Ruby 失败，补加 x86_64-linux 平台后部署成功——同时满足"构建失败有清晰报错"验收项。
仓库级配置：http.proxy=127.0.0.1:17891、credential.helper=manager。

- [ ] 仓库 git 初始化，Gemfile 锁定 Jekyll 与 Minimal Mistakes，`bundle install` 成功
- [ ] `bundle exec jekyll s` 本地可启动并打开占位首页（统一通过 bundle exec 调用，绕过 WindowsApps 下失效的 jekyll 占位程序）
- [ ] GitHub Actions workflow 完成 检出 → Ruby → bundle install → jekyll build → 上传 artifact → deploy
- [ ] push 后线上 GitHub Pages URL 能打开该页面
- [ ] 一次故意制造的构建失败能在 Actions 中看到清晰报错
- [ ] 遵循 ADR-0001（Actions 构建，而非 Pages 原生构建）
