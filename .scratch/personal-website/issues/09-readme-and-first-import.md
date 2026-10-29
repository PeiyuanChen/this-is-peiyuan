# 09: 依赖版本记录（原「README 与首批内容导入验证」，范围缩小）

**What to build:** 记录当前站点使用的运行时与 gem 版本，使多年后换机仍能凭文档重建本地环境。

**范围变更（2026-10-29 作者确认）：** 原票据中的 README 操作手册、域名绑定/COS 切换清单、大批量照片导入验证、仓库体积与国内访问实测、备份等内容全部放弃。操作步骤已沉淀在 `docs/local-development.md`（启动、相册、随感、首页、环境依赖各节），无需另建 README。

**Status:** resolved

- [x] `docs/local-development.md` 新增「环境依赖」节：Ruby 3.3.x / Bundler 2.6.6 / Jekyll 4.4.1 / Minimal Mistakes 4.28.1 / ffmpeg 9.0.1 / exifr 1.5.1 及各 jekyll 插件版本，完整清单指向 Gemfile.lock，并写明换机重建步骤（装 Ruby 3.3.x 与 ffmpeg 后 `bundle install`）

## Answer

2026-10-29 完成，依赖版本表已写入 docs/local-development.md。相册与随感已用真实内容上线（2025、腾格尔沙漠两个相册；随感《开篇》），照片管线在日常添加相册过程中持续得到验证，无需单独的批量导入演练。
