---
layout: default
title: "All tags"
important:
    - alc
    - aviation
    - cycling
    - deltalake
    - freebsd
    - jenkins
    - opensource
    - rust
    - vfrstudentpilot
---

<!--
Source - https://stackoverflow.com/a
Posted by Lei.L, modified by community. See post 'Timeline' for change history
Retrieved 2026-01-01, License - CC BY-SA 4.0
-->

{% capture site_tags %}{% for tag in site.tags %}{{ tag | first }}{% unless forloop.last %},{% endunless %}{% endfor %}{% endcapture %}
{% assign tags_list = site_tags | split:',' | sort_natural %}

  <div class="archive-group">
    <h2 class="archive-cat">All tags</h2>
    {% for tag in tags_list %}
      {% if page.important contains tag %}
      <strong>
      <a class="archive-link" href="/tag/{{ tag }}">{{tag}}</a>
      </strong>
      {% else %}
      <a class="archive-link" href="/tag/{{ tag }}">{{tag}}</a>
      {% endif %}
    {% endfor %}
  </div>
