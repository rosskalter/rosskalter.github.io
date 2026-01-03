---
layout: page
title: Projects
permalink: /projects/
---

# Projects

Below are a few of my selected projects. Click the title to view details:

{% for post in site.posts %}
- **[{{ post.title }}]({{ post.url }})**
  {% if post.excerpt %}
  — {{ post.excerpt | strip_html | truncate: 150 }}
  {% endif %}
{% endfor %}
