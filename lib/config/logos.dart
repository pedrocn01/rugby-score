// Paths de logos guardados localmente en assets/logos/.
// Todos los archivos fueron descargados y se sirven desde la app (sin URLs externas).

// ─── Logos de carpetas (home) ─────────────────────────────────────────────

const Map<String, String> folderLogoUrls = {
  'URBA':        'assets/logos/folder_urba.png',
  'Circuito 7s': 'assets/logos/folder_circuito_7s.png',
};

// Logos locales (assets SVG) — usan SvgPicture.asset en vez de Image.asset
const Map<String, String> folderLogoAssets = {
  'Torneo del Interior': 'assets/logos/torneo_interior.svg',
};

// ─── Logos de clubes ──────────────────────────────────────────────────────

const Map<String, String> clubLogoUrls = {
  // ── URBA ─────────────────────────────────────────────────────────────────
  'Hindú':               'assets/logos/club_hindu.png',
  'Alumni':              'assets/logos/club_alumni.png',
  'SIC':                 'assets/logos/club_sic.png',
  'CASI':                'assets/logos/club_casi.png',
  'Belgrano Athletic':   'assets/logos/club_belgrano_athletic.png',
  'Los Tilos':           'assets/logos/club_los_tilos.png',
  'Regatas':             'assets/logos/club_regatas.png',
  'Atlético del Rosario':'assets/logos/club_atletico_rosario.png',
  'Los Matreros':        'assets/logos/club_los_matreros.png',
  'CUBA':                'assets/logos/club_cuba.png',
  'Newman':              'assets/logos/club_newman.png',
  'Champagnat':          'assets/logos/club_champagnat.png',
  'Buenos Aires C&RC':   'assets/logos/club_buenos_aires_crc.png',
  'Buenos Aires CRC':    'assets/logos/club_buenos_aires_crc.png',
  'Regatas Bella Vista': 'assets/logos/club_regatas.png',
  'La Plata':            'assets/logos/club_la_plata.png',

  // ── Super Rugby Pacific ───────────────────────────────────────────────────
  'Crusaders':           'assets/logos/srp_crusaders.png',
  'Blues':               'assets/logos/srp_blues.png',
  'Chiefs':              'assets/logos/srp_chiefs.png',
  'Highlanders':         'assets/logos/srp_highlanders.png',
  'Hurricanes':          'assets/logos/srp_hurricanes.png',
  'Brumbies':            'assets/logos/srp_brumbies.png',
  'Waratahs':            'assets/logos/srp_waratahs.png',
  'NSW Waratahs':        'assets/logos/srp_waratahs.png',
  'Reds':                'assets/logos/srp_reds.png',
  'Queensland Reds':     'assets/logos/srp_reds.png',
  'Western Force':       'assets/logos/srp_western_force.png',
  'Moana Pasifika':      'assets/logos/srp_moana_pasifika.png',
  'Fijian Drua':         'assets/logos/srp_fijian_drua.png',

  // ── United Rugby Championship ─────────────────────────────────────────────
  'Zebre Parma':         'assets/logos/urc_zebre.png',
  'Zebre':               'assets/logos/urc_zebre.png',
  'Cardiff Rugby':       'assets/logos/urc_cardiff.png',
  'Cardiff':             'assets/logos/urc_cardiff.png',
  'Benetton Rugby':      'assets/logos/urc_benetton.png',
  'Benetton':            'assets/logos/urc_benetton.png',
  'Dragons RFC':         'assets/logos/urc_dragons.png',
  'Dragons':             'assets/logos/urc_dragons.png',
  'Scarlets':            'assets/logos/urc_scarlets.png',
  'Edinburgh Rugby':     'assets/logos/urc_edinburgh.png',
  'Edinburgh':           'assets/logos/urc_edinburgh.png',
  'Ospreys':             'assets/logos/urc_ospreys.png',
  'Leinster':            'assets/logos/urc_leinster.png',
  'Munster':             'assets/logos/urc_munster.png',
  'Ulster':              'assets/logos/urc_ulster.png',
  'Connacht':            'assets/logos/urc_connacht.png',
  'Glasgow Warriors':    'assets/logos/urc_glasgow.png',
  'Stormers':            'assets/logos/urc_stormers.png',
  'Lions':               'assets/logos/urc_lions.png',
  'Bulls':               'assets/logos/urc_bulls.png',
  'Sharks':              'assets/logos/urc_sharks.png',

  // ── Super Rugby Américas ──────────────────────────────────────────────────
  'Cobras':              'assets/logos/sra_cobras.png',
  'Brasil Cobras':       'assets/logos/sra_cobras.png',
  'Cobras Brasil':       'assets/logos/sra_cobras.png',
  'Cobras XV':           'assets/logos/sra_cobras.png',
  'Black Lions':         'assets/logos/sra_black_lions.png',
  'Black Lion':          'assets/logos/sra_black_lions.png',
  'Cheetahs':            'assets/logos/sra_cheetahs.png',
  'Free State Cheetahs': 'assets/logos/sra_cheetahs.png',

  // ── Top 14 ────────────────────────────────────────────────────────────────
  'Stade Toulousain':    'assets/logos/top14_toulouse.png',
  'Bordeaux Bèglès':     'assets/logos/top14_bordeaux.png',
  'Bordeaux Begles':     'assets/logos/top14_bordeaux.png',
  'Stade Francais Paris':'assets/logos/top14_stade_francais.png',
  'Stade Français Paris':'assets/logos/top14_stade_francais.png',
  'Montpellier':         'assets/logos/top14_montpellier.png',
  'Clermont':            'assets/logos/top14_clermont.png',
  'Racing 92':           'assets/logos/top14_racing92.png',
  'Castres Olympique':   'assets/logos/top14_castres.png',
  'Stade Rochelais':     'assets/logos/top14_la_rochelle.png',
  'Aviron Bayonnais':    'assets/logos/top14_bayonne.png',
  'Stade Bayonnais':     'assets/logos/top14_bayonne.png',
  'RC Toulonnais':       'assets/logos/top14_toulon.png',
  'RC Toulon':           'assets/logos/top14_toulon.png',
  'Lyon':                'assets/logos/top14_lyon.png',
  'USA Perpignan':       'assets/logos/top14_perpignan.png',
  'Section Paloise':     'assets/logos/top14_pau.png',
  'Montauban':           'assets/logos/top14_montauban.png',

  // ── Premiership ───────────────────────────────────────────────────────────
  'Northampton Saints':  'assets/logos/pre_northampton.png',
  'Bath':                'assets/logos/pre_bath.png',
  'Leicester Tigers':    'assets/logos/pre_leicester.png',
  'Exeter Chiefs':       'assets/logos/pre_exeter.png',
  'Bristol':             'assets/logos/pre_bristol.png',
  'Bristol Bears':       'assets/logos/pre_bristol.png',
  'Saracens':            'assets/logos/pre_saracens.png',
  'Sale Sharks':         'assets/logos/pre_sale.png',
  'Gloucester':          'assets/logos/pre_gloucester.png',
  'Harlequins':          'assets/logos/pre_harlequins.png',
  'Newcastle Red Bulls': 'assets/logos/pre_newcastle.png',
  'Newcastle Falcons':   'assets/logos/pre_newcastle.png',

  // ── Torneo del Interior ───────────────────────────────────────────────────
  'Tucumán Rugby':              'assets/logos/tdi_tucuman.png',
  'Gimnasia y Esgrima de Rosario': 'assets/logos/tdi_gimnasia_rosario.png',
  'Marista RC':                 'assets/logos/tdi_marista.png',
  'Duendes RC':                 'assets/logos/tdi_duendes.png',
  'Jockey Club de Rosario':     'assets/logos/tdi_jockey_rosario.png',
  'Tala RC':                    'assets/logos/tdi_tala.png',
  'Córdoba Athletic':           'assets/logos/tdi_cordoba_athletic.png',
  'Universitario de Córdoba':   'assets/logos/tdi_universitario_cba.png',
  'Jockey Club de Córdoba':     'assets/logos/tdi_jockey_cordoba.png',
  'La Tablada':                 'assets/logos/tdi_la_tablada.png',
  'Santa Fe Rugby':             'assets/logos/tdi_santa_fe_rugby.png',
  'Estudiantes de Paraná':      'assets/logos/tdi_estudiantes_parana.png',
  'CURNE':                      'assets/logos/tdi_curne.png',
};

// ─── Logos de selecciones / federaciones internacionales ──────────────────────

const Map<String, String> _countryLogoUrls = {
  // Seis Naciones
  'Ireland':       'assets/logos/nat_ireland.png',
  'France':        'assets/logos/nat_france.png',
  'England':       'assets/logos/nat_england.png',
  'Scotland':      'assets/logos/nat_scotland.png',
  'Wales':         'assets/logos/nat_wales.png',
  'Italy':         'assets/logos/nat_italy.png',
  // Rugby Championship
  'Argentina':     'assets/logos/nat_argentina.png',
  'Australia':     'assets/logos/nat_australia.png',
  'New Zealand':   'assets/logos/nat_new_zealand.png',
  'South Africa':  'assets/logos/nat_south_africa.png',
  // Circuito 7s y otros
  'Fiji':          'assets/logos/nat_fiji.png',
  'USA':           'assets/logos/nat_usa.png',
  'United States': 'assets/logos/nat_usa.png',
  'Canada':        'assets/logos/nat_canada.png',
  'Uruguay':       'assets/logos/nat_uruguay.png',
  'Japan':         'assets/logos/nat_japan.png',
  'Spain':         'assets/logos/nat_spain.png',
  'Portugal':      'assets/logos/nat_portugal.png',
  'Georgia':       'assets/logos/nat_georgia.png',
  'Romania':       'assets/logos/nat_romania.png',
  'Hong Kong':     'assets/logos/nat_hong_kong.png',
  'Chile':         'assets/logos/nat_chile.png',
  'Kenya':         'assets/logos/nat_kenya.png',
  'Samoa':         'assets/logos/nat_samoa.png',
  'Tonga':         'assets/logos/nat_tonga.png',
  'Korea':         'assets/logos/nat_korea.png',
  'Great Britain': 'assets/logos/nat_great_britain.png',
  'Brazil':        'assets/logos/nat_brazil.png',
  'Germany':       'assets/logos/nat_germany.png',
  'Netherlands':   'assets/logos/nat_netherlands.png',
  'Belgium':       'assets/logos/nat_belgium.png',
  'Russia':        'assets/logos/nat_russia.png',
  'Zimbabwe':      'assets/logos/nat_zimbabwe.png',
  'Namibia':       'assets/logos/nat_namibia.png',
  'Uganda':        'assets/logos/nat_uganda.png',
};

/// Devuelve el path local del logo de un club o selección, o null si no hay.
String? clubLogo(String teamName) {
  final exact = clubLogoUrls[teamName] ?? _countryLogoUrls[teamName];
  if (exact != null) return exact;
  const suffixes = [' 7s', ' PS', ' Eagles', ' Academical', ' Rugby', ' RFC'];
  for (final s in suffixes) {
    if (teamName.endsWith(s)) {
      final base = teamName.substring(0, teamName.length - s.length);
      final found = clubLogoUrls[base] ?? _countryLogoUrls[base];
      if (found != null) return found;
    }
  }
  return null;
}

// ─── Logos de ligas / torneos ────────────────────────────────────────────────

const Map<String, String> leagueLogoUrls = {
  'Top 14':                    'assets/logos/league_top14.png',
  'Premiership':               'assets/logos/league_premiership.png',
  'United Rugby Championship': 'assets/logos/league_urc.png',
  'Champions Cup':             'assets/logos/league_champions_cup.png',
  'Challenge Cup':             'assets/logos/league_challenge_cup.png',
  'Super Rugby Pacific':       'assets/logos/league_srp.png',
  'Seis Naciones':             'assets/logos/league_6nations.png',
  'The Rugby Championship':    'assets/logos/league_rugby_champ.png',
  'Super Rugby Américas':      'assets/logos/league_sra.png',
  'URBA Top 14':               'assets/logos/league_urba.png',
};

const Map<String, String> leagueLogoAssets = {
  'Nations Championship': 'assets/logos/nations_championship.png',
};

/// Devuelve el path local del logo de una liga/torneo, o null si no hay.
String? leagueLogo(String leagueName) => leagueLogoUrls[leagueName];

/// Devuelve el path de asset local del logo de una liga/torneo, o null si no hay.
String? leagueLogoAsset(String leagueName) => leagueLogoAssets[leagueName];
