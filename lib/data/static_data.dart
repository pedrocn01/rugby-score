/// Datos estáticos de ligas locales y tablas que la API no devuelve.
class StaticDataService {
  static List<dynamic> getMatches(String league) {
    return switch (league) {
      'Nations Championship' => _nationsChampionshipMatches,
      'TDI A 2026'           => _tdiA2026Matches,
      _ => [],
    };
  }

  /// Fixtures que la API no devuelve pero sí deberían estar.
  /// Se inyectan sobre la respuesta de la API evitando duplicados.
  static List<dynamic> getSupplementalMatches(String league) {
    return switch (league) {
      'Champions Cup' => _champsCupSupplemental,
      'Challenge Cup' => _challengeCupSupplemental,
      _ => [],
    };
  }

  static List<List<dynamic>> getStandings(String league) {
    return switch (league) {
      'Champions Cup' => [_champsCupGrupoA, _champsCupGrupoB, _champsCupGrupoC, _champsCupGrupoD],
      'Challenge Cup' => [_challengeCupGrupoA, _challengeCupGrupoB, _challengeCupGrupoC],
      'TDI A 2026'    => [_tdiZona1Standings, _tdiZona2Standings, _tdiZona3Standings, _tdiZona4Standings],
      _ => [],
    };
  }

  // ── Fixtures suplementarios (la API no los devuelve) ─────────────────────

  static final List<dynamic> _champsCupSupplemental = [
    {
      'id': 'static_champs_sf_bor_bath',
      'week': 'semi-finals',
      'date': '2026-05-03T14:00:00+00:00',
      'timestamp': 1777816800,
      'status': {'short': 'NS'},
      'teams': {
        'home': {'name': 'Bordeaux Bèglès'},
        'away': {'name': 'Bath'},
      },
      'scores': {'home': null, 'away': null},
    },
  ];

  static final List<dynamic> _challengeCupSupplemental = [
    {
      'id': 'static_challenge_sf_ulster_exeter',
      'week': 'semi-finals',
      'date': '2026-05-02T16:30:00+00:00',
      'timestamp': 1777739400,
      'status': {'short': 'NS'},
      'teams': {
        'home': {'name': 'Ulster'},
        'away': {'name': 'Exeter Chiefs'},
      },
      'scores': {'home': null, 'away': null},
    },
  ];

  // ── CHAMPIONS CUP — tablas de grupo ──────────────────────────────────────

  static final List<dynamic> _champsCupGrupoA = [
    {'position':1,'team':{'name':'Bordeaux Bèglès'},    'games':{'played':4,'win':{'total':4},'draw':{'total':0},'lose':{'total':0}},'points':19,'description':'Playoffs'},
    {'position':2,'team':{'name':'Bristol'},             'games':{'played':4,'win':{'total':3},'draw':{'total':0},'lose':{'total':1}},'points':14,'description':'Playoffs'},
    {'position':3,'team':{'name':'Northampton Saints'},  'games':{'played':4,'win':{'total':3},'draw':{'total':0},'lose':{'total':1}},'points':14,'description':'Playoffs'},
    {'position':4,'team':{'name':'Section Paloise'},     'games':{'played':4,'win':{'total':1},'draw':{'total':0},'lose':{'total':3}},'points':6, 'description':'Playoffs'},
    {'position':5,'team':{'name':'Bulls'},               'games':{'played':4,'win':{'total':1},'draw':{'total':0},'lose':{'total':3}},'points':4, 'description':'Challenge Cup'},
    {'position':6,'team':{'name':'Scarlets'},            'games':{'played':4,'win':{'total':0},'draw':{'total':0},'lose':{'total':4}},'points':1, 'description':null},
  ];

  static final List<dynamic> _champsCupGrupoB = [
    {'position':1,'team':{'name':'Glasgow Warriors'},  'games':{'played':4,'win':{'total':4},'draw':{'total':0},'lose':{'total':0}},'points':16,'description':'Playoffs'},
    {'position':2,'team':{'name':'Stade Toulousain'},  'games':{'played':4,'win':{'total':2},'draw':{'total':0},'lose':{'total':2}},'points':12,'description':'Playoffs'},
    {'position':3,'team':{'name':'Saracens'},          'games':{'played':4,'win':{'total':2},'draw':{'total':0},'lose':{'total':2}},'points':10,'description':'Playoffs'},
    {'position':4,'team':{'name':'Sharks'},            'games':{'played':4,'win':{'total':2},'draw':{'total':0},'lose':{'total':2}},'points':9, 'description':'Playoffs'},
    {'position':5,'team':{'name':'Sale Sharks'},       'games':{'played':4,'win':{'total':2},'draw':{'total':0},'lose':{'total':2}},'points':9, 'description':'Challenge Cup'},
    {'position':6,'team':{'name':'Clermont'},          'games':{'played':4,'win':{'total':0},'draw':{'total':0},'lose':{'total':4}},'points':0, 'description':null},
  ];

  static final List<dynamic> _champsCupGrupoC = [
    {'position':1,'team':{'name':'Leinster'},          'games':{'played':4,'win':{'total':4},'draw':{'total':0},'lose':{'total':0}},'points':17,'description':'Playoffs'},
    {'position':2,'team':{'name':'Harlequins'},        'games':{'played':4,'win':{'total':3},'draw':{'total':0},'lose':{'total':1}},'points':14,'description':'Playoffs'},
    {'position':3,'team':{'name':'Stormers'},          'games':{'played':4,'win':{'total':3},'draw':{'total':0},'lose':{'total':1}},'points':13,'description':'Playoffs'},
    {'position':4,'team':{'name':'Leicester Tigers'},  'games':{'played':4,'win':{'total':1},'draw':{'total':0},'lose':{'total':3}},'points':5, 'description':'Playoffs'},
    {'position':5,'team':{'name':'Stade Rochelais'},   'games':{'played':4,'win':{'total':1},'draw':{'total':0},'lose':{'total':3}},'points':5, 'description':'Challenge Cup'},
    {'position':6,'team':{'name':'Aviron Bayonnais'},  'games':{'played':4,'win':{'total':0},'draw':{'total':0},'lose':{'total':4}},'points':0, 'description':null},
  ];

  static final List<dynamic> _champsCupGrupoD = [
    {'position':1,'team':{'name':'Bath'},              'games':{'played':4,'win':{'total':3},'draw':{'total':0},'lose':{'total':1}},'points':15,'description':'Playoffs'},
    {'position':2,'team':{'name':'RC Toulonnais'},     'games':{'played':4,'win':{'total':3},'draw':{'total':0},'lose':{'total':1}},'points':13,'description':'Playoffs'},
    {'position':3,'team':{'name':'Castres Olympique'}, 'games':{'played':4,'win':{'total':2},'draw':{'total':0},'lose':{'total':2}},'points':8, 'description':'Playoffs'},
    {'position':4,'team':{'name':'Edinburgh'},         'games':{'played':4,'win':{'total':2},'draw':{'total':0},'lose':{'total':2}},'points':8, 'description':'Playoffs'},
    {'position':5,'team':{'name':'Munster'},           'games':{'played':4,'win':{'total':1},'draw':{'total':0},'lose':{'total':3}},'points':6, 'description':'Challenge Cup'},
    {'position':6,'team':{'name':'Gloucester'},        'games':{'played':4,'win':{'total':1},'draw':{'total':0},'lose':{'total':3}},'points':5, 'description':null},
  ];

  // ── CHALLENGE CUP — tablas de grupo ──────────────────────────────────────

  static final List<dynamic> _challengeCupGrupoA = [
    {'position':1,'team':{'name':'Montpellier'},  'games':{'played':4,'win':{'total':4},'draw':{'total':0},'lose':{'total':0}},'points':16,'description':'Playoffs'},
    {'position':2,'team':{'name':'Zebre'},        'games':{'played':4,'win':{'total':3},'draw':{'total':0},'lose':{'total':1}},'points':13,'description':'Playoffs'},
    {'position':3,'team':{'name':'Connacht'},     'games':{'played':4,'win':{'total':2},'draw':{'total':0},'lose':{'total':2}},'points':12,'description':'Playoffs'},
    {'position':4,'team':{'name':'Ospreys'},      'games':{'played':4,'win':{'total':2},'draw':{'total':0},'lose':{'total':2}},'points':10,'description':'Playoffs'},
    {'position':5,'team':{'name':'Black Lion'},   'games':{'played':4,'win':{'total':1},'draw':{'total':0},'lose':{'total':3}},'points':4, 'description':null},
    {'position':6,'team':{'name':'Montauban'},    'games':{'played':4,'win':{'total':0},'draw':{'total':0},'lose':{'total':4}},'points':1, 'description':null},
  ];

  static final List<dynamic> _challengeCupGrupoB = [
    {'position':1,'team':{'name':'Benetton'},           'games':{'played':4,'win':{'total':4},'draw':{'total':0},'lose':{'total':0}},'points':18,'description':'Playoffs'},
    {'position':2,'team':{'name':'Newcastle Red Bulls'}, 'games':{'played':4,'win':{'total':3},'draw':{'total':0},'lose':{'total':1}},'points':12,'description':'Playoffs'},
    {'position':3,'team':{'name':'Dragons'},             'games':{'played':4,'win':{'total':2},'draw':{'total':0},'lose':{'total':2}},'points':8, 'description':'Playoffs'},
    {'position':4,'team':{'name':'USA Perpignan'},       'games':{'played':4,'win':{'total':1},'draw':{'total':1},'lose':{'total':2}},'points':8, 'description':'Playoffs'},
    {'position':5,'team':{'name':'Lions'},               'games':{'played':4,'win':{'total':1},'draw':{'total':1},'lose':{'total':2}},'points':8, 'description':null},
    {'position':6,'team':{'name':'Lyon'},                'games':{'played':4,'win':{'total':0},'draw':{'total':0},'lose':{'total':4}},'points':1, 'description':null},
  ];

  static final List<dynamic> _challengeCupGrupoC = [
    {'position':1,'team':{'name':'Ulster'},              'games':{'played':4,'win':{'total':3},'draw':{'total':0},'lose':{'total':1}},'points':14,'description':'Playoffs'},
    {'position':2,'team':{'name':'Stade Français Paris'},'games':{'played':4,'win':{'total':3},'draw':{'total':0},'lose':{'total':1}},'points':14,'description':'Playoffs'},
    {'position':3,'team':{'name':'Exeter Chiefs'},       'games':{'played':4,'win':{'total':2},'draw':{'total':1},'lose':{'total':1}},'points':12,'description':'Playoffs'},
    {'position':4,'team':{'name':'Cardiff Rugby'},       'games':{'played':4,'win':{'total':2},'draw':{'total':0},'lose':{'total':2}},'points':8, 'description':'Playoffs'},
    {'position':5,'team':{'name':'Racing 92'},           'games':{'played':4,'win':{'total':1},'draw':{'total':1},'lose':{'total':2}},'points':6, 'description':null},
    {'position':6,'team':{'name':'Cheetahs'},            'games':{'played':4,'win':{'total':0},'draw':{'total':0},'lose':{'total':4}},'points':1, 'description':null},
  ];

  // ── NATIONS CHAMPIONSHIP 2026 ─────────────────────────────────────────────
  // Fixture scrapeado de Wikipedia. Sin API disponible aún.
  // Actualizar scores cuando se jueguen los partidos.
  static final List<dynamic> _nationsChampionshipMatches = [
    // ─── Ronda 1 — 4 julio 2026 ───────────────────────────────────────────
    {'week':'Ronda 1','date':'2026-07-04T06:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Japan'},'away':{'name':'Italy'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 1','date':'2026-07-04T05:05:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'New Zealand'},'away':{'name':'France'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 1','date':'2026-07-04T05:05:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Australia'},'away':{'name':'Ireland'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 1','date':'2026-07-04T14:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Fiji'},'away':{'name':'Wales'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 1','date':'2026-07-04T14:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'South Africa'},'away':{'name':'England'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 1','date':'2026-07-04T18:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Argentina'},'away':{'name':'Scotland'}},'scores':{'home':null,'away':null}},
    // ─── Ronda 2 — 11 julio 2026 ──────────────────────────────────────────
    {'week':'Ronda 2','date':'2026-07-11T06:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Japan'},'away':{'name':'Ireland'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 2','date':'2026-07-11T05:05:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'New Zealand'},'away':{'name':'Italy'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 2','date':'2026-07-11T05:05:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Australia'},'away':{'name':'France'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 2','date':'2026-07-11T14:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Fiji'},'away':{'name':'England'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 2','date':'2026-07-11T14:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'South Africa'},'away':{'name':'Scotland'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 2','date':'2026-07-11T18:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Argentina'},'away':{'name':'Wales'}},'scores':{'home':null,'away':null}},
    // ─── Ronda 3 — 18 julio 2026 ──────────────────────────────────────────
    {'week':'Ronda 3','date':'2026-07-18T06:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Japan'},'away':{'name':'France'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 3','date':'2026-07-18T05:05:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'New Zealand'},'away':{'name':'Ireland'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 3','date':'2026-07-18T05:05:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Australia'},'away':{'name':'Italy'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 3','date':'2026-07-18T14:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Fiji'},'away':{'name':'Scotland'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 3','date':'2026-07-18T14:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'South Africa'},'away':{'name':'Wales'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 3','date':'2026-07-18T18:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Argentina'},'away':{'name':'England'}},'scores':{'home':null,'away':null}},
    // ─── Ronda 4 — 6-8 noviembre 2026 ────────────────────────────────────
    {'week':'Ronda 4','date':'2026-11-06T20:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Ireland'},'away':{'name':'Argentina'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 4','date':'2026-11-06T20:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'France'},'away':{'name':'Fiji'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 4','date':'2026-11-07T20:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Wales'},'away':{'name':'Japan'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 4','date':'2026-11-07T20:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Italy'},'away':{'name':'South Africa'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 4','date':'2026-11-07T20:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Scotland'},'away':{'name':'New Zealand'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 4','date':'2026-11-08T16:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'England'},'away':{'name':'Australia'}},'scores':{'home':null,'away':null}},
    // ─── Ronda 5 — 13-15 noviembre 2026 ──────────────────────────────────
    {'week':'Ronda 5','date':'2026-11-13T21:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'France'},'away':{'name':'South Africa'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 5','date':'2026-11-14T20:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Wales'},'away':{'name':'New Zealand'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 5','date':'2026-11-14T20:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Italy'},'away':{'name':'Argentina'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 5','date':'2026-11-14T20:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Ireland'},'away':{'name':'Fiji'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 5','date':'2026-11-14T15:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'England'},'away':{'name':'Japan'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 5','date':'2026-11-15T15:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Scotland'},'away':{'name':'Australia'}},'scores':{'home':null,'away':null}},
    // ─── Ronda 6 — 21 noviembre 2026 ─────────────────────────────────────
    {'week':'Ronda 6','date':'2026-11-21T21:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'France'},'away':{'name':'Argentina'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 6','date':'2026-11-21T20:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Ireland'},'away':{'name':'South Africa'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 6','date':'2026-11-21T20:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Italy'},'away':{'name':'Fiji'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 6','date':'2026-11-21T20:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Scotland'},'away':{'name':'Japan'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 6','date':'2026-11-21T20:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Wales'},'away':{'name':'Australia'}},'scores':{'home':null,'away':null}},
    {'week':'Ronda 6','date':'2026-11-21T16:00:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'England'},'away':{'name':'New Zealand'}},'scores':{'home':null,'away':null}},
    // ─── Finales — 27-29 noviembre 2026 (Twickenham) ─────────────────────
    {'week':'Finales','date':'2026-11-27T16:40:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'11 Norte'},'away':{'name':'11 Sur'}},'scores':{'home':null,'away':null}},
    {'week':'Finales','date':'2026-11-27T20:10:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'5 Norte'},'away':{'name':'5 Sur'}},'scores':{'home':null,'away':null}},
    {'week':'Finales','date':'2026-11-28T13:10:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'9 Norte'},'away':{'name':'9 Sur'}},'scores':{'home':null,'away':null}},
    {'week':'Finales','date':'2026-11-28T16:40:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'3 Norte'},'away':{'name':'3 Sur'}},'scores':{'home':null,'away':null}},
    {'week':'Finales','date':'2026-11-29T13:10:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'7 Norte'},'away':{'name':'7 Sur'}},'scores':{'home':null,'away':null}},
    {'week':'Finales','date':'2026-11-29T16:40:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'1 Norte'},'away':{'name':'1 Sur'}},'scores':{'home':null,'away':null}},
  ];

  // ── TORNEO DEL INTERIOR A 2026 — Copa Zurich ─────────────────────────────

  static final List<dynamic> _tdiA2026Matches = [
    // ─── Fecha 1 — 28 de marzo ────────────────────────────────────────────
    {'week':'1','date':'2026-03-28T16:00:00-03:00','status':{'short':'FT'},'teams':{'home':{'name':'Gimnasia y Esgrima de Rosario'},'away':{'name':'Marista RC'}},'scores':{'home':29,'away':13},'periods':{'first':{'home':null,'away':null},'second':{'home':null,'away':null}}},
    {'week':'1','date':'2026-03-28T16:00:00-03:00','status':{'short':'FT'},'teams':{'home':{'name':'Tucumán Rugby'},'away':{'name':'Mendoza RC'}},'scores':{'home':54,'away':15},'periods':{'first':{'home':null,'away':null},'second':{'home':null,'away':null}}},
    {'week':'1','date':'2026-03-28T16:00:00-03:00','status':{'short':'FT'},'teams':{'home':{'name':'Estudiantes de Paraná'},'away':{'name':'Tala RC'}},'scores':{'home':26,'away':34},'periods':{'first':{'home':null,'away':null},'second':{'home':null,'away':null}}},
    {'week':'1','date':'2026-03-28T16:00:00-03:00','status':{'short':'FT'},'teams':{'home':{'name':'Urú Curé'},'away':{'name':'CURNE'}},'scores':{'home':35,'away':10},'periods':{'first':{'home':null,'away':null},'second':{'home':null,'away':null}}},
    {'week':'1','date':'2026-03-28T16:00:00-03:00','status':{'short':'FT'},'teams':{'home':{'name':'Universitario de Córdoba'},'away':{'name':'Jockey Club de Rosario'}},'scores':{'home':17,'away':44},'periods':{'first':{'home':null,'away':null},'second':{'home':null,'away':null}}},
    {'week':'1','date':'2026-03-28T16:00:00-03:00','status':{'short':'FT'},'teams':{'home':{'name':'Santa Fe Rugby'},'away':{'name':'Córdoba Athletic'}},'scores':{'home':37,'away':13},'periods':{'first':{'home':null,'away':null},'second':{'home':null,'away':null}}},
    {'week':'1','date':'2026-03-28T16:00:00-03:00','status':{'short':'FT'},'teams':{'home':{'name':'Jockey Club de Córdoba'},'away':{'name':'Duendes RC'}},'scores':{'home':22,'away':7},'periods':{'first':{'home':null,'away':null},'second':{'home':null,'away':null}}},
    {'week':'1','date':'2026-03-28T16:00:00-03:00','status':{'short':'FT'},'teams':{'home':{'name':'Old Resian'},'away':{'name':'La Tablada'}},'scores':{'home':22,'away':24},'periods':{'first':{'home':null,'away':null},'second':{'home':null,'away':null}}},
    // ─── Fecha 2 — 25 de abril ────────────────────────────────────────────
    {'week':'2','date':'2026-04-25T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Marista RC'},'away':{'name':'Tucumán Rugby'}},'scores':{'home':null,'away':null}},
    {'week':'2','date':'2026-04-25T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Mendoza RC'},'away':{'name':'Gimnasia y Esgrima de Rosario'}},'scores':{'home':null,'away':null}},
    {'week':'2','date':'2026-04-25T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Tala RC'},'away':{'name':'Urú Curé'}},'scores':{'home':null,'away':null}},
    {'week':'2','date':'2026-04-25T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'CURNE'},'away':{'name':'Estudiantes de Paraná'}},'scores':{'home':null,'away':null}},
    {'week':'2','date':'2026-04-25T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Jockey Club de Rosario'},'away':{'name':'Santa Fe Rugby'}},'scores':{'home':null,'away':null}},
    {'week':'2','date':'2026-04-25T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Córdoba Athletic'},'away':{'name':'Universitario de Córdoba'}},'scores':{'home':null,'away':null}},
    {'week':'2','date':'2026-04-25T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Duendes RC'},'away':{'name':'Old Resian'}},'scores':{'home':null,'away':null}},
    {'week':'2','date':'2026-04-25T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'La Tablada'},'away':{'name':'Jockey Club de Córdoba'}},'scores':{'home':null,'away':null}},
    // ─── Fecha 3 — 30 de mayo ─────────────────────────────────────────────
    {'week':'3','date':'2026-05-30T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Mendoza RC'},'away':{'name':'Marista RC'}},'scores':{'home':null,'away':null}},
    {'week':'3','date':'2026-05-30T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Tucumán Rugby'},'away':{'name':'Gimnasia y Esgrima de Rosario'}},'scores':{'home':null,'away':null}},
    {'week':'3','date':'2026-05-30T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'CURNE'},'away':{'name':'Tala RC'}},'scores':{'home':null,'away':null}},
    {'week':'3','date':'2026-05-30T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Urú Curé'},'away':{'name':'Estudiantes de Paraná'}},'scores':{'home':null,'away':null}},
    {'week':'3','date':'2026-05-30T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Córdoba Athletic'},'away':{'name':'Jockey Club de Rosario'}},'scores':{'home':null,'away':null}},
    {'week':'3','date':'2026-05-30T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Santa Fe Rugby'},'away':{'name':'Universitario de Córdoba'}},'scores':{'home':null,'away':null}},
    {'week':'3','date':'2026-05-30T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'La Tablada'},'away':{'name':'Duendes RC'}},'scores':{'home':null,'away':null}},
    {'week':'3','date':'2026-05-30T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Old Resian'},'away':{'name':'Jockey Club de Córdoba'}},'scores':{'home':null,'away':null}},
    // ─── Fecha 4 — 27 de junio ────────────────────────────────────────────
    {'week':'4','date':'2026-06-27T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Marista RC'},'away':{'name':'Mendoza RC'}},'scores':{'home':null,'away':null}},
    {'week':'4','date':'2026-06-27T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Gimnasia y Esgrima de Rosario'},'away':{'name':'Tucumán Rugby'}},'scores':{'home':null,'away':null}},
    {'week':'4','date':'2026-06-27T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Tala RC'},'away':{'name':'CURNE'}},'scores':{'home':null,'away':null}},
    {'week':'4','date':'2026-06-27T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Estudiantes de Paraná'},'away':{'name':'Urú Curé'}},'scores':{'home':null,'away':null}},
    {'week':'4','date':'2026-06-27T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Jockey Club de Rosario'},'away':{'name':'Córdoba Athletic'}},'scores':{'home':null,'away':null}},
    {'week':'4','date':'2026-06-27T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Universitario de Córdoba'},'away':{'name':'Santa Fe Rugby'}},'scores':{'home':null,'away':null}},
    {'week':'4','date':'2026-06-27T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Duendes RC'},'away':{'name':'La Tablada'}},'scores':{'home':null,'away':null}},
    {'week':'4','date':'2026-06-27T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Jockey Club de Córdoba'},'away':{'name':'Old Resian'}},'scores':{'home':null,'away':null}},
    // ─── Fecha 5 — 25 de julio ────────────────────────────────────────────
    {'week':'5','date':'2026-07-25T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Tucumán Rugby'},'away':{'name':'Marista RC'}},'scores':{'home':null,'away':null}},
    {'week':'5','date':'2026-07-25T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Gimnasia y Esgrima de Rosario'},'away':{'name':'Mendoza RC'}},'scores':{'home':null,'away':null}},
    {'week':'5','date':'2026-07-25T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Urú Curé'},'away':{'name':'Tala RC'}},'scores':{'home':null,'away':null}},
    {'week':'5','date':'2026-07-25T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Estudiantes de Paraná'},'away':{'name':'CURNE'}},'scores':{'home':null,'away':null}},
    {'week':'5','date':'2026-07-25T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Santa Fe Rugby'},'away':{'name':'Jockey Club de Rosario'}},'scores':{'home':null,'away':null}},
    {'week':'5','date':'2026-07-25T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Universitario de Córdoba'},'away':{'name':'Córdoba Athletic'}},'scores':{'home':null,'away':null}},
    {'week':'5','date':'2026-07-25T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Old Resian'},'away':{'name':'Duendes RC'}},'scores':{'home':null,'away':null}},
    {'week':'5','date':'2026-07-25T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Jockey Club de Córdoba'},'away':{'name':'La Tablada'}},'scores':{'home':null,'away':null}},
    // ─── Fecha 6 — 1 de agosto ────────────────────────────────────────────
    {'week':'6','date':'2026-08-01T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Marista RC'},'away':{'name':'Gimnasia y Esgrima de Rosario'}},'scores':{'home':null,'away':null}},
    {'week':'6','date':'2026-08-01T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Mendoza RC'},'away':{'name':'Tucumán Rugby'}},'scores':{'home':null,'away':null}},
    {'week':'6','date':'2026-08-01T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Tala RC'},'away':{'name':'Estudiantes de Paraná'}},'scores':{'home':null,'away':null}},
    {'week':'6','date':'2026-08-01T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'CURNE'},'away':{'name':'Urú Curé'}},'scores':{'home':null,'away':null}},
    {'week':'6','date':'2026-08-01T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Jockey Club de Rosario'},'away':{'name':'Universitario de Córdoba'}},'scores':{'home':null,'away':null}},
    {'week':'6','date':'2026-08-01T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Córdoba Athletic'},'away':{'name':'Santa Fe Rugby'}},'scores':{'home':null,'away':null}},
    {'week':'6','date':'2026-08-01T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'Duendes RC'},'away':{'name':'Jockey Club de Córdoba'}},'scores':{'home':null,'away':null}},
    {'week':'6','date':'2026-08-01T00:00:00-03:00','status':{'short':'NS'},'teams':{'home':{'name':'La Tablada'},'away':{'name':'Old Resian'}},'scores':{'home':null,'away':null}},
  ];

  // ─── Tablas TDI A 2026 — actualizadas tras Fecha 1 ───────────────────────
  // Criterio UAR: 4 pts victoria, 2 empate, 0 derrota. Top 2 clasifican a cuartos.

  static final List<dynamic> _tdiZona1Standings = [
    {'position':1,'team':{'name':'Tucumán Rugby'},               'games':{'played':1,'win':{'total':1},'draw':{'total':0},'lose':{'total':0}},'points':4,'description':'Playoffs'},
    {'position':2,'team':{'name':'Gimnasia y Esgrima de Rosario'},'games':{'played':1,'win':{'total':1},'draw':{'total':0},'lose':{'total':0}},'points':4,'description':'Playoffs'},
    {'position':3,'team':{'name':'Marista RC'},                  'games':{'played':1,'win':{'total':0},'draw':{'total':0},'lose':{'total':1}},'points':0,'description':null},
    {'position':4,'team':{'name':'Mendoza RC'},                  'games':{'played':1,'win':{'total':0},'draw':{'total':0},'lose':{'total':1}},'points':0,'description':null},
  ];

  static final List<dynamic> _tdiZona2Standings = [
    {'position':1,'team':{'name':'Urú Curé'},           'games':{'played':1,'win':{'total':1},'draw':{'total':0},'lose':{'total':0}},'points':4,'description':'Playoffs'},
    {'position':2,'team':{'name':'Tala RC'},             'games':{'played':1,'win':{'total':1},'draw':{'total':0},'lose':{'total':0}},'points':4,'description':'Playoffs'},
    {'position':3,'team':{'name':'Estudiantes de Paraná'},'games':{'played':1,'win':{'total':0},'draw':{'total':0},'lose':{'total':1}},'points':0,'description':null},
    {'position':4,'team':{'name':'CURNE'},               'games':{'played':1,'win':{'total':0},'draw':{'total':0},'lose':{'total':1}},'points':0,'description':null},
  ];

  static final List<dynamic> _tdiZona3Standings = [
    {'position':1,'team':{'name':'Jockey Club de Rosario'},  'games':{'played':1,'win':{'total':1},'draw':{'total':0},'lose':{'total':0}},'points':4,'description':'Playoffs'},
    {'position':2,'team':{'name':'Santa Fe Rugby'},          'games':{'played':1,'win':{'total':1},'draw':{'total':0},'lose':{'total':0}},'points':4,'description':'Playoffs'},
    {'position':3,'team':{'name':'Córdoba Athletic'},        'games':{'played':1,'win':{'total':0},'draw':{'total':0},'lose':{'total':1}},'points':0,'description':null},
    {'position':4,'team':{'name':'Universitario de Córdoba'},'games':{'played':1,'win':{'total':0},'draw':{'total':0},'lose':{'total':1}},'points':0,'description':null},
  ];

  static final List<dynamic> _tdiZona4Standings = [
    {'position':1,'team':{'name':'Jockey Club de Córdoba'},'games':{'played':1,'win':{'total':1},'draw':{'total':0},'lose':{'total':0}},'points':4,'description':'Playoffs'},
    {'position':2,'team':{'name':'La Tablada'},            'games':{'played':1,'win':{'total':1},'draw':{'total':0},'lose':{'total':0}},'points':4,'description':'Playoffs'},
    {'position':3,'team':{'name':'Old Resian'},            'games':{'played':1,'win':{'total':0},'draw':{'total':0},'lose':{'total':1}},'points':0,'description':null},
    {'position':4,'team':{'name':'Duendes RC'},            'games':{'played':1,'win':{'total':0},'draw':{'total':0},'lose':{'total':1}},'points':0,'description':null},
  ];
}
