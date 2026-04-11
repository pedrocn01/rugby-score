// Configuración centralizada de todas las ligas.
// Agregar una liga nueva: leagueIds + leagueSeasons + (si aplica) staticLeagues o staticStandingsOnly.

// ─── IDs de liga → temporada ───────────────────────────────────────────────
const Map<int, int> leagueSeasons = {
  16: 2025, // Top 14
  13: 2026, // Premiership
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
  'URBA Top 14':               -1, // datos estáticos
  // Circuito 7s
  'Acumulado 7s':              -1, // tabla acumulada estática
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
  'Acumulado 7s',
};

// ─── Ligas con partidos de la API pero tabla estática ─────────────────────
const Set<String> staticStandingsOnly = {
  'Super Rugby Pacific',
  'Champions Cup',
  'Challenge Cup',
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

// ─── Ligas que solo muestran la pestaña TABLA (sin partidos) ──────────────
const Set<String> soloTablaLeagues = {
  'Acumulado 7s',
};

// ─── Tabla acumulada calculada desde datos de la API (no estática) ────────
const Set<String> computedSevensAccumulated = {
  'Acumulado 7s',
};

// ─── Ligas que solo muestran la pestaña RESULTADOS (fase de grupos/pools) ─
const Set<String> soloResultadosLeagues = {};

// ─── Carpetas (agrupaciones en el home) ───────────────────────────────────
const Map<String, List<String>> folders = {
  'URBA': ['URBA Top 14'],
  'Circuito 7s': [
    'Acumulado 7s',
    '7s Dubai',
    '7s Sudáfrica',
    '7s Singapore',
    '7s Australia',
    '7s Canadá',
    '7s USA',
    '7s Hong Kong',
  ],
};

// ─── Secciones del home ───────────────────────────────────────────────────
const Map<String, List<String>> sections = {
  'LOCALES':       ['URBA'],
  'EUROPA':        ['Top 14', 'Premiership', 'United Rugby Championship', 'Champions Cup', 'Challenge Cup'],
  'SUPER RUGBY':   ['Super Rugby Pacific', 'Super Rugby Américas'],
  'INTERNACIONAL': ['Seis Naciones', 'The Rugby Championship', 'Circuito 7s'],
};
