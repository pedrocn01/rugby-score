/**
 * Genera un HTML para previsualizar todos los logos descargados.
 * Ejecutar: node scripts/preview_logos.js
 * Luego abrir: assets/logos/preview.html en el navegador.
 */
const fs = require('fs');
const path = require('path');

const LOGOS_DIR = path.join(__dirname, '..', 'assets', 'logos');
const OUT_FILE = path.join(LOGOS_DIR, 'preview.html');

const SECTIONS = {
  'Carpetas (Home)':        f => f.startsWith('folder_'),
  'Clubes URBA':            f => f.startsWith('club_'),
  'Super Rugby Pacific':    f => f.startsWith('srp_'),
  'United Rugby Champ.':    f => f.startsWith('urc_'),
  'Super Rugby Américas':   f => f.startsWith('sra_'),
  'Top 14':                 f => f.startsWith('top14_'),
  'Premiership':            f => f.startsWith('pre_'),
  'Torneo del Interior':    f => f.startsWith('tdi_'),
  'Selecciones':            f => f.startsWith('nat_'),
  'Ligas / Torneos':        f => f.startsWith('league_'),
};

const files = fs.readdirSync(LOGOS_DIR)
  .filter(f => f.endsWith('.png') && f !== 'preview.html');

function card(file) {
  const name = file.replace('.png', '').replace(/_/g, ' ');
  const size = Math.round(fs.statSync(path.join(LOGOS_DIR, file)).size / 1024);
  return `
    <div class="card">
      <img src="${file}" alt="${name}" onerror="this.style.background='#c00';this.alt='ERROR'">
      <p>${name}</p>
      <span>${size} KB</span>
    </div>`;
}

let html = `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Preview Logos Rugby</title>
<style>
  body { background: #0a0a0a; color: #fff; font-family: sans-serif; padding: 20px; }
  h1 { color: #4caf50; }
  h2 { color: #4caf50; border-bottom: 1px solid #333; padding-bottom: 6px; margin-top: 40px; }
  .grid { display: flex; flex-wrap: wrap; gap: 12px; margin-top: 16px; }
  .card { background: #1a1a1a; border-radius: 8px; padding: 12px; text-align: center; width: 120px; }
  .card img { width: 80px; height: 80px; object-fit: contain; background: #2a2a2a; border-radius: 4px; }
  .card p { font-size: 11px; margin: 6px 0 2px; color: #ccc; word-break: break-word; }
  .card span { font-size: 10px; color: #666; }
  .summary { background: #1a1a1a; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; }
</style>
</head>
<body>
<h1>Preview — Logos Rugby Score</h1>
<div class="summary">Total: <strong>${files.length}</strong> logos descargados</div>
`;

for (const [title, matcher] of Object.entries(SECTIONS)) {
  const section = files.filter(f => matcher(f.replace('.png', '')));
  if (section.length === 0) continue;
  html += `<h2>${title} (${section.length})</h2><div class="grid">`;
  html += section.map(card).join('');
  html += `</div>`;
}

// Logos que no caen en ninguna sección
const categorized = Object.values(SECTIONS).flatMap(m => files.filter(f => m(f.replace('.png', ''))));
const other = files.filter(f => !categorized.includes(f));
if (other.length) {
  html += `<h2>Otros (${other.length})</h2><div class="grid">`;
  html += other.map(card).join('');
  html += `</div>`;
}

html += `</body></html>`;

fs.writeFileSync(OUT_FILE, html);
console.log(`Preview generado: ${OUT_FILE}`);
console.log(`Total logos: ${files.length}`);
