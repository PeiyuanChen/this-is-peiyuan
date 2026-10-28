---
title:
layout: single
---

<link rel="stylesheet" href="{{ '/assets/css/home.css' | relative_url }}?v={{ site.time | date: '%Y%m%d%H%M%S' }}">

<div class="home-layout" markdown="1">

<div class="home-main" markdown="1">

<div class="bio">
<input class="bio-radio" type="radio" name="bio-mode" id="bio-default" checked>
<input class="bio-radio" type="radio" name="bio-mode" id="bio-long">
<div class="bio-bar">
  <h1 class="page__title">Bio</h1>
  <span class="bio-tabs">
    <label class="bio-tab" for="bio-default">Default</label>
    <label class="bio-tab" for="bio-long">Long</label>
  </span>
</div>

<div class="bio-short" markdown="1">

Hi，我是陈培源。很少有人找到这里，你来到了，看到了，我们应该是认识的吧。我其实不大会聊天，话不多，总觉得许多事情没有多少聊的念头，也因为平时说话少导致了一些表达的障碍，老问题了，见谅。

2026年的一天，我突然想着找个地方安安静静的记录一下自己，打开自己，让我的朋友们多一个地方可以看见我，感觉到我。就这里吧。

</div>

<div class="bio-long" markdown="1">

Hi，我是陈培源。很少有人找到这里，你来到了，看到了，我们应该是认识的吧。我其实不大会聊天，话不多，总觉得许多事情没有多少聊的念头，也因为平时说话少导致了一些表达的障碍，老问题了，见谅。

2026年的一天，我突然想着找个地方安安静静的记录一下自己，打开自己，让我的朋友们多一个地方可以看见我，感觉到我。就这里吧。

人生的路上，每个阶段都遇到过挺好的朋友。只是因为生活和工作，后来慢慢少了联系。我总想着即使多年不见，彼此也不会改变。现在我其实不是很确定，自己是否还是初见时的样子。

大学毕业后没有对口的工作，我就去做软件了，一做就快20年了。做的服务端，技术岗，没做过别的。这大概也进一步的影响了我性格习惯的某些方面的。

我喜欢摄影（拍照），以前喜欢拍风景和小品，现在拍孩子比较多。十多年了，从宾得K5到索尼A7R3，七八个定焦镜头，拍摄水平却是没有怎么增长，入门之后就一直在门槛附近，摄影这事想进一步其实挺难的吧。

我喜欢书法，看了一堆书，报了多个网班，练了好几年，老师挺厉害的，但我写出来的字依然不好看，老师说是练得少了。这个爱好让我真切的感觉到了在没有天赋的地方努力真是一件事倍功半的事情。

我喜欢手工，最初想着自己做刀具，做刀鞘的时候又觉得皮具很有意思。现在还是喜欢手工皮艺，喜欢植鞣革皮具随着使用随着时间的变化，这不像极了我们自己吗，岁月流走总会留下痕迹。这几年常会有想要做点手工的冲动，但已经好久没做了，总是觉得能真正放松的大块的时间很少。

说起爱好，其实我挺有兴趣的，只是现在时间不多。大多的时间里，工作和生活，我们应该是有许多相似，即使做不同的工作。

如果想起我，可以来这里看看，我就在这里，我一直都在。当然，直接联系会更好。

愿你平安喜乐

</div>

</div>

<section class="home-section" markdown="1">

## 随感

{% assign essays_sorted = site.essays | sort: "date" | reverse %}
<ul class="essay-feed">
{% for essay in essays_sorted limit: 6 %}
  <li>
    <a href="{{ essay.url | relative_url }}">
      <span class="essay-title">{{ essay.title }}</span>
      <time datetime="{{ essay.date | date_to_xmlschema }}">{{ essay.date | date: "%Y-%m-%d" }}</time>
    </a>
  </li>
{% endfor %}
</ul>

<p class="feed-more"><a href="{{ '/essays/' | relative_url }}">全部随感</a></p>

</section>

<section class="home-section" markdown="1">

## 相册

{% assign cdn = site.image_cdn | default: "" %}
<ul class="album-feed">
{% for item in site.home_albums %}
  {% if cdn == "" %}
    {% assign src = '/assets/photos/' | append: item.thumb | relative_url %}
  {% else %}
    {% assign src = cdn | append: '/' | append: item.thumb %}
  {% endif %}
  <li>
    <a href="{{ item.url | relative_url }}">
      <img class="feed-thumb" src="{{ src }}" alt="" loading="lazy" width="120" height="80">
      <span class="feed-body">
        <span class="feed-title">{{ item.title }}</span>
        <time datetime="{{ item.date | date_to_xmlschema }}">{{ item.date | date: "%Y-%m-%d" }}</time>
      </span>
    </a>
  </li>
{% endfor %}
</ul>

<p class="feed-more"><a href="{{ '/photography/' | relative_url }}">全部摄影</a></p>

</section>

</div>

<aside class="home-art" aria-hidden="true">
  <img src="{{ '/assets/images/beach.svg' | relative_url }}" alt="" width="816" height="1488">
</aside>

</div>
