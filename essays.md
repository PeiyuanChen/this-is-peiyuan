---
title: "随感"
permalink: /essays/
layout: single
---

{% assign groups = site.essays | group_by_exp: "essay", "essay.date | date: '%Y'" | sort: "name" | reverse %}
{% for group in groups %}
## {{ group.name }}

<ul class="essay-list">
  {% assign items = group.items | sort: "date" | reverse %}
  {% for essay in items %}
  <li>
    <a href="{{ essay.url | relative_url }}">{{ essay.title }}</a>
    <time datetime="{{ essay.date | date_to_xmlschema }}">{{ essay.date | date: "%Y-%m-%d" }}</time>
  </li>
  {% endfor %}
</ul>
{% endfor %}
