---
title: "摄影"
permalink: /photography/
layout: single
---
{% assign cdn = site.image_cdn | default: "" %}
<link rel="stylesheet" href="{{ '/assets/css/albums.css' | relative_url }}">

<div class="album-grid">
{% for album in site.albums_sorted %}
  {% assign cover = album.photos | where: "file", album.cover | first %}
  {% if cdn == "" %}
    {% assign src = '/assets/photos/' | append: cover.urls.thumb | relative_url %}
  {% else %}
    {% assign src = cdn | append: '/' | append: cover.urls.thumb %}
  {% endif %}
  <a class="album-card" href="{{ '/photography/' | append: album.slug | relative_url }}/">
    <img src="{{ src }}" alt="{{ album.title }}" loading="lazy">
    <span class="album-card-title">{{ album.title }}</span>
    <span class="album-card-date">{{ album.date | date: "%Y-%m" }}</span>
  </a>
{% endfor %}
</div>
