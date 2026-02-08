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
