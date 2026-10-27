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

## 添加相册

相册由工具链自动生成：原片放在 `photo-source/`，构建后生成多档图片（`assets/photos/`）和相册数据（`_data/albums/`），页面由 Jekyll 自动生成。

在项目根目录执行：

### 1. 创建相册脚手架

```powershell
ruby tools/photos/bin/new_album <slug>
```

例如 `ruby tools/photos/bin/new_album winter-202701`。会生成：

- `photo-source/<slug>/album.yml` —— 相册元数据
- `photo-source/<slug>/captions.json` —— 照片说明（初始为空）

slug 会出现在 URL（`/photography/<slug>/`）里，用英文/数字加短横线，参照已有的 `tengger-202610`。

### 2. 放入原片

把相机导出的 `.jpg/.jpeg`（大写扩展名也可以）复制进 `photo-source/<slug>/`。页面排序按文件名，IMG 编号天然就是拍摄顺序。

### 3. 编辑 album.yml

```yaml
title: 冬日
date: 2027-01-15
description: 一句话描述这个相册。
cover: IMG01740      # 可选：封面文件名（不带扩展名）；留空默认第一张
```

### 4. （可选）编辑 captions.json

给照片配文字，key 是不带扩展名的文件名：

```json
{
  "IMG01740": "雪落下的声音"
}
```

### 5. 构建

```powershell
ruby tools/photos/bin/build_albums
```

每张原片会生成三档尺寸（thumb 500 / medium 1280 / large 2000）到 `assets/photos/<slug>/`，读取 EXIF，并生成 `_data/albums/<slug>.yml`。按文件 SHA256 增量处理，未改动的照片自动跳过。

需要本机安装 [ffmpeg](https://ffmpeg.org)。

### 6. 本地验证与发布

Jekyll 服务开着会自动重建，在 <http://127.0.0.1:4000/photography/> 查看，新相册按日期倒序排列。确认无误后提交生成的文件并推送：

```powershell
git add assets/photos _data/albums
git commit -m "新增相册：<slug>"
git push
```

`photo-source/`（原片）已在 .gitignore 中，不入库；入库的是生成的三档图和数据文件。

### 维护

- **追加照片**：新片放入对应目录，重跑 `build_albums`，只处理新增的。换封面则改 album.yml 的 `cover` 再重跑。
- **删除照片**：从 `photo-source` 删掉并重跑后数据会更新，但 `assets/photos/` 里对应的旧图不会自动清理，需手动删除。

## 添加随感（essays）

随感是 Jekyll collection，没有构建管线，直接管理 markdown 文件：

- `_essays/`：正式文章目录，文件会构建成页面并入库，URL 为 `/essays/<年份>/<slug>/`
- `essay-source/`：本地草稿/素材区，不入库、Jekyll 不处理（类似 photo-source）。可先在此写草稿，定稿后放进 `_essays/`

### 添加

```powershell
ruby tools/photos/bin/new_essay <slug>
```

生成 `_essays/<slug>.md`。slug 用英文/数字加短横线，会出现在 URL 里。生成后需手动补两处 front matter：`title`（脚手架留空）和把 `date` 的完整时间戳简化为 `YYYY-MM-DD`，然后在第二个 `---` 之后写正文。

列表页 `/essays/` 自动按年份分组、组内日期倒序，无需维护索引。

### 改动与删除

- **改动**：直接编辑 `_essays/<slug>.md`，Jekyll 自动重建。
- **删除**：删掉文件并提交（`git rm _essays/<slug>.md`），列表页和详情页自动消失。

### 发布

```powershell
git add _essays
git commit -m "新增随感：<标题>"
git push
```
