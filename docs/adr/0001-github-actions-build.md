# 用 GitHub Actions 构建部署，而非 GitHub Pages 原生构建

站点通过 GitHub Actions 执行 `jekyll build` 并发布产物，不使用 Pages 的原生（白名单插件）构建。

原因：摄影板块需要自定义的图片处理与画廊生成逻辑，超出 Pages 官方插件白名单；Actions 构建允许任意插件，且本地 `bundle exec jekyll` 预览与线上完全一致，未来迁出 GitHub（自有服务器/其它平台）时构建流程不变。代价是仓库里需要维护一个 workflow 文件，相对收益可接受。
