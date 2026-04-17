/// Datos estáticos de ligas locales y tablas que la API no devuelve.
/// Para agregar datos: completar las listas correspondientes.
class StaticDataService {
  static List<dynamic> getMatches(String league) {
    return switch (league) {
      'URBA Top 14'    => _urbaTop14Matches,
      'URBA Primera A' => _urbaPrimeraAMatches,
      'URBA Primera B' => _urbaPrimeraBMatches,
      'URBA Primera C' => _urbaPrimeraCMatches,
      'Acumulado 7s'          => [],
      'Nations Championship'  => _nationsChampionshipMatches,
      'TDI A 2026'            => _tdiA2026Matches,
      _ => [],
    };
  }

  static List<List<dynamic>> getStandings(String league) {
    return switch (league) {
      'URBA Top 14'    => [_urbaTop14Standings],
      'URBA Primera A' => [_urbaPrimeraAStandings],
      'URBA Primera B' => [_urbaPrimeraBStandings],
      'URBA Primera C' => [_urbaPrimeraCStandings],
      'Acumulado 7s'   => [_sevensAcumuladoStandings],
      'Super Rugby Pacific' => [_superRugbyStandings],
      'Champions Cup'  => [_champsCupGrupoA, _champsCupGrupoB, _champsCupGrupoC, _champsCupGrupoD],
      'Challenge Cup'  => [_challengeCupGrupoA, _challengeCupGrupoB, _challengeCupGrupoC],
      'TDI A 2026'     => [_tdiZona1Standings, _tdiZona2Standings, _tdiZona3Standings, _tdiZona4Standings],
      _ => [],
    };
  }

  // ── URBA TOP 14 ──────────────────────────────────────────────────────────

  static final List<dynamic> _urbaTop14Matches = [
    {'week':'1','date':'2026-03-14T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'Hindú'},'away':{'name':'Los Tilos'}},'scores':{'home':52,'away':18},'periods':{'first':{'home':28,'away':11},'second':{'home':24,'away':7}}},
    {'week':'1','date':'2026-03-14T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'Champagnat'},'away':{'name':'CASI'}},'scores':{'home':16,'away':40},'periods':{'first':{'home':9,'away':28},'second':{'home':7,'away':12}}},
    {'week':'1','date':'2026-03-14T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'Alumni'},'away':{'name':'CUBA'}},'scores':{'home':27,'away':25},'periods':{'first':{'home':14,'away':15},'second':{'home':13,'away':10}}},
    {'week':'1','date':'2026-03-14T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'SIC'},'away':{'name':'Belgrano Athletic'}},'scores':{'home':58,'away':18},'periods':{'first':{'home':34,'away':11},'second':{'home':24,'away':7}}},
    {'week':'1','date':'2026-03-14T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'Newman'},'away':{'name':'Buenos Aires C&RC'}},'scores':{'home':31,'away':3},'periods':{'first':{'home':17,'away':3},'second':{'home':14,'away':0}}},
    {'week':'1','date':'2026-03-14T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'La Plata'},'away':{'name':'Atlético del Rosario'}},'scores':{'home':29,'away':36},'periods':{'first':{'home':11,'away':20},'second':{'home':18,'away':16}}},
    {'week':'1','date':'2026-03-14T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'Los Matreros'},'away':{'name':'Regatas'}},'scores':{'home':27,'away':25},'periods':{'first':{'home':14,'away':12},'second':{'home':13,'away':13}}},
    {'week':'2','date':'2026-03-21T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'CASI'},'away':{'name':'Hindú'}},'scores':{'home':12,'away':15},'periods':{'first':{'home':3,'away':8},'second':{'home':9,'away':7}}},
    {'week':'2','date':'2026-03-21T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'Newman'},'away':{'name':'Belgrano Athletic'}},'scores':{'home':33,'away':25},'periods':{'first':{'home':19,'away':14},'second':{'home':14,'away':11}}},
    {'week':'2','date':'2026-03-21T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'SIC'},'away':{'name':'Los Matreros'}},'scores':{'home':25,'away':20},'periods':{'first':{'home':17,'away':7},'second':{'home':8,'away':13}}},
    {'week':'2','date':'2026-03-21T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'Los Tilos'},'away':{'name':'La Plata'}},'scores':{'home':17,'away':13},'periods':{'first':{'home':3,'away':13},'second':{'home':14,'away':0}}},
    {'week':'2','date':'2026-03-21T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'Buenos Aires C&RC'},'away':{'name':'Alumni'}},'scores':{'home':20,'away':15},'periods':{'first':{'home':8,'away':10},'second':{'home':12,'away':5}}},
    {'week':'2','date':'2026-03-21T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'CUBA'},'away':{'name':'Champagnat'}},'scores':{'home':25,'away':29},'periods':{'first':{'home':13,'away':10},'second':{'home':12,'away':19}}},
    {'week':'2','date':'2026-03-21T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'Regatas'},'away':{'name':'Atlético del Rosario'}},'scores':{'home':20,'away':12},'periods':{'first':{'home':10,'away':5},'second':{'home':10,'away':7}}},
    {'week':'3','date':'2026-03-28T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'Regatas'},'away':{'name':'Los Tilos'}},'scores':{'home':29,'away':20},'periods':{'first':{'home':19,'away':7},'second':{'home':10,'away':13}}},
    {'week':'3','date':'2026-03-28T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'La Plata'},'away':{'name':'CASI'}},'scores':{'home':13,'away':39},'periods':{'first':{'home':3,'away':13},'second':{'home':10,'away':26}}},
    {'week':'3','date':'2026-03-28T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'Hindú'},'away':{'name':'CUBA'}},'scores':{'home':43,'away':36},'periods':{'first':{'home':17,'away':19},'second':{'home':26,'away':17}}},
    {'week':'3','date':'2026-03-28T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'Champagnat'},'away':{'name':'Buenos Aires C&RC'}},'scores':{'home':13,'away':10},'periods':{'first':{'home':6,'away':3},'second':{'home':7,'away':7}}},
    {'week':'3','date':'2026-03-28T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'Alumni'},'away':{'name':'Belgrano Athletic'}},'scores':{'home':26,'away':21},'periods':{'first':{'home':16,'away':0},'second':{'home':10,'away':21}}},
    {'week':'3','date':'2026-03-28T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'Newman'},'away':{'name':'SIC'}},'scores':{'home':10,'away':37},'periods':{'first':{'home':3,'away':21},'second':{'home':7,'away':16}}},
    {'week':'3','date':'2026-03-28T18:10:00+00:00','status':{'short':'FT'},'teams':{'home':{'name':'Los Matreros'},'away':{'name':'Atlético del Rosario'}},'scores':{'home':25,'away':22},'periods':{'first':{'home':12,'away':10},'second':{'home':13,'away':12}}},
    {'week':'4','date':'2026-04-11T17:30:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'SIC'},'away':{'name':'Alumni'}},'scores':{'home':null,'away':null},'periods':{}},
    {'week':'4','date':'2026-04-11T17:30:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Belgrano Athletic'},'away':{'name':'Champagnat'}},'scores':{'home':null,'away':null},'periods':{}},
    {'week':'4','date':'2026-04-11T17:30:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Buenos Aires C&RC'},'away':{'name':'Hindú'}},'scores':{'home':null,'away':null},'periods':{}},
    {'week':'4','date':'2026-04-11T17:30:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'CUBA'},'away':{'name':'La Plata'}},'scores':{'home':null,'away':null},'periods':{}},
    {'week':'4','date':'2026-04-11T17:30:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'CASI'},'away':{'name':'Regatas'}},'scores':{'home':null,'away':null},'periods':{}},
    {'week':'4','date':'2026-04-11T17:30:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Los Tilos'},'away':{'name':'Atlético del Rosario'}},'scores':{'home':null,'away':null},'periods':{}},
    {'week':'4','date':'2026-04-11T17:30:00+00:00','status':{'short':'NS'},'teams':{'home':{'name':'Newman'},'away':{'name':'Los Matreros'}},'scores':{'home':null,'away':null},'periods':{}},
  ];

  static final List<dynamic> _urbaTop14Standings = [
    {'position':1,'team':{'name':'SIC'},                 'games':{'played':3,'win':{'total':3},'draw':{'total':0},'lose':{'total':0}},'points':14,'description':'Playoffs'},
    {'position':2,'team':{'name':'Hindú'},               'games':{'played':3,'win':{'total':3},'draw':{'total':0},'lose':{'total':0}},'points':14,'description':'Playoffs'},
    {'position':3,'team':{'name':'CASI'},                'games':{'played':3,'win':{'total':2},'draw':{'total':0},'lose':{'total':1}},'points':11,'description':'Playoffs'},
    {'position':4,'team':{'name':'Newman'},              'games':{'played':3,'win':{'total':2},'draw':{'total':0},'lose':{'total':1}},'points':9, 'description':'Playoffs'},
    {'position':5,'team':{'name':'Alumni'},              'games':{'played':3,'win':{'total':2},'draw':{'total':0},'lose':{'total':1}},'points':9, 'description':null},
    {'position':6,'team':{'name':'Regatas'},             'games':{'played':3,'win':{'total':2},'draw':{'total':0},'lose':{'total':1}},'points':8, 'description':null},
    {'position':7,'team':{'name':'Champagnat'},          'games':{'played':3,'win':{'total':2},'draw':{'total':0},'lose':{'total':1}},'points':8, 'description':null},
    {'position':8,'team':{'name':'Los Matreros'},        'games':{'played':3,'win':{'total':2},'draw':{'total':0},'lose':{'total':1}},'points':8, 'description':null},
    {'position':9,'team':{'name':'Los Tilos'},           'games':{'played':3,'win':{'total':1},'draw':{'total':0},'lose':{'total':2}},'points':5, 'description':null},
    {'position':10,'team':{'name':'Buenos Aires C&RC'},  'games':{'played':3,'win':{'total':1},'draw':{'total':0},'lose':{'total':2}},'points':4, 'description':null},
    {'position':11,'team':{'name':'Atlético del Rosario'},'games':{'played':3,'win':{'total':1},'draw':{'total':0},'lose':{'total':2}},'points':4, 'description':null},
    {'position':12,'team':{'name':'CUBA'},               'games':{'played':3,'win':{'total':0},'draw':{'total':0},'lose':{'total':3}},'points':3, 'description':null},
    {'position':13,'team':{'name':'La Plata'},           'games':{'played':3,'win':{'total':0},'draw':{'total':0},'lose':{'total':3}},'points':2, 'description':'Relegation'},
    {'position':14,'team':{'name':'Belgrano Athletic'},  'games':{'played':3,'win':{'total':0},'draw':{'total':0},'lose':{'total':3}},'points':1, 'description':'Relegation'},
  ];

  // ── SUPER RUGBY PACIFIC (tabla estática) ─────────────────────────────────

  static final List<dynamic> _superRugbyStandings = [
    {'position':1,'team':{'name':'Hurricanes'},    'games':{'played':7,'win':{'total':6},'draw':{'total':0},'lose':{'total':1}},'points':26,'description':'Playoffs'},
    {'position':2,'team':{'name':'Chiefs'},        'games':{'played':7,'win':{'total':6},'draw':{'total':0},'lose':{'total':1}},'points':25,'description':'Playoffs'},
    {'position':3,'team':{'name':'Blues'},         'games':{'played':7,'win':{'total':5},'draw':{'total':0},'lose':{'total':2}},'points':22,'description':'Playoffs'},
    {'position':4,'team':{'name':'Brumbies'},      'games':{'played':7,'win':{'total':4},'draw':{'total':0},'lose':{'total':3}},'points':18,'description':'Playoffs'},
    {'position':5,'team':{'name':'Crusaders'},     'games':{'played':7,'win':{'total':3},'draw':{'total':0},'lose':{'total':4}},'points':15,'description':'Playoffs'},
    {'position':6,'team':{'name':'Western Force'}, 'games':{'played':7,'win':{'total':3},'draw':{'total':0},'lose':{'total':4}},'points':14,'description':'Playoffs'},
    {'position':7,'team':{'name':'Waratahs'},      'games':{'played':7,'win':{'total':3},'draw':{'total':0},'lose':{'total':4}},'points':13,'description':null},
    {'position':8,'team':{'name':'Highlanders'},   'games':{'played':7,'win':{'total':2},'draw':{'total':0},'lose':{'total':5}},'points':10,'description':null},
    {'position':9,'team':{'name':'Reds'},          'games':{'played':7,'win':{'total':2},'draw':{'total':0},'lose':{'total':5}},'points':10,'description':null},
    {'position':10,'team':{'name':'Fijian Drua'},  'games':{'played':7,'win':{'total':2},'draw':{'total':0},'lose':{'total':5}},'points':9, 'description':null},
    {'position':11,'team':{'name':'Moana Pasifika'},'games':{'played':7,'win':{'total':1},'draw':{'total':0},'lose':{'total':6}},'points':5, 'description':null},
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

  // ── CIRCUITO 7s — tabla acumulada ────────────────────────────────────────
  // Actualizada hasta Perth (4 legs jugados: Dubai, Sudáfrica, Singapore, Australia)

  static final List<dynamic> _sevensAcumuladoStandings = [
    {'position':1,'team':{'name':'Fiji'},          'games':{'played':4,'win':{'total':3},'draw':{'total':0},'lose':{'total':1}},'points':70,'description':'Líder'},
    {'position':2,'team':{'name':'South Africa'},  'games':{'played':4,'win':{'total':3},'draw':{'total':0},'lose':{'total':1}},'points':66,'description':null},
    {'position':3,'team':{'name':'New Zealand'},   'games':{'played':4,'win':{'total':2},'draw':{'total':0},'lose':{'total':2}},'points':62,'description':null},
    {'position':4,'team':{'name':'France'},        'games':{'played':4,'win':{'total':2},'draw':{'total':0},'lose':{'total':2}},'points':54,'description':null},
    {'position':5,'team':{'name':'Australia'},     'games':{'played':4,'win':{'total':2},'draw':{'total':0},'lose':{'total':2}},'points':54,'description':null},
    {'position':6,'team':{'name':'Argentina'},     'games':{'played':4,'win':{'total':1},'draw':{'total':0},'lose':{'total':3}},'points':44,'description':null},
    {'position':7,'team':{'name':'Spain'},         'games':{'played':4,'win':{'total':1},'draw':{'total':0},'lose':{'total':3}},'points':36,'description':null},
    {'position':8,'team':{'name':'Great Britain'}, 'games':{'played':4,'win':{'total':1},'draw':{'total':0},'lose':{'total':3}},'points':30,'description':null},
  ];

  // ── URBA PRIMERA A (agregar datos cuando estén disponibles) ─────────────
  static final List<dynamic> _urbaPrimeraAMatches   = [];
  static final List<dynamic> _urbaPrimeraAStandings = [];

  // ── URBA PRIMERA B (agregar datos cuando estén disponibles) ─────────────
  static final List<dynamic> _urbaPrimeraBMatches   = [];
  static final List<dynamic> _urbaPrimeraBStandings = [];

  // ── URBA PRIMERA C (agregar datos cuando estén disponibles) ─────────────
  static final List<dynamic> _urbaPrimeraCMatches   = [];
  static final List<dynamic> _urbaPrimeraCStandings = [];

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
