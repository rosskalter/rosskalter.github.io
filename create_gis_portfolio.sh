#!/usr/bin/env bash
set -euo pipefail

# Create directories
mkdir -p _layouts _projects assets/js assets/css img

# Download your resume into assets
curl -L -o assets/CV_Ross_Kalter.pdf "https://raw.githubusercontent.com/rosskalter/CV/3721b116af7d23b85862a948bb57eb1c936e00c6/CV_Ross_Kalter.pdf" || echo "Warning: resume download failed; add assets/CV_Ross_Kalter.pdf manually."

# _config.yml
cat > _config.yml <<'YML'
title: "Ross Kalter — GIS Portfolio"
email: ""
description: "GIS, remote sensing, and marine ecology portfolio"
baseurl: "" # change if deploying to a subpath
url: "https://rosskalter.github.io"
markdown: kramdown
theme: minima

collections:
  projects:
    output: true
    permalink: /projects/:name/

defaults:
  - scope:
      path: ""
      type: "projects"
    values:
      layout: "project"
YML

# index.html
cat > index.html <<'HTML'
---
layout: default
title: Home
---
<header class="site-hero">
  <h1>Ross Kalter</h1>
  <p>GIS | Remote Sensing | Marine & Seascape Ecology</p>
  <p><a href="/about.html">About</a> • <a href="/projects/">Projects</a> • <a href="/map.html">GIS Portfolio (Map)</a> • <a href="/assets/CV_Ross_Kalter.pdf">Resume (PDF)</a></p>
</header>

<main class="container">
  <section>
    <h2>About</h2>
    <p>I work with environmental and ecological systems through spatial data, modeling, and field-informed analysis. I’m drawn to complex systems — where remote sensing, computation, and ecology intersect — and to turning data into insight that supports real-world environmental decision-making.</p>
  </section>

  <section>
    <h2>Featured projects</h2>
    <ul class="tiles">
      {% for p in site.projects limit:3 %}
      <li class="tile">
        <a href="{{ p.url }}">
          {% if p.cover_image %}
          <img src="{{ p.cover_image }}" alt="{{ p.title }}"/>
          {% endif %}
          <h3>{{ p.title }}</h3>
          <p>{{ p.excerpt }}</p>
        </a>
      </li>
      {% endfor %}
    </ul>
  </section>
</main>
HTML

# about.md
cat > about.md <<'MARKDOWN'
---
layout: default
title: About
permalink: /about.html
---

I work with environmental and ecological systems through spatial data, modeling, and field-informed analysis. I’m drawn to complex systems — where remote sensing, computation, and ecology intersect — and to turning data into insight that supports real-world environmental decision-making.

Affiliation: University of Haifa

Contact: (add email or contact link here)
MARKDOWN

# _layouts/default.html
cat > _layouts/default.html <<'HTML'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>{{ page.title }} — {{ site.title }}</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
  <link rel="stylesheet" href="/assets/css/main.css">
</head>
<body>
  <nav class="site-nav">
    <a href="/">Home</a>
    <a href="/about.html">About</a>
    <a href="/projects/">Projects</a>
    <a href="/map.html">GIS Portfolio (Map)</a>
    <a href="/assets/CV_Ross_Kalter.pdf" target="_blank">Resume</a>
  </nav>

  <main>
    {{ content }}
  </main>

  <footer>
    <p>© Ross Kalter</p>
  </footer>

  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
  <script src="/assets/js/maps.js"></script>
</body>
</html>
HTML

# _layouts/project.html
cat > _layouts/project.html <<'HTML'
---
layout: default
---
<article class="project-page">
  <header>
    <h1>{{ page.title }}</h1>
    <p class="meta">{{ page.technologies | join: ", " }}</p>
  </header>

  {% if page.cover_image %}
  <img class="project-cover" src="{{ page.cover_image }}" alt="{{ page.title }}">
  {% endif %}

  <section class="project-content">
    {{ content }}
  </section>

  <section class="project-map">
    <div id="project-map" style="height:360px;"></div>
    <script>
      document.addEventListener("DOMContentLoaded", function(){
        var lat = {{ page.coords.lat | default: 32.7940 }};
        var lon = {{ page.coords.lon | default: 34.9896 }};
        initProjectMap('project-map', lat, lon, 12);
      });
    </script>
  </section>

  <p><a href="/projects/">Back to projects</a></p>
</article>
HTML

# projects index page
mkdir -p projects
cat > projects/index.html <<'HTML'
---
layout: default
title: Projects
permalink: /projects/
---
<h1>Projects</h1>
<p>Collection of GIS / remote sensing / analysis projects. Click a tile for details and a focused map.</p>

<div class="projects-grid">
  {% for p in site.projects %}
  <article class="project-tile">
    <a href="{{ p.url }}">
      {% if p.cover_image %}
      <img src="{{ p.cover_image }}" alt="{{ p.title }}">
      {% endif %}
      <h3>{{ p.title }}</h3>
      <p>{{ p.excerpt }}</p>
      <p class="meta">{{ p.technologies | join: ", " }}</p>
    </a>
  </article>
  {% endfor %}
</div>
HTML

# map.html
cat > map.html <<'HTML'
---
layout: default
title: GIS Portfolio Map
permalink: /map.html
---
<h1>GIS Portfolio Map</h1>
<div id="site-map" style="height:600px;"></div>

<script>
  document.addEventListener("DOMContentLoaded", function(){
    initSiteMap('site-map', '/projects.geojson');
  });
</script>
HTML

# projects.geojson (liquid)
cat > projects.geojson <<'JSON'
---
layout: none
permalink: /projects.geojson
---
{
  "type": "FeatureCollection",
  "features": [
    {% for p in site.projects %}
    {
      "type": "Feature",
      "properties": {
        "title": "{{ p.title | xml_escape }}",
        "excerpt": "{{ p.excerpt | xml_escape }}",
        "page_url": "{{ p.url }}",
        "technologies": [{% for t in p.technologies %}"{{ t }}"{% if forloop.last == false %}, {% endif %}{% endfor %}]
      },
      "geometry": {
        "type": "Point",
        "coordinates": [{{ p.coords.lon | default: 34.9896 }}, {{ p.coords.lat | default: 32.7940 }}]
      }
    }{% if forloop.last == false %},{% endif %}
    {% endfor %}
  ]
}
JSON

# seed project 1
cat > _projects/intertidal-habitat-mapping.md <<'MD'
---
title: "Intertidal Habitat Mapping"
slug: "intertidal-habitat-mapping"
tags: ["remote-sensing","intertidal","GEE","R"]
technologies: ["Google Earth Engine", "R", "QGIS"]
coords:
  lat: 32.7940
  lon: 34.9896
repo_url: ""
cover_image: "/img/intertidal.jpg"
excerpt: "Mapping intertidal habitat extent with Sentinel-2 and field observations."
---

This example project demonstrates using Google Earth Engine to derive intertidal habitat extent from Sentinel-2 time series, validated with field observations. Methods: cloud masking, tidal composite selection, supervised classification, validation in R. Results: habitat extent maps and accuracy assessment.
MD

# seed project 2
cat > _projects/rocky-shore-spectral-analysis.md <<'MD'
---
title: "Rocky Shore Spectral Analysis"
slug: "rocky-shore-spectral-analysis"
tags: ["remote-sensing","rocky shores","spectral","python"]
technologies: ["Python", "scikit-learn", "Sentinel-2"]
coords:
  lat: 32.78
  lon: 34.99
repo_url: ""
cover_image: "/img/rocky_shore.jpg"
excerpt: "Using spectral indices and classification to identify rock vs macroalgal patches."
---

This sample uses Sentinel-2 indices and Python-based workflows to separate substrate types on rocky coasts. Includes scripts to calculate indices, train a classifier, and create maps suitable for area estimation.
MD

# seed project 3
cat > _projects/temperate-waters-sentinel-analysis.md <<'MD'
---
title: "Temperate Waters Sentinel Analysis"
slug: "temperate-waters-sentinel-analysis"
tags: ["remote-sensing","temperate waters","R"]
technologies: ["R", "tidyverse", "raster"]
coords:
  lat: 32.81
  lon: 34.97
repo_url: ""
cover_image: "/img/temperate_waters.jpg"
excerpt: "Example of water quality and turbidity mapping in temperate nearshore waters using Sentinel-2."
---

Example analysis pipeline demonstrating atmospheric correction, band ratios for turbidity, and nearshore masking to produce weekly turbidity maps and simple time-series plots.
MD

# assets/js/maps.js
cat > assets/js/maps.js <<'JS'
// Minimal Leaflet helpers (used by project and site map pages)
function initProjectMap(containerId, lat, lon, zoom=12) {
  const map = L.map(containerId).setView([lat, lon], zoom);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '© OpenStreetMap contributors'
  }).addTo(map);
  L.marker([lat, lon]).addTo(map);
  return map;
}

async function initSiteMap(containerId, geojsonUrl) {
  const map = L.map(containerId).setView([32.7940, 34.9896], 10);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© OpenStreetMap contributors'
  }).addTo(map);

  try {
    const res = await fetch(geojsonUrl);
    const geojson = await res.json();
    L.geoJSON(geojson, {
      onEachFeature: (feature, layer) => {
        const props = feature.properties || {};
        const link = props.page_url ? `<br><a href="${props.page_url}">Open project</a>` : '';
        layer.bindPopup(`<strong>${props.title}</strong><br>${props.excerpt || ''}${link}`);
      }
    }).addTo(map);
  } catch (err) {
    console.error('Could not load GeoJSON:', err);
  }
  return map;
}
JS

# assets/css/main.css
cat > assets/css/main.css <<'CSS'
body { font-family: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial; margin:0; padding:0; color:#222; }
.site-nav { background:#f8f8f8; padding:12px; display:flex; gap:12px; }
.container { padding: 24px; max-width:1000px; margin:0 auto; }
.projects-grid { display:grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap:16px; padding:0; }
.project-tile { border:1px solid #eee; padding:12px; border-radius:6px; background:#fff; }
.project-tile img { width:100%; height:140px; object-fit:cover; border-radius:4px; }
.tiles { list-style:none; padding:0; display:flex; gap:12px; }
.tile img { width:220px; height:120px; object-fit:cover; border-radius:6px; }
.footer { text-align:center; padding:20px; }
CSS

# update README.md
cat > README.md <<'MD'
# Ross Kalter — GIS Portfolio (Jekyll)

This repo contains a Jekyll-based GIS portfolio scaffold. A branch `gis-portfolio` has been created with the site scaffold including seeded example projects. Review the PR and merge to publish at https://rosskalter.github.io when ready.

Key points:
- Projects are stored in `_projects/` as collection items (no dates).
- Each project must have front matter with `title`, `coords.lat`, `coords.lon`, `technologies`, and `excerpt`.
- `projects.geojson` is generated at build time and used by the site-wide map.

To add a new project:
1. Create `_projects/your-project.md`
2. Add front matter (see examples in `_projects/`)
3. Add project content and images (place images in `img/` and set `cover_image`)

Resume:
- The site links to the resume stored in your CV repo at the raw URL. A local copy was downloaded to `assets/CV_Ross_Kalter.pdf` if available.
MD

echo "All files written. Please git add/commit/push on branch gis-portfolio and open a PR."
