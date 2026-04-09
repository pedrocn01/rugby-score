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

/// Devuelve la URL del logo de un club, o null si no hay.
String? clubLogo(String teamName) => clubLogoUrls[teamName];
