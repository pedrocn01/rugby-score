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
  'URBA Top 14':               -1, // tabla viva (api.urba.org.ar), partidos estáticos
  'URBA Primera A':            -2, // tabla viva (api.urba.org.ar), partidos estáticos
  'URBA Primera B':            -3, // tabla viva (api.urba.org.ar), partidos estáticos
  'URBA Primera C':            -4, // tabla viva (api.urba.org.ar), partidos estáticos
  'Nations Championship':     -10, // sin API — fixture estático scrapeado de Wikipedia
  'TDI A 2026':               -20, // Torneo del Interior A — fixture estático cargado a mano
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

// ─── Ligas cuya tabla viene de la API de URBA (partidos siguen estáticos) ─
const Set<String> urbaApiStandingsLeagues = {
  'URBA Top 14',
  'URBA Primera A',
  'URBA Primera B',
  'URBA Primera C',
};


// ─── Ligas donde el descenso está suspendido (no colorear fila) ───────────
const Set<String> noRelegationLeagues = {
  'Premiership',            // el descenso está suspendido desde 2021
  'Champions Cup',          // no hay descenso en copas europeas
  'Challenge Cup',
  'United Rugby Championship', // franquicias, sin descenso
  'Super Rugby Pacific',    // franquicias, sin descenso
  'Super Rugby Américas',   // franquicias, sin descenso
  'TDI A 2026',             // sin descenso ni playoff promoción
};

// ─── Carpetas (agrupaciones en el home) ───────────────────────────────────
const Map<String, List<String>> folders = {
  'URBA': ['URBA Top 14', 'URBA Primera A', 'URBA Primera B', 'URBA Primera C'],
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
  'LOCALES':       ['URBA', 'Torneo del Interior'],
  'EUROPA':        ['Top 14', 'Premiership', 'United Rugby Championship', 'Champions Cup', 'Challenge Cup'],
  'SUPER RUGBY':   ['Super Rugby Pacific', 'Super Rugby Américas'],
  'INTERNACIONAL': ['Nations Championship', 'Seis Naciones', 'The Rugby Championship', 'Circuito 7s'],
};
