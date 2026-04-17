// URLs de logos para folders, clubes y ligas.
// Fuente: Wikimedia Commons / Wikipedia / TheSportsDB (licencia pública).

// ─── Logos de carpetas (home) ─────────────────────────────────────────────

const Map<String, String> folderLogoUrls = {
  'URBA':        'https://upload.wikimedia.org/wikipedia/en/thumb/1/1f/Urba_logo.png/200px-Urba_logo.png',
  'Circuito 7s': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/SVNS_Logo_%282023%29.svg/200px-SVNS_Logo_%282023%29.svg.png',
};

// Logos locales (assets SVG) — usan SvgPicture.asset en vez de Image.network
const Map<String, String> folderLogoAssets = {
  'Torneo del Interior': 'assets/logos/torneo_interior.svg',
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
  'Buenos Aires CRC':    'https://upload.wikimedia.org/wikipedia/en/thumb/1/17/Buenos_Aires_CRC_Crest.svg/120px-Buenos_Aires_CRC_Crest.svg.png',
  'Regatas Bella Vista': 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Regatas_BV_flaglogo.svg/120px-Regatas_BV_flaglogo.svg.png',
  'La Plata':            'https://upload.wikimedia.org/wikipedia/en/thumb/d/d7/La_Plata_Rugby_Club_Crest.svg/120px-La_Plata_Rugby_Club_Crest.svg.png',

  // ── Super Rugby Pacific ────────────────────────────────────────────────
  'Crusaders':           'https://upload.wikimedia.org/wikipedia/en/thumb/b/bd/Crusaders_%28rugby_union%29_logo.png/200px-Crusaders_%28rugby_union%29_logo.png',
  'Blues':               'https://upload.wikimedia.org/wikipedia/en/thumb/c/cd/Auckland_Blues_rugby_logo.webp/200px-Auckland_Blues_rugby_logo.webp.png',
  'Chiefs':              'https://upload.wikimedia.org/wikipedia/en/thumb/8/87/Chiefs_rugby_union_logo.jpg/200px-Chiefs_rugby_union_logo.jpg',
  'Highlanders':         'https://upload.wikimedia.org/wikipedia/en/thumb/a/a7/Highlanders_NZ_rugby_union_team_logo.svg/200px-Highlanders_NZ_rugby_union_team_logo.svg.png',
  'Hurricanes':          'https://upload.wikimedia.org/wikipedia/en/thumb/2/28/Wellington_Hurricanes_logo.png/200px-Wellington_Hurricanes_logo.png',
  'Brumbies':            'https://upload.wikimedia.org/wikipedia/en/thumb/5/53/Brumbies_Rugby_logo.svg/200px-Brumbies_Rugby_logo.svg.png',
  'Waratahs':            'https://upload.wikimedia.org/wikipedia/en/thumb/6/6f/Waratahs_logo.svg/200px-Waratahs_logo.svg.png',
  'NSW Waratahs':        'https://upload.wikimedia.org/wikipedia/en/thumb/6/6f/Waratahs_logo.svg/200px-Waratahs_logo.svg.png',
  'Reds':                'https://upload.wikimedia.org/wikipedia/en/thumb/e/e1/QLD_reds_logo.svg/200px-QLD_reds_logo.svg.png',
  'Queensland Reds':     'https://upload.wikimedia.org/wikipedia/en/thumb/e/e1/QLD_reds_logo.svg/200px-QLD_reds_logo.svg.png',
  'Western Force':       'https://upload.wikimedia.org/wikipedia/en/thumb/0/01/Western_force_rugby_logo.png/200px-Western_force_rugby_logo.png',
  'Moana Pasifika':      'https://upload.wikimedia.org/wikipedia/en/thumb/2/20/Moana_Pasifika_logo.jpg/200px-Moana_Pasifika_logo.jpg',
  'Fijian Drua':         'https://upload.wikimedia.org/wikipedia/en/thumb/9/9c/FijianDruaLogo.svg/200px-FijianDruaLogo.svg.png',

  // ── United Rugby Championship ──────────────────────────────────────────
  'Zebre Parma':         'https://upload.wikimedia.org/wikipedia/en/thumb/5/5d/Zebre_parma_logo23.png/200px-Zebre_parma_logo23.png',
  'Zebre':               'https://upload.wikimedia.org/wikipedia/en/thumb/5/5d/Zebre_parma_logo23.png/200px-Zebre_parma_logo23.png',
  'Cardiff Rugby':       'https://upload.wikimedia.org/wikipedia/en/thumb/1/1f/Cardiff_Rugby_logo_%282021%29.jpg/200px-Cardiff_Rugby_logo_%282021%29.jpg',
  'Cardiff':             'https://upload.wikimedia.org/wikipedia/en/thumb/1/1f/Cardiff_Rugby_logo_%282021%29.jpg/200px-Cardiff_Rugby_logo_%282021%29.jpg',
  'Benetton Rugby':      'https://upload.wikimedia.org/wikipedia/en/thumb/a/ac/Benetton_rugby.svg/200px-Benetton_rugby.svg.png',
  'Benetton':            'https://upload.wikimedia.org/wikipedia/en/thumb/a/ac/Benetton_rugby.svg/200px-Benetton_rugby.svg.png',
  'Dragons RFC':         'https://upload.wikimedia.org/wikipedia/en/thumb/9/9b/Dragons_RFC_logo.png/200px-Dragons_RFC_logo.png',
  'Dragons':             'https://upload.wikimedia.org/wikipedia/en/thumb/9/9b/Dragons_RFC_logo.png/200px-Dragons_RFC_logo.png',
  'Scarlets':            'https://upload.wikimedia.org/wikipedia/en/thumb/0/07/Scarlets_logo.svg/200px-Scarlets_logo.svg.png',
  'Edinburgh Rugby':     'https://upload.wikimedia.org/wikipedia/en/thumb/e/e3/Edinburgh_Rugby_logo_2018.svg/200px-Edinburgh_Rugby_logo_2018.svg.png',
  'Edinburgh':           'https://upload.wikimedia.org/wikipedia/en/thumb/e/e3/Edinburgh_Rugby_logo_2018.svg/200px-Edinburgh_Rugby_logo_2018.svg.png',
  'Ospreys':             'https://upload.wikimedia.org/wikipedia/en/thumb/2/2c/Ospreys_Rugby_logo.svg/200px-Ospreys_Rugby_logo.svg.png',

  // ── Super Rugby Américas / URC ────────────────────────────────────────
  'Cobras':              'https://upload.wikimedia.org/wikipedia/en/thumb/e/ec/Cobras_xv_logo.png/200px-Cobras_xv_logo.png',
  'Brasil Cobras':       'https://upload.wikimedia.org/wikipedia/en/thumb/e/ec/Cobras_xv_logo.png/200px-Cobras_xv_logo.png',
  'Cobras Brasil':       'https://upload.wikimedia.org/wikipedia/en/thumb/e/ec/Cobras_xv_logo.png/200px-Cobras_xv_logo.png',
  'Cobras XV':           'https://upload.wikimedia.org/wikipedia/en/thumb/e/ec/Cobras_xv_logo.png/200px-Cobras_xv_logo.png',
  'Black Lions':         'https://upload.wikimedia.org/wikipedia/en/thumb/f/f3/Black_lion_rugby_logo.png/200px-Black_lion_rugby_logo.png',
  'Black Lion':          'https://upload.wikimedia.org/wikipedia/en/thumb/f/f3/Black_lion_rugby_logo.png/200px-Black_lion_rugby_logo.png',
  'Cheetahs':            'https://upload.wikimedia.org/wikipedia/en/thumb/d/d2/Logo_Cheetahs_Rugby.svg/200px-Logo_Cheetahs_Rugby.svg.png',
  'Free State Cheetahs': 'https://upload.wikimedia.org/wikipedia/en/thumb/d/d2/Logo_Cheetahs_Rugby.svg/200px-Logo_Cheetahs_Rugby.svg.png',

  // ── URC — irlandeses / escoceses ──────────────────────────────────────
  'Leinster':            'https://upload.wikimedia.org/wikipedia/en/thumb/a/a4/LeinsterRugby_logo_2019.svg/200px-LeinsterRugby_logo_2019.svg.png',
  'Munster':             'https://upload.wikimedia.org/wikipedia/en/thumb/f/fb/Munster_Rugby_logo.svg/200px-Munster_Rugby_logo.svg.png',
  'Ulster':              'https://upload.wikimedia.org/wikipedia/en/thumb/c/c0/Ulster_Rugby_logo.svg/200px-Ulster_Rugby_logo.svg.png',
  'Connacht':            'https://upload.wikimedia.org/wikipedia/en/thumb/6/67/ConnachtRugby_2017logo.svg/200px-ConnachtRugby_2017logo.svg.png',
  'Glasgow Warriors':    'https://upload.wikimedia.org/wikipedia/en/thumb/0/06/Glasgow_Warriors_Logo.svg/200px-Glasgow_Warriors_Logo.svg.png',

  // ── URC — sudafricanos ────────────────────────────────────────────────
  'Stormers':            'https://upload.wikimedia.org/wikipedia/en/thumb/e/e3/Stormers_logo.svg/200px-Stormers_logo.svg.png',
  'Lions':               'https://upload.wikimedia.org/wikipedia/en/thumb/e/e6/Lions_rugby_logo_2007.png/200px-Lions_rugby_logo_2007.png',
  'Bulls':               'https://upload.wikimedia.org/wikipedia/en/thumb/c/cf/Bulls_rugby_logo.jpg/200px-Bulls_rugby_logo.jpg',
  'Sharks':              'https://upload.wikimedia.org/wikipedia/en/thumb/9/9f/Sharks_rugby_union_logo.png/200px-Sharks_rugby_union_logo.png',

  // ── Top 14 francés ───────────────────────────────────────────────────
  'Stade Toulousain':    'https://upload.wikimedia.org/wikipedia/en/thumb/9/93/StadeToulousainLogo.svg/200px-StadeToulousainLogo.svg.png',
  'Bordeaux Bèglès':     'https://upload.wikimedia.org/wikipedia/en/thumb/b/b1/UnionBordeauxBeglesLogo.svg/200px-UnionBordeauxBeglesLogo.svg.png',
  'Bordeaux Begles':     'https://upload.wikimedia.org/wikipedia/en/thumb/b/b1/UnionBordeauxBeglesLogo.svg/200px-UnionBordeauxBeglesLogo.svg.png',
  'Stade Francais Paris':'https://upload.wikimedia.org/wikipedia/en/thumb/e/ea/Stade_francais_logo18.svg/200px-Stade_francais_logo18.svg.png',
  'Stade Français Paris':'https://upload.wikimedia.org/wikipedia/en/thumb/e/ea/Stade_francais_logo18.svg/200px-Stade_francais_logo18.svg.png',
  'Montpellier':         'https://upload.wikimedia.org/wikipedia/en/thumb/d/d9/Logo_Montpellier_H%C3%A9rault_rugby_2013.svg/200px-Logo_Montpellier_H%C3%A9rault_rugby_2013.svg.png',
  'Clermont':            'https://upload.wikimedia.org/wikipedia/en/thumb/0/03/ASMClermontLogo.svg/200px-ASMClermontLogo.svg.png',
  'Racing 92':           'https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/Racing_92_%28logo%29.svg/200px-Racing_92_%28logo%29.svg.png',
  'Castres Olympique':   'https://upload.wikimedia.org/wikipedia/en/thumb/b/bd/Castres_olympique_badge.png/200px-Castres_olympique_badge.png',
  'Stade Rochelais':     'https://upload.wikimedia.org/wikipedia/en/thumb/e/e2/StadeRochelaisLogo.svg/200px-StadeRochelaisLogo.svg.png',
  'Aviron Bayonnais':    'https://r2.thesportsdb.com/images/media/team/badge/z0fq591714808782.png',
  'Stade Bayonnais':     'https://r2.thesportsdb.com/images/media/team/badge/z0fq591714808782.png',
  'RC Toulonnais':       'https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/RCT_LOGO.png/200px-RCT_LOGO.png',
  'RC Toulon':           'https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/RCT_LOGO.png/200px-RCT_LOGO.png',
  'Lyon':                'https://upload.wikimedia.org/wikipedia/en/thumb/f/fd/Lyon_Olympique_Universitaire.svg/200px-Lyon_Olympique_Universitaire.svg.png',
  'USA Perpignan':       'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Usa_perpignan_badge.png/200px-Usa_perpignan_badge.png',
  'Section Paloise':     'https://upload.wikimedia.org/wikipedia/en/thumb/8/8a/Section_Paloise_2024.png/200px-Section_Paloise_2024.png',
  'Montauban':           'https://upload.wikimedia.org/wikipedia/en/thumb/3/3f/Us_montauban.png/200px-Us_montauban.png',

  // ── Premiership inglesa ───────────────────────────────────────────────
  'Northampton Saints':  'https://upload.wikimedia.org/wikipedia/en/thumb/7/7e/Northampton_Saints_Logo.svg/200px-Northampton_Saints_Logo.svg.png',
  'Bath':                'https://upload.wikimedia.org/wikipedia/en/thumb/e/ef/Bath_Rugby_logo.png/200px-Bath_Rugby_logo.png',
  'Leicester Tigers':    'https://upload.wikimedia.org/wikipedia/en/thumb/a/ac/Leicester_Tigers_logo.svg/200px-Leicester_Tigers_logo.svg.png',
  'Exeter Chiefs':       'https://upload.wikimedia.org/wikipedia/en/thumb/b/b7/Exeter_Chiefs_new_logo_2022.png/200px-Exeter_Chiefs_new_logo_2022.png',
  'Bristol':             'https://upload.wikimedia.org/wikipedia/en/thumb/0/02/Bristol_Bears_logo.svg/200px-Bristol_Bears_logo.svg.png',
  'Bristol Bears':       'https://upload.wikimedia.org/wikipedia/en/thumb/0/02/Bristol_Bears_logo.svg/200px-Bristol_Bears_logo.svg.png',
  'Saracens':            'https://upload.wikimedia.org/wikipedia/en/thumb/3/3f/Saracens_F.C._Logo.svg/200px-Saracens_F.C._Logo.svg.png',
  'Sale Sharks':         'https://upload.wikimedia.org/wikipedia/en/thumb/5/5e/Sale_Sharks_logo.svg/200px-Sale_Sharks_logo.svg.png',
  'Gloucester':          'https://upload.wikimedia.org/wikipedia/en/thumb/8/8c/Gloucester_Rugby_%282018%29_logo.svg/200px-Gloucester_Rugby_%282018%29_logo.svg.png',
  'Harlequins':          'https://upload.wikimedia.org/wikipedia/en/thumb/9/92/Harlequin_FC_logo.svg/200px-Harlequin_FC_logo.svg.png',
  'Newcastle Red Bulls': 'https://upload.wikimedia.org/wikipedia/en/thumb/8/80/Newcastle_Red_Bulls_logo.png/200px-Newcastle_Red_Bulls_logo.png',
  'Newcastle Falcons':   'https://upload.wikimedia.org/wikipedia/en/thumb/8/80/Newcastle_Red_Bulls_logo.png/200px-Newcastle_Red_Bulls_logo.png',

  // ── Torneo del Interior (TDI) ─────────────────────────────────────────────
  'Tucumán Rugby':              'https://upload.wikimedia.org/wikipedia/en/thumb/2/25/Tucuman_Rugby_Club_Crest.svg/200px-Tucuman_Rugby_Club_Crest.svg.png',
  'Gimnasia y Esgrima de Rosario': 'https://upload.wikimedia.org/wikipedia/en/thumb/5/59/Club_ger_logo.png/200px-Club_ger_logo.png',
  'Marista RC':                 'https://upload.wikimedia.org/wikipedia/en/thumb/f/f5/Marista_rc_escudo.png/200px-Marista_rc_escudo.png',
  'Duendes RC':                 'https://upload.wikimedia.org/wikipedia/en/thumb/d/d0/Duendes_Rugby_Club_Crest.svg/200px-Duendes_Rugby_Club_Crest.svg.png',
  'Jockey Club de Rosario':     'https://upload.wikimedia.org/wikipedia/en/thumb/7/7a/Jockey_rosario_logo.png/200px-Jockey_rosario_logo.png',
  'Tala RC':                    'https://upload.wikimedia.org/wikipedia/en/thumb/0/08/Tala_Rugby_Club_Crest.svg/200px-Tala_Rugby_Club_Crest.svg.png',
  'Córdoba Athletic':           'https://upload.wikimedia.org/wikipedia/en/thumb/3/39/Cordoba_Athletic_Club_Crest.svg/200px-Cordoba_Athletic_Club_Crest.svg.png',
  'Universitario de Córdoba':   'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Universitario_cba_logo.svg/200px-Universitario_cba_logo.svg.png',
  'Jockey Club de Córdoba':     'https://upload.wikimedia.org/wikipedia/en/thumb/b/b1/Jockey_club_cba_logo.png/200px-Jockey_club_cba_logo.png',
  'La Tablada':                 'https://upload.wikimedia.org/wikipedia/en/thumb/7/7f/Club_La_Tablada_Crest.svg/200px-Club_La_Tablada_Crest.svg.png',
  'Santa Fe Rugby':             'https://upload.wikimedia.org/wikipedia/en/thumb/9/98/Santa_Fe_Rugby_Club_Crest.svg/200px-Santa_Fe_Rugby_Club_Crest.svg.png',
  'Estudiantes de Paraná':      'https://upload.wikimedia.org/wikipedia/en/thumb/8/87/Estudiantes_parana_logo.png/200px-Estudiantes_parana_logo.png',
  'CURNE':                      'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/Escudo_CURNE.png/200px-Escudo_CURNE.png',
};

// ─── Logos de selecciones / federaciones internacionales ──────────────────────
// Fuente: flagcdn.com (banderas de alta calidad, dominio público)

const Map<String, String> _countryLogoUrls = {
  // Seis Naciones — escudos de federación
  'Ireland':       'https://upload.wikimedia.org/wikipedia/en/thumb/e/e9/Irfu_jersey_logo.svg/200px-Irfu_jersey_logo.svg.png',
  'France':        'https://upload.wikimedia.org/wikipedia/en/thumb/1/1f/Logo_XV_de_France_masculin_2019.png/200px-Logo_XV_de_France_masculin_2019.png',
  'England':       'https://upload.wikimedia.org/wikipedia/en/thumb/3/39/England_national_rugby_team_logo.svg/200px-England_national_rugby_team_logo.svg.png',
  'Scotland':      'https://upload.wikimedia.org/wikipedia/en/thumb/a/a2/Scotland_national_rugby_union_team_logo.png/200px-Scotland_national_rugby_union_team_logo.png',
  'Wales':         'https://upload.wikimedia.org/wikipedia/en/thumb/d/d6/Welsh_Rugby_Union_logo.svg/200px-Welsh_Rugby_Union_logo.svg.png',
  'Italy':         'https://upload.wikimedia.org/wikipedia/en/thumb/b/bb/Italian_Rugby_Federation_logo.svg/200px-Italian_Rugby_Federation_logo.svg.png',
  // Rugby Championship — escudos de federación
  'Argentina':     'https://upload.wikimedia.org/wikipedia/en/thumb/7/74/Los_pumas_argentina_logo23.png/200px-Los_pumas_argentina_logo23.png',
  'Australia':     'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Wallabies_Vertical_Primary_RGB.svg/200px-Wallabies_Vertical_Primary_RGB.svg.png',
  'New Zealand':   'https://upload.wikimedia.org/wikipedia/en/thumb/f/fb/All_Blacks_logo.svg/200px-All_Blacks_logo.svg.png',
  'South Africa':  'https://upload.wikimedia.org/wikipedia/en/thumb/8/83/South_Africa_national_rugby_union_team.svg/200px-South_Africa_national_rugby_union_team.svg.png',
  // Circuito 7s — escudos de federación
  'Fiji':          'https://upload.wikimedia.org/wikipedia/en/thumb/e/e3/Logo_Fiji_Rugby_2019.svg/200px-Logo_Fiji_Rugby_2019.svg.png',
  'USA':           'https://upload.wikimedia.org/wikipedia/en/thumb/e/e0/United_States_national_rugby_union_team_logo.png/200px-United_States_national_rugby_union_team_logo.png',
  'United States': 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e0/United_States_national_rugby_union_team_logo.png/200px-United_States_national_rugby_union_team_logo.png',
  'Canada':        'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Rugby_Canada_logo.svg/200px-Rugby_Canada_logo.svg.png',
  'Uruguay':       'https://upload.wikimedia.org/wikipedia/en/thumb/e/e1/Los_teros_logo.png/200px-Los_teros_logo.png',
  'Japan':         'https://upload.wikimedia.org/wikipedia/en/thumb/3/37/Logo_JRFU.svg/200px-Logo_JRFU.svg.png',
  'Spain':         'https://upload.wikimedia.org/wikipedia/en/thumb/f/f0/Spain_Rugby_logo.svg/200px-Spain_Rugby_logo.svg.png',
  'Portugal':      'https://upload.wikimedia.org/wikipedia/en/thumb/7/7e/Portuguese_Rugby.png/200px-Portuguese_Rugby.png',
  'Georgia':       'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/Georgian_RU_logo_2023.png/200px-Georgian_RU_logo_2023.png',
  'Romania':       'https://upload.wikimedia.org/wikipedia/en/thumb/7/77/Romania_national_rugby_union_team_logo.png/200px-Romania_national_rugby_union_team_logo.png',
  'Hong Kong':     'https://upload.wikimedia.org/wikipedia/en/thumb/0/04/Hong_Kong_China_Rugby_Union.svg/200px-Hong_Kong_China_Rugby_Union.svg.png',
  'Chile':         'https://upload.wikimedia.org/wikipedia/en/thumb/3/3d/Condores_Chile_Rugby.png/200px-Condores_Chile_Rugby.png',
  // Con bandera (sin logo de federación disponible)
  'Kenya':         'https://flagcdn.com/w80/ke.png',
  'Samoa':         'https://flagcdn.com/w80/ws.png',
  'Tonga':         'https://flagcdn.com/w80/to.png',
  'Korea':         'https://flagcdn.com/w80/kr.png',
  'Great Britain': 'https://flagcdn.com/w80/gb.png',
  'Brazil':        'https://flagcdn.com/w80/br.png',
  'Germany':       'https://flagcdn.com/w80/de.png',
  'Netherlands':   'https://flagcdn.com/w80/nl.png',
  'Belgium':       'https://flagcdn.com/w80/be.png',
  'Russia':        'https://flagcdn.com/w80/ru.png',
  'Zimbabwe':      'https://flagcdn.com/w80/zw.png',
  'Namibia':       'https://flagcdn.com/w80/na.png',
  'Uganda':        'https://flagcdn.com/w80/ug.png',
};

/// Devuelve la URL del logo de un club o selección, o null si no hay.
/// Intenta variantes del nombre stripeando sufijos comunes de la API.
String? clubLogo(String teamName) {
  final exact = clubLogoUrls[teamName] ?? _countryLogoUrls[teamName];
  if (exact != null) return exact;
  // Sufijos que la API agrega y no están en nuestro mapa
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

// ─── Logos de ligas / torneos (home tiles) ────────────────────────────────
// Fuente: Wikimedia Commons / Wikipedia (CORS habilitado, dominio público)

const Map<String, String> leagueLogoUrls = {
  'Top 14':                    'https://upload.wikimedia.org/wikipedia/en/thumb/d/dd/Logo_Top14_2012.png/200px-Logo_Top14_2012.png',
  'Premiership':               'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/Logo_of_Premiership_Rugby_2018.svg/330px-Logo_of_Premiership_Rugby_2018.svg.png',
  'United Rugby Championship': 'https://upload.wikimedia.org/wikipedia/en/thumb/0/07/United_Rugby_Championship_logo.svg/200px-United_Rugby_Championship_logo.svg.png',
  'Champions Cup':             'https://upload.wikimedia.org/wikipedia/en/thumb/6/65/InvestecChampionsCupLogo.svg/250px-InvestecChampionsCupLogo.svg.png',
  'Challenge Cup':             'https://upload.wikimedia.org/wikipedia/en/thumb/0/03/EPCRchallengecuplogo.svg/250px-EPCRchallengecuplogo.svg.png',
  'Super Rugby Pacific':       'https://upload.wikimedia.org/wikipedia/en/2/25/Super_Rugby_Pacific_logo.png',
  'Seis Naciones':             'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/SixNationsRugbyCup.svg/250px-SixNationsRugbyCup.svg.png',
  'The Rugby Championship':    'https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/The_Rugby_Championship_logo_%28white_background%29.png/250px-The_Rugby_Championship_logo_%28white_background%29.png',
  'Super Rugby Américas':      'https://upload.wikimedia.org/wikipedia/en/2/27/Super_Rugby_Americas_logo.png',
  'URBA Top 14':               'https://upload.wikimedia.org/wikipedia/en/thumb/1/1f/Urba_logo.png/200px-Urba_logo.png',
};

// Logos de ligas guardados como assets locales (más confiables que network)
const Map<String, String> leagueLogoAssets = {
  'Nations Championship': 'assets/logos/nations_championship.png',
};

/// Devuelve la URL de red del logo de una liga/torneo, o null si no hay.
String? leagueLogo(String leagueName) => leagueLogoUrls[leagueName];

/// Devuelve el path de asset local del logo de una liga/torneo, o null si no hay.
String? leagueLogoAsset(String leagueName) => leagueLogoAssets[leagueName];
