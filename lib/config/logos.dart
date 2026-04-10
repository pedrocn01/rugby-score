// URLs de logos para folders y clubes.
// Fuente: Wikimedia Commons / Wikipedia (licencia pública).

// ─── Logos de carpetas (home) ─────────────────────────────────────────────

const Map<String, String> folderLogoUrls = {
  'URBA': 'https://upload.wikimedia.org/wikipedia/en/thumb/1/1f/Urba_logo.png/200px-Urba_logo.png',
};

// ─── Logos de clubes URBA ─────────────────────────────────────────────────

const Map<String, String> clubLogoUrls = {
  // Con SVG en Wikimedia Commons (se sirve como PNG via /thumb/)
  'Hindú':               'https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Hindu_club_logo.svg/120px-Hindu_club_logo.svg.png',
  'Alumni':              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Alumni_rugby_logo.svg/120px-Alumni_rugby_logo.svg.png',
  'SIC':                 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/San_Isidro_Club_logo.svg/120px-San_Isidro_Club_logo.svg.png',
  'CASI':                'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/CA_san_isidro_logo.svg/120px-CA_san_isidro_logo.svg.png',
  'Belgrano Athletic':   'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Escudo_de_Belgrano_Athletic_Club.svg/120px-Escudo_de_Belgrano_Athletic_Club.svg.png',
  'Los Tilos':           'https://upload.wikimedia.org/wikipedia/commons/thumb/7/78/Lostilos_logo.svg/120px-Lostilos_logo.svg.png',
  'Regatas':             'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Regatas_BV_flaglogo.svg/120px-Regatas_BV_flaglogo.svg.png',
  'Atlético del Rosario':'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bb/Atlet_rosario_logo.svg/120px-Atlet_rosario_logo.svg.png',
  'Los Matreros':        'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Los_matreros_rc_logo.png/120px-Los_matreros_rc_logo.png',
  'CUBA':                'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Club_universitario_ba_primer_escudo_1918.png/200px-Club_universitario_ba_primer_escudo_1918.png',
  // Con PNG en Wikipedia /en/
  'Newman':              'https://upload.wikimedia.org/wikipedia/en/thumb/1/1c/Club_newman_escudo.png/120px-Club_newman_escudo.png',
  'Champagnat':          'https://upload.wikimedia.org/wikipedia/en/thumb/6/60/Club_champagnat_logo.png/120px-Club_champagnat_logo.png',
  'Buenos Aires C&RC':   'https://upload.wikimedia.org/wikipedia/en/thumb/1/17/Buenos_Aires_CRC_Crest.svg/120px-Buenos_Aires_CRC_Crest.svg.png',
  'La Plata':            'https://upload.wikimedia.org/wikipedia/en/thumb/d/d7/La_Plata_Rugby_Club_Crest.svg/120px-La_Plata_Rugby_Club_Crest.svg.png',
};

// ─── Logos de selecciones / federaciones internacionales ──────────────────────
// Fuente: flagcdn.com (banderas de alta calidad, dominio público)

const Map<String, String> _countryLogoUrls = {
  // Seis Naciones
  'Ireland':           'https://flagcdn.com/w80/ie.png',
  'France':            'https://flagcdn.com/w80/fr.png',
  'England':           'https://flagcdn.com/w80/gb-eng.png',
  'Scotland':          'https://flagcdn.com/w80/gb-sct.png',
  'Wales':             'https://flagcdn.com/w80/gb-wls.png',
  'Italy':             'https://flagcdn.com/w80/it.png',
  // Rugby Championship
  'Argentina':         'https://flagcdn.com/w80/ar.png',
  'Australia':         'https://flagcdn.com/w80/au.png',
  'New Zealand':       'https://flagcdn.com/w80/nz.png',
  'South Africa':      'https://flagcdn.com/w80/za.png',
  // Circuito 7s — otros países frecuentes
  'Fiji':              'https://flagcdn.com/w80/fj.png',
  'USA':               'https://flagcdn.com/w80/us.png',
  'Canada':            'https://flagcdn.com/w80/ca.png',
  'Uruguay':           'https://flagcdn.com/w80/uy.png',
  'Japan':             'https://flagcdn.com/w80/jp.png',
  'Spain':             'https://flagcdn.com/w80/es.png',
  'Portugal':          'https://flagcdn.com/w80/pt.png',
  'Georgia':           'https://flagcdn.com/w80/ge.png',
  'Romania':           'https://flagcdn.com/w80/ro.png',
  'Kenya':             'https://flagcdn.com/w80/ke.png',
  'Hong Kong':         'https://flagcdn.com/w80/hk.png',
  'Chile':             'https://flagcdn.com/w80/cl.png',
  'Samoa':             'https://flagcdn.com/w80/ws.png',
  'Tonga':             'https://flagcdn.com/w80/to.png',
  'Korea':             'https://flagcdn.com/w80/kr.png',
  'Great Britain':     'https://flagcdn.com/w80/gb.png',
  'United States':     'https://flagcdn.com/w80/us.png',
  'Brazil':            'https://flagcdn.com/w80/br.png',
  'Germany':           'https://flagcdn.com/w80/de.png',
  'Netherlands':       'https://flagcdn.com/w80/nl.png',
  'Belgium':           'https://flagcdn.com/w80/be.png',
  'Russia':            'https://flagcdn.com/w80/ru.png',
  'Zimbabwe':          'https://flagcdn.com/w80/zw.png',
  'Namibia':           'https://flagcdn.com/w80/na.png',
  'Uganda':            'https://flagcdn.com/w80/ug.png',
};

/// Devuelve la URL del logo de un club o selección, o null si no hay.
String? clubLogo(String teamName) =>
    clubLogoUrls[teamName] ?? _countryLogoUrls[teamName];
