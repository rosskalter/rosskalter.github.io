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
