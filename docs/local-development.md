# 本地开发

## 启动

在项目根目录 `D:\tasks\personal_site` 打开 PowerShell：

```powershell
bundle exec jekyll serve
```

看到 `Server running...` 即启动成功。修改文件会自动重新构建，刷新浏览器即可看到效果。在终端按 `Ctrl+C` 停止服务。

## 访问

本地地址（baseurl 为空，**没有** `/this-is-peiyuan` 子路径）：

- 首页：<http://127.0.0.1:4000/>
- 摄影：<http://127.0.0.1:4000/photography/>

线上地址带子路径 `/this-is-peiyuan`（GitHub Pages 的 `baseurl`），两者不同属正常现象。
