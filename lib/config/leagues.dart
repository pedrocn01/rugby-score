// Configuración centralizada de todas las ligas.
// Agregar una liga nueva: leagueIds + leagueSeasons + (si aplica) staticLeagues o staticStandingsOnly.

// ─── IDs de liga → temporada ───────────────────────────────────────────────
const Map<int, int> leagueSeasons = {
  16: 2025, // Top 14
  13: 2025, // Premiership
  76: 2025, // United Rugby Championship
  54: 2025, // Champions Cup
  52: 2025, // Challenge Cup
  71: 2026, // Super Rugby Pacific
  51: 2026, // Seis Naciones
  85: 2025, // The Rugby Championship
  41: 2026, // Super Rugby Américas
  // Circuito 7s
  111: 2025, // 7s Dubai
  112: 2025, // 7s Sudáfrica
  120: 2026, // 7s Singapore
  110: 2026, // 7s Australia
  119: 2026, // 7s Canadá
  114: 2026, // 7s USA
  115: 2026, // 7s Hong Kong
};

// ─── Nombre en UI → ID de liga ─────────────────────────────────────────────
const Map<String, int> leagueIds = {
  'Top 14':                    16,
  'Premiership':               13,
  'United Rugby Championship': 76,
  'Champions Cup':             54,
  'Challenge Cup':             52,
  'Super Rugby Pacific':       71,
  'Seis Naciones':             51,
  'The Rugby Championship':    85,
  'Super Rugby Américas':      41,
  'URBA Top 14':               -1,
  'URBA Primera A':            -2,
  'URBA Primera B':            -3,
  'URBA Primera C':            -4,
  'TOP 14 Intermedia':         -5,
  'TOP 14 Pre-Intermedia A':   -6,
  'TOP 14 Pre-Intermedia B':   -7,
  'TOP 14 Pre-Intermedia C':   -8,
  'TOP 14 Pre-Intermedia D':   -9,
  'TOP 14 Pre-Intermedia E':   -11,
  'TOP 14 Pre-Intermedia F':   -13,
  'TOP 14 M-22':               -12,
  'Nations Championship':      -10,
  'TDI A 2026':                -20,
  // ── Primera A ──────────────────────────────────────────────────────────────
  '1A Intermedia':             -14,
  '1A Pre-Intermedia':         -15,
  '1A Pre-Intermedia B':       -16,
  '1A Pre-Intermedia C':       -17,
  '1A Pre-Intermedia D':       -18,
  // ── Primera B ──────────────────────────────────────────────────────────────
  '1B Intermedia':             -19,
  '1B Pre-Intermedia':         -21,
  '1B Pre-Intermedia B':       -22,
  '1B Pre-Intermedia C':       -23,
  // ── Primera C ──────────────────────────────────────────────────────────────
  '1C Intermedia':             -24,
  '1C Pre-Intermedia':         -25,
  '1C Pre-Intermedia B':       -26,
  // ── Segunda ────────────────────────────────────────────────────────────────
  'Segunda Superior':          -27,
  'Segunda Intermedia':        -28,
  // ── Tercera ────────────────────────────────────────────────────────────────
  'Tercera Superior':          -29,
  'Tercera Intermedia':        -30,
  // ── Desarrollo ─────────────────────────────────────────────────────────────
  'Desarrollo Superior':       -31,
  'Desarrollo Intermedia':     -32,
  // ── Femenino ───────────────────────────────────────────────────────────────
  'Femenino TOP 9':            -33,
  'Femenino Primera División': -34,
  'Femenino Segunda División': -35,
  // ── M-19 ───────────────────────────────────────────────────────────────────
  'M-19 G1 A':                     -40,
  'M-19 G1 B':                     -41,
  'M-19 G1 Formativa A':           -42,
  'M-19 G1 Formativa B':           -43,
  'M-19 G1 Formativa C':           -44,
  'M-19 G2 Nivel 1 A':             -45,
  'M-19 G2 Nivel 1 A Eq B':        -46,
  'M-19 G2 Nivel 1 B':             -47,
  'M-19 G2 Nivel 1 B Eq B':        -48,
  'M-19 G2 Nivel 2 C':             -49,
  'M-19 G2 Nivel 2 C Eq B':        -50,
  'M-19 G2 Nivel 2 D':             -51,
  'M-19 G2 Nivel 2 D Eq B':        -52,
  'M-19 G2 Nivel 2 Desarrollo':    -53,
  'M-19 G2 Nivel 2 Desarrollo Eq B': -54,
  // ── M-17 ───────────────────────────────────────────────────────────────────
  'M-17 G2 Nivel 1 A':             -55,
  'M-17 G2 Nivel 1 A Eq B':        -56,
  'M-17 G2 Nivel 1 B':             -57,
  'M-17 G2 Nivel 1 B Eq B':        -58,
  'M-17 G2 Nivel 2 C':             -59,
  'M-17 G2 Nivel 2 C Eq B':        -60,
  'M-17 G1 A':                     -61,
  'M-17 G1 B':                     -62,
  'M-17 G1 C':                     -63,
  'M-17 G1 Formativo A':           -64,
  'M-17 G1 Formativo B':           -65,
  'M-17 G1 Formativo C':           -66,
  // ── M-16 ───────────────────────────────────────────────────────────────────
  'M-16 G2 Nivel 1 A':             -67,
  'M-16 G2 Nivel 1 A Eq B':        -68,
  'M-16 G2 Nivel 1 B':             -69,
  'M-16 G2 Nivel 1 B Eq B':        -70,
  'M-16 G2 Nivel 2 C':             -71,
  'M-16 G2 Nivel 2 C Eq B':        -72,
  'M-16 G2 Nivel 2 Desarrollo':    -73,
  'M-16 G2 Nivel 2 Desarrollo Eq B': -74,
  'M-16 G1 A':                     -75,
  'M-16 G1 B':                     -76,
  'M-16 G1 Formativa A':           -77,
  'M-16 G1 Formativa B':           -78,
  // ── M-15 ───────────────────────────────────────────────────────────────────
  'M-15 G2 Nivel 1 A':             -79,
  'M-15 G2 Nivel 1 A Eq B':        -80,
  'M-15 G2 Nivel 1 B':             -81,
  'M-15 G2 Nivel 1 B Eq B':        -82,
  'M-15 G2 Nivel 2 Desarrollo':    -83,
  'M-15 G2 Nivel 2 Desarrollo Eq B': -84,
  'M-15 G1 A':                     -85,
  'M-15 G1 B':                     -86,
  'M-15 G1 Formativa A':           -87,
  'M-15 G1 Formativa B':           -88,
  // Circuito 7s
  '7s Dubai':                  111,
  '7s Sudáfrica':              112,
  '7s Singapore':              120,
  '7s Australia':              110,
  '7s Canadá':                 119,
  '7s USA':                    114,
  '7s Hong Kong':              115,
};

// ─── Ligas 100% estáticas (partidos + tabla cargados a mano) ──────────────
const Set<String> staticLeagues = {
  'URBA Top 14',
  'URBA Primera A',
  'URBA Primera B',
  'URBA Primera C',
  'Nations Championship',
  'TDI A 2026',
};

// ─── Ligas con partidos de la API pero tabla estática ─────────────────────
const Set<String> staticStandingsOnly = {
  'Champions Cup',
  'Challenge Cup',
};

// ─── Ligas cuya tabla viene de ESPN (incluye todos los bonus points) ──────
const Set<String> espnStandingsLeagues = {
  'Super Rugby Pacific',
};

// ─── Ligas cuya tabla se calcula a partir de los partidos de la API ───────
const Set<String> computeStandingsLeagues = {
  'Super Rugby Américas',
  '7s Dubai',
  '7s Sudáfrica',
  '7s Singapore',
  '7s Australia',
  '7s Canadá',
  '7s USA',
  '7s Hong Kong',
};

// ─── Etapas del Circuito 7s (tabla por pools, solo competencia principal) ─
const Set<String> sevensLeagues = {
  '7s Dubai',
  '7s Sudáfrica',
  '7s Singapore',
  '7s Australia',
  '7s Canadá',
  '7s USA',
  '7s Hong Kong',
};

// ─── Tabla acumulada calculada desde datos de la API (no estática) ────────
const Set<String> computedSevensAccumulated = {};

// ─── Ligas cuya tabla viene de la API de URBA ─────────────────────────────
const Set<String> urbaApiStandingsLeagues = {
  'URBA Top 14',
  'URBA Primera A',
  'URBA Primera B',
  'URBA Primera C',
  'TOP 14 Intermedia',
  'TOP 14 Pre-Intermedia A',
  'TOP 14 Pre-Intermedia B',
  'TOP 14 Pre-Intermedia C',
  'TOP 14 Pre-Intermedia D',
  'TOP 14 Pre-Intermedia E',
  'TOP 14 Pre-Intermedia F',
  'TOP 14 M-22',
  '1A Intermedia',
  '1A Pre-Intermedia',
  '1A Pre-Intermedia B',
  '1A Pre-Intermedia C',
  '1A Pre-Intermedia D',
  '1B Intermedia',
  '1B Pre-Intermedia',
  '1B Pre-Intermedia B',
  '1B Pre-Intermedia C',
  '1C Intermedia',
  '1C Pre-Intermedia',
  '1C Pre-Intermedia B',
  // Segunda
  'Segunda Superior',
  'Segunda Intermedia',
  // Tercera
  'Tercera Superior',
  'Tercera Intermedia',
  // Desarrollo
  'Desarrollo Superior',
  'Desarrollo Intermedia',
  // Femenino
  'Femenino TOP 9',
  'Femenino Primera División',
  'Femenino Segunda División',
  // M-19
  'M-19 G1 A',
  'M-19 G1 B',
  'M-19 G1 Formativa A',
  'M-19 G1 Formativa B',
  'M-19 G1 Formativa C',
  'M-19 G2 Nivel 1 A',
  'M-19 G2 Nivel 1 A Eq B',
  'M-19 G2 Nivel 1 B',
  'M-19 G2 Nivel 1 B Eq B',
  'M-19 G2 Nivel 2 C',
  'M-19 G2 Nivel 2 C Eq B',
  'M-19 G2 Nivel 2 D',
  'M-19 G2 Nivel 2 D Eq B',
  'M-19 G2 Nivel 2 Desarrollo',
  'M-19 G2 Nivel 2 Desarrollo Eq B',
  // M-17
  'M-17 G2 Nivel 1 A',
  'M-17 G2 Nivel 1 A Eq B',
  'M-17 G2 Nivel 1 B',
  'M-17 G2 Nivel 1 B Eq B',
  'M-17 G2 Nivel 2 C',
  'M-17 G2 Nivel 2 C Eq B',
  'M-17 G1 A',
  'M-17 G1 B',
  'M-17 G1 C',
  'M-17 G1 Formativo A',
  'M-17 G1 Formativo B',
  'M-17 G1 Formativo C',
  // M-16
  'M-16 G2 Nivel 1 A',
  'M-16 G2 Nivel 1 A Eq B',
  'M-16 G2 Nivel 1 B',
  'M-16 G2 Nivel 1 B Eq B',
  'M-16 G2 Nivel 2 C',
  'M-16 G2 Nivel 2 C Eq B',
  'M-16 G2 Nivel 2 Desarrollo',
  'M-16 G2 Nivel 2 Desarrollo Eq B',
  'M-16 G1 A',
  'M-16 G1 B',
  'M-16 G1 Formativa A',
  'M-16 G1 Formativa B',
  // M-15
  'M-15 G2 Nivel 1 A',
  'M-15 G2 Nivel 1 A Eq B',
  'M-15 G2 Nivel 1 B',
  'M-15 G2 Nivel 1 B Eq B',
  'M-15 G2 Nivel 2 Desarrollo',
  'M-15 G2 Nivel 2 Desarrollo Eq B',
  'M-15 G1 A',
  'M-15 G1 B',
  'M-15 G1 Formativa A',
  'M-15 G1 Formativa B',
};

// ─── Ligas donde el descenso está suspendido (no colorear fila) ───────────
const Set<String> noRelegationLeagues = {
  'Premiership',
  'Champions Cup',
  'Challenge Cup',
  'United Rugby Championship',
  'Super Rugby Pacific',
  'Super Rugby Américas',
  'TDI A 2026',
  // Femenino y Juveniles: sin marcadores de descenso/ascenso
  'Femenino TOP 9',
  'Femenino Primera División',
  'Femenino Segunda División',
  'M-19 G1 A', 'M-19 G1 B', 'M-19 G1 Formativa A', 'M-19 G1 Formativa B', 'M-19 G1 Formativa C',
  'M-19 G2 Nivel 1 A', 'M-19 G2 Nivel 1 A Eq B', 'M-19 G2 Nivel 1 B', 'M-19 G2 Nivel 1 B Eq B',
  'M-19 G2 Nivel 2 C', 'M-19 G2 Nivel 2 C Eq B', 'M-19 G2 Nivel 2 D', 'M-19 G2 Nivel 2 D Eq B',
  'M-19 G2 Nivel 2 Desarrollo', 'M-19 G2 Nivel 2 Desarrollo Eq B',
  'M-17 G2 Nivel 1 A', 'M-17 G2 Nivel 1 A Eq B', 'M-17 G2 Nivel 1 B', 'M-17 G2 Nivel 1 B Eq B',
  'M-17 G2 Nivel 2 C', 'M-17 G2 Nivel 2 C Eq B',
  'M-17 G1 A', 'M-17 G1 B', 'M-17 G1 C', 'M-17 G1 Formativo A', 'M-17 G1 Formativo B', 'M-17 G1 Formativo C',
  'M-16 G2 Nivel 1 A', 'M-16 G2 Nivel 1 A Eq B', 'M-16 G2 Nivel 1 B', 'M-16 G2 Nivel 1 B Eq B',
  'M-16 G2 Nivel 2 C', 'M-16 G2 Nivel 2 C Eq B', 'M-16 G2 Nivel 2 Desarrollo', 'M-16 G2 Nivel 2 Desarrollo Eq B',
  'M-16 G1 A', 'M-16 G1 B', 'M-16 G1 Formativa A', 'M-16 G1 Formativa B',
  'M-15 G2 Nivel 1 A', 'M-15 G2 Nivel 1 A Eq B', 'M-15 G2 Nivel 1 B', 'M-15 G2 Nivel 1 B Eq B',
  'M-15 G2 Nivel 2 Desarrollo', 'M-15 G2 Nivel 2 Desarrollo Eq B',
  'M-15 G1 A', 'M-15 G1 B', 'M-15 G1 Formativa A', 'M-15 G1 Formativa B',
};

// ─── Carpetas (agrupaciones en el home) ───────────────────────────────────
const Map<String, List<String>> folders = {
  'TOP 14': [
    'URBA Top 14',
    'TOP 14 Intermedia',
    'TOP 14 Pre-Intermedia A',
    'TOP 14 Pre-Intermedia B',
    'TOP 14 Pre-Intermedia C',
    'TOP 14 Pre-Intermedia D',
    'TOP 14 Pre-Intermedia E',
    'TOP 14 Pre-Intermedia F',
    'TOP 14 M-22',
  ],
  'Primera A': [
    'URBA Primera A',
    '1A Intermedia',
    '1A Pre-Intermedia',
    '1A Pre-Intermedia B',
    '1A Pre-Intermedia C',
    '1A Pre-Intermedia D',
  ],
  'Primera B': [
    'URBA Primera B',
    '1B Intermedia',
    '1B Pre-Intermedia',
    '1B Pre-Intermedia B',
    '1B Pre-Intermedia C',
  ],
  'Primera C': [
    'URBA Primera C',
    '1C Intermedia',
    '1C Pre-Intermedia',
    '1C Pre-Intermedia B',
  ],
  'Segunda': [
    'Segunda Superior',
    'Segunda Intermedia',
  ],
  'Tercera': [
    'Tercera Superior',
    'Tercera Intermedia',
  ],
  'Desarrollo': [
    'Desarrollo Superior',
    'Desarrollo Intermedia',
  ],
  'Femenino': [
    'Femenino TOP 9',
    'Femenino Primera División',
    'Femenino Segunda División',
  ],
  'URBA': ['TOP 14', 'Primera A', 'Primera B', 'Primera C', 'Segunda', 'Tercera', 'Desarrollo', 'Femenino'],
  'M-19': [
    'M-19 G1 A',
    'M-19 G1 B',
    'M-19 G1 Formativa A',
    'M-19 G1 Formativa B',
    'M-19 G1 Formativa C',
    'M-19 G2 Nivel 1 A',
    'M-19 G2 Nivel 1 A Eq B',
    'M-19 G2 Nivel 1 B',
    'M-19 G2 Nivel 1 B Eq B',
    'M-19 G2 Nivel 2 C',
    'M-19 G2 Nivel 2 C Eq B',
    'M-19 G2 Nivel 2 D',
    'M-19 G2 Nivel 2 D Eq B',
    'M-19 G2 Nivel 2 Desarrollo',
    'M-19 G2 Nivel 2 Desarrollo Eq B',
  ],
  'M-17': [
    'M-17 G2 Nivel 1 A',
    'M-17 G2 Nivel 1 A Eq B',
    'M-17 G2 Nivel 1 B',
    'M-17 G2 Nivel 1 B Eq B',
    'M-17 G2 Nivel 2 C',
    'M-17 G2 Nivel 2 C Eq B',
    'M-17 G1 A',
    'M-17 G1 B',
    'M-17 G1 C',
    'M-17 G1 Formativo A',
    'M-17 G1 Formativo B',
    'M-17 G1 Formativo C',
  ],
  'M-16': [
    'M-16 G2 Nivel 1 A',
    'M-16 G2 Nivel 1 A Eq B',
    'M-16 G2 Nivel 1 B',
    'M-16 G2 Nivel 1 B Eq B',
    'M-16 G2 Nivel 2 C',
    'M-16 G2 Nivel 2 C Eq B',
    'M-16 G2 Nivel 2 Desarrollo',
    'M-16 G2 Nivel 2 Desarrollo Eq B',
    'M-16 G1 A',
    'M-16 G1 B',
    'M-16 G1 Formativa A',
    'M-16 G1 Formativa B',
  ],
  'M-15': [
    'M-15 G2 Nivel 1 A',
    'M-15 G2 Nivel 1 A Eq B',
    'M-15 G2 Nivel 1 B',
    'M-15 G2 Nivel 1 B Eq B',
    'M-15 G2 Nivel 2 Desarrollo',
    'M-15 G2 Nivel 2 Desarrollo Eq B',
    'M-15 G1 A',
    'M-15 G1 B',
    'M-15 G1 Formativa A',
    'M-15 G1 Formativa B',
  ],
  'URBA - Juveniles': ['M-19', 'M-17', 'M-16', 'M-15'],
  'Torneo del Interior': ['TDI A 2026'],
  'Circuito 7s': [
    '7s Hong Kong',
    '7s Dubai',
    '7s Sudáfrica',
    '7s Singapore',
    '7s Australia',
    '7s Canadá',
    '7s USA',
  ],
};

// ─── Secciones del home ───────────────────────────────────────────────────
const Map<String, List<String>> sections = {
  'LOCALES':          ['URBA', 'Torneo del Interior', 'URBA - Juveniles'],
  'EUROPA':           ['Top 14', 'Premiership', 'United Rugby Championship', 'Champions Cup', 'Challenge Cup'],
  'SUPER RUGBY':      ['Super Rugby Pacific', 'Super Rugby Américas'],
  'INTERNACIONAL':    ['Nations Championship', 'Seis Naciones', 'The Rugby Championship', 'Circuito 7s'],
};
