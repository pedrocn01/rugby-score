// URLs de logos para folders, clubes y ligas.
// Fuente: Wikimedia Commons / Wikipedia / TheSportsDB (licencia pública).

// ─── Logos de carpetas (home) ─────────────────────────────────────────────

const Map<String, String> folderLogoUrls = {
  'URBA':        'https://upload.wikimedia.org/wikipedia/en/thumb/1/1f/Urba_logo.png/200px-Urba_logo.png',
  'Circuito 7s': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/SVNS_Logo_%282023%29.svg/200px-SVNS_Logo_%282023%29.svg.png',
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
  'CUBA':                'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Universitario_BA_logo.svg/120px-Universitario_BA_logo.svg.png',
  // Con PNG en Wikipedia /en/
  'Newman':              'https://upload.wikimedia.org/wikipedia/en/thumb/1/1c/Club_newman_escudo.png/120px-Club_newman_escudo.png',
  'Champagnat':          'https://upload.wikimedia.org/wikipedia/en/thumb/6/60/Club_champagnat_logo.png/120px-Club_champagnat_logo.png',
  'Buenos Aires C&RC':   'https://upload.wikimedia.org/wikipedia/en/thumb/1/17/Buenos_Aires_CRC_Crest.svg/120px-Buenos_Aires_CRC_Crest.svg.png',
  'La Plata':            'https://upload.wikimedia.org/wikipedia/en/thumb/d/d7/La_Plata_Rugby_Club_Crest.svg/120px-La_Plata_Rugby_Club_Crest.svg.png',

  // ── Super Rugby Pacific ────────────────────────────────────────────────
  'Crusaders':           'https://upload.wikimedia.org/wikipedia/en/thumb/7/76/Crusaders_logo.svg/120px-Crusaders_logo.svg.png',
  'Blues':               'https://upload.wikimedia.org/wikipedia/en/thumb/e/e1/The_Blues_Logo.svg/120px-The_Blues_Logo.svg.png',
  'Chiefs':              'https://upload.wikimedia.org/wikipedia/en/thumb/4/40/Chiefs_Logo.svg/120px-Chiefs_Logo.svg.png',
  'Highlanders':         'https://upload.wikimedia.org/wikipedia/en/thumb/a/a9/Highlanders_Logo.svg/120px-Highlanders_Logo.svg.png',
  'Hurricanes':          'https://upload.wikimedia.org/wikipedia/en/thumb/4/4d/Hurricanes_Logo.svg/120px-Hurricanes_Logo.svg.png',
  'Brumbies':            'https://upload.wikimedia.org/wikipedia/en/thumb/c/cc/ACT_Brumbies_logo.svg/120px-ACT_Brumbies_logo.svg.png',
  'Waratahs':            'https://upload.wikimedia.org/wikipedia/en/thumb/0/0a/NSW_Waratahs_logo.svg/120px-NSW_Waratahs_logo.svg.png',
  'Reds':                'https://upload.wikimedia.org/wikipedia/en/thumb/2/22/Queensland_Reds_logo.svg/120px-Queensland_Reds_logo.svg.png',
  'Western Force':       'https://upload.wikimedia.org/wikipedia/en/thumb/6/6b/Western_Force_logo.svg/120px-Western_Force_logo.svg.png',
  'Moana Pasifika':      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Moana_Pasifika_logo.svg/120px-Moana_Pasifika_logo.svg.png',
  'Fijian Drua':         'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Fijian_Drua_logo.svg/120px-Fijian_Drua_logo.svg.png',

  // ── United Rugby Championship ──────────────────────────────────────────
  'Zebre Parma':         'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Zebre_rugby.svg/120px-Zebre_rugby.svg.png',
  'Zebre':               'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Zebre_rugby.svg/120px-Zebre_rugby.svg.png',
  'Cardiff Rugby':       'https://upload.wikimedia.org/wikipedia/en/thumb/1/11/Cardiff_Rugby_crest_2022.png/120px-Cardiff_Rugby_crest_2022.png',
  'Cardiff':             'https://upload.wikimedia.org/wikipedia/en/thumb/1/11/Cardiff_Rugby_crest_2022.png/120px-Cardiff_Rugby_crest_2022.png',
  'Benetton Rugby':      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Benetton_Rugby_logo.svg/120px-Benetton_Rugby_logo.svg.png',
  'Benetton':            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Benetton_Rugby_logo.svg/120px-Benetton_Rugby_logo.svg.png',
  'Dragons RFC':         'https://upload.wikimedia.org/wikipedia/en/thumb/4/44/Newport_Gwent_Dragons_logo.svg/120px-Newport_Gwent_Dragons_logo.svg.png',
  'Dragons':             'https://upload.wikimedia.org/wikipedia/en/thumb/4/44/Newport_Gwent_Dragons_logo.svg/120px-Newport_Gwent_Dragons_logo.svg.png',
  'Scarlets':            'https://upload.wikimedia.org/wikipedia/en/thumb/e/ef/Scarlets_RFC_logo.svg/120px-Scarlets_RFC_logo.svg.png',
  'Edinburgh Rugby':     'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Edinburgh_Rugby_logo.svg/120px-Edinburgh_Rugby_logo.svg.png',
  'Edinburgh':           'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Edinburgh_Rugby_logo.svg/120px-Edinburgh_Rugby_logo.svg.png',
  'Ospreys':             'https://upload.wikimedia.org/wikipedia/en/thumb/c/c0/Ospreys_2020.png/120px-Ospreys_2020.png',

  // ── Super Rugby Américas ───────────────────────────────────────────────
  'Cobras':              'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Cobras_Brazil_logo.png/120px-Cobras_Brazil_logo.png',
  'Brasil Cobras':       'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Cobras_Brazil_logo.png/120px-Cobras_Brazil_logo.png',
  'Cobras Brasil':       'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Cobras_Brazil_logo.png/120px-Cobras_Brazil_logo.png',
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

// ─── Logos de ligas / torneos (home tiles) ────────────────────────────────
// Fuente: Wikimedia Commons / Wikipedia (CORS habilitado, dominio público)

const Map<String, String> leagueLogoUrls = {
  'Top 14':                    'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7d/Top_14_Logo.svg/200px-Top_14_Logo.svg.png',
  'Premiership':               'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/Logo_of_Premiership_Rugby_2018.svg/330px-Logo_of_Premiership_Rugby_2018.svg.png',
  'United Rugby Championship': 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/United_Rugby_Championship_logo.svg/250px-United_Rugby_Championship_logo.svg.png',
  'Champions Cup':             'https://upload.wikimedia.org/wikipedia/en/thumb/6/65/InvestecChampionsCupLogo.svg/250px-InvestecChampionsCupLogo.svg.png',
  'Challenge Cup':             'https://upload.wikimedia.org/wikipedia/en/thumb/0/03/EPCRchallengecuplogo.svg/250px-EPCRchallengecuplogo.svg.png',
  'Super Rugby Pacific':       'https://upload.wikimedia.org/wikipedia/en/2/25/Super_Rugby_Pacific_logo.png',
  'Seis Naciones':             'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/SixNationsRugbyCup.svg/250px-SixNationsRugbyCup.svg.png',
  'The Rugby Championship':    'https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/The_Rugby_Championship_logo_%28white_background%29.png/250px-The_Rugby_Championship_logo_%28white_background%29.png',
  'Super Rugby Américas':      'https://upload.wikimedia.org/wikipedia/en/2/27/Super_Rugby_Americas_logo.png',
  'URBA Top 14':               'https://upload.wikimedia.org/wikipedia/en/thumb/1/1f/Urba_logo.png/200px-Urba_logo.png',
};

/// Devuelve la URL del logo de una liga/torneo, o null si no hay.
String? leagueLogo(String leagueName) => leagueLogoUrls[leagueName];
