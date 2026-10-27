---
title: "This is Peiyuan"
layout: single
---

<link rel="stylesheet" href="{{ '/assets/css/home.css' | relative_url }}?v={{ site.time | date: '%Y%m%d%H%M%S' }}">

Hi，我是陈培源。很少有人找到这里，你来到了，看到了，我们应该是认识的吧。我是挺内向的，平时话也不多，总觉得许多事情没有多少聊的念头，也因为平时说话少导致了一些表达的障碍，老问题了，见谅。

因为话少，朋友们了解我的渠道就比较受限制了，2026年的一天，我突然想着找个地方安安静静的记录一下自己，打开自己。就这里吧。

人生的路上，每个阶段都遇到过挺好的朋友。只是因为生活和工作，后来慢慢少了联系。我总想着即使多年不见，彼此也不会改变。现在我其实不是很确定，自己是否还是初见时的样子。

大学毕业后没有对口的工作，我就去做软件了，一做就快20年了。做的服务端，技术岗，没做过别的。这大概也进一步的影响了我性格习惯的某些方面的。

我喜欢摄影（拍照），以前喜欢拍风景和小品，现在拍孩子比较多。十多年了，从宾得K5到索尼A7R3，七八个定焦镜头，拍摄水平却是没有怎么增长，入门之后就一直在门槛附近，摄影这事想进一步其实挺难的吧。

我喜欢书法，看了一堆书，报了多个网班，练了好几年，老师挺厉害的，但我写出来的字依然不好看，老师说是练得少了，这个爱好让我发现了在没有天赋的地方努力真是一件事倍功半的事情。

我喜欢手工，最初想着自己做刀具，做刀鞘的时候又觉得皮具很有意思。现在还是喜欢手工皮艺，喜欢植鞣革皮具随着使用随着时间的变化，这不像极了我们自己吗，岁月流走总会留下痕迹。这几年常会有想要做点手工的冲动，但已经好久没做了，总是觉得能真正放松的大块的时间很少。

说起爱好，其实我挺有兴趣的，只是现在时间不多。大多的时间里，工作和生活，我们应该是有许多相似，即使做不同的工作。

如果想起我，可以来这里看看，我就在这里，我一直都在。当然，直接联系会更好。

愿你平安喜乐

## 最新

{% assign cdn = site.image_cdn | default: "" %}
<ul class="latest-feed">
{% for item in site.latest_feed %}
  {% if item.thumb %}
    {% if cdn == "" %}
      {% assign src = '/assets/photos/' | append: item.thumb | relative_url %}
    {% else %}
      {% assign src = cdn | append: '/' | append: item.thumb %}
    {% endif %}
  {% endif %}
  <li class="feed-item is-{{ item.type }}">
    <a href="{{ item.url | relative_url }}">
      {% if item.thumb %}
      <img class="feed-thumb" src="{{ src }}" alt="" loading="lazy" width="120" height="80">
      {% else %}
      <span class="feed-thumb feed-thumb--essay" aria-hidden="true">随感</span>
      {% endif %}
      <span class="feed-body">
        <span class="feed-title">{{ item.title }}</span>
        <span class="feed-meta">
          <span class="feed-kind">{% if item.type == "album" %}相册{% else %}随感{% endif %}</span>
          <time datetime="{{ item.date | date_to_xmlschema }}">{{ item.date | date: "%Y-%m-%d" }}</time>
        </span>
      </span>
    </a>
  </li>
{% endfor %}
</ul>

<p class="feed-more"><a href="{{ '/essays/' | relative_url }}">全部随感</a> &middot; <a href="{{ '/photography/' | relative_url }}">摄影</a></p>
