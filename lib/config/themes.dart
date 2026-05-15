import 'package:flutter/material.dart';

class LeagueTheme {
  final Color primary;
  final Color accent;
  final Color background;
  const LeagueTheme({
    required this.primary,
    required this.accent,
    required this.background,
  });
}

const Map<String, LeagueTheme> leagueThemes = {
  // ── Europa ──────────────────────────────────────────────────────────────
  // Top 14 → bandera de Francia (azul/blanco/rojo)
  'Top 14':                    LeagueTheme(primary: Color(0xFF002395), accent: Color(0xFFED2939), background: Color(0xFFEEF2FF)),
  // Premiership → bandera de Inglaterra (rojo/blanco)
  'Premiership':               LeagueTheme(primary: Color(0xFFCF142B), accent: Color(0xFFFFFFFF), background: Color(0xFFFFF3F3)),
  // URC → verde celta
  'United Rugby Championship': LeagueTheme(primary: Color(0xFF006548), accent: Color(0xFF00C896), background: Color(0xFFE8FFF5)),
  // Copas europeas → colores EPCR (navy/gold)
  'Champions Cup':             LeagueTheme(primary: Color(0xFF1A1F5E), accent: Color(0xFFD4AF37), background: Color(0xFFF5F3E8)),
  'Challenge Cup':             LeagueTheme(primary: Color(0xFFE85D04), accent: Color(0xFF1A1A2E), background: Color(0xFFFFF3E8)),

  // ── Super Rugby ─────────────────────────────────────────────────────────
  'Super Rugby Pacific':       LeagueTheme(primary: Color(0xFF0077B6), accent: Color(0xFF00B4D8), background: Color(0xFFE8F7FF)),
  'Super Rugby Américas':      LeagueTheme(primary: Color(0xFF007A33), accent: Color(0xFFFFD700), background: Color(0xFFEAFFF0)),

  // ── Internacional ───────────────────────────────────────────────────────
  // Nations Championship → negro/dorado (logo amarillo sobre fondo negro)
  'Nations Championship':      LeagueTheme(primary: Color(0xFF0A0A0A), accent: Color(0xFFFFD700), background: Color(0xFFF5F0E8)),
  // Seis Naciones → navy/gold del torneo
  'Seis Naciones':             LeagueTheme(primary: Color(0xFF1A237E), accent: Color(0xFFC8A951), background: Color(0xFFEEF0FF)),
  'The Rugby Championship':    LeagueTheme(primary: Color(0xFF0077B6), accent: Color(0xFF00B4D8), background: Color(0xFFE8F7FF)),

  // ── URBA Top 14 ─────────────────────────────────────────────────────────
  'URBA Top 14':               LeagueTheme(primary: Color(0xFF006A3B), accent: Color(0xFFFFD700), background: Color(0xFFE8F5EE)),
  'TOP 14 Intermedia':         LeagueTheme(primary: Color(0xFF006A3B), accent: Color(0xFFFFD700), background: Color(0xFFE8F5EE)),
  'TOP 14 Pre-Intermedia A':   LeagueTheme(primary: Color(0xFF006A3B), accent: Color(0xFFFFD700), background: Color(0xFFE8F5EE)),
  'TOP 14 Pre-Intermedia B':   LeagueTheme(primary: Color(0xFF006A3B), accent: Color(0xFFFFD700), background: Color(0xFFE8F5EE)),
  'TOP 14 Pre-Intermedia C':   LeagueTheme(primary: Color(0xFF006A3B), accent: Color(0xFFFFD700), background: Color(0xFFE8F5EE)),
  'TOP 14 Pre-Intermedia D':   LeagueTheme(primary: Color(0xFF006A3B), accent: Color(0xFFFFD700), background: Color(0xFFE8F5EE)),
  'TOP 14 Pre-Intermedia E':   LeagueTheme(primary: Color(0xFF006A3B), accent: Color(0xFFFFD700), background: Color(0xFFE8F5EE)),
  'TOP 14 Pre-Intermedia F':   LeagueTheme(primary: Color(0xFF006A3B), accent: Color(0xFFFFD700), background: Color(0xFFE8F5EE)),
  'TOP 14 M-22':               LeagueTheme(primary: Color(0xFF006A3B), accent: Color(0xFFFFD700), background: Color(0xFFE8F5EE)),
  // ── URBA Primera A ──────────────────────────────────────────────────────
  'URBA Primera A':            LeagueTheme(primary: Color(0xFF00508A), accent: Color(0xFFFFD700), background: Color(0xFFE8F2FF)),
  '1A Intermedia':             LeagueTheme(primary: Color(0xFF00508A), accent: Color(0xFFFFD700), background: Color(0xFFE8F2FF)),
  '1A Pre-Intermedia':         LeagueTheme(primary: Color(0xFF00508A), accent: Color(0xFFFFD700), background: Color(0xFFE8F2FF)),
  '1A Pre-Intermedia B':       LeagueTheme(primary: Color(0xFF00508A), accent: Color(0xFFFFD700), background: Color(0xFFE8F2FF)),
  '1A Pre-Intermedia C':       LeagueTheme(primary: Color(0xFF00508A), accent: Color(0xFFFFD700), background: Color(0xFFE8F2FF)),
  '1A Pre-Intermedia D':       LeagueTheme(primary: Color(0xFF00508A), accent: Color(0xFFFFD700), background: Color(0xFFE8F2FF)),
  // ── URBA Primera B ──────────────────────────────────────────────────────
  'URBA Primera B':            LeagueTheme(primary: Color(0xFF5C2D82), accent: Color(0xFFFFD700), background: Color(0xFFF5EEFF)),
  '1B Intermedia':             LeagueTheme(primary: Color(0xFF5C2D82), accent: Color(0xFFFFD700), background: Color(0xFFF5EEFF)),
  '1B Pre-Intermedia':         LeagueTheme(primary: Color(0xFF5C2D82), accent: Color(0xFFFFD700), background: Color(0xFFF5EEFF)),
  '1B Pre-Intermedia B':       LeagueTheme(primary: Color(0xFF5C2D82), accent: Color(0xFFFFD700), background: Color(0xFFF5EEFF)),
  '1B Pre-Intermedia C':       LeagueTheme(primary: Color(0xFF5C2D82), accent: Color(0xFFFFD700), background: Color(0xFFF5EEFF)),
  // ── URBA Primera C ──────────────────────────────────────────────────────
  'URBA Primera C':            LeagueTheme(primary: Color(0xFF8A3800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3E8)),
  '1C Intermedia':             LeagueTheme(primary: Color(0xFF8A3800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3E8)),
  '1C Pre-Intermedia':         LeagueTheme(primary: Color(0xFF8A3800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3E8)),
  '1C Pre-Intermedia B':       LeagueTheme(primary: Color(0xFF8A3800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3E8)),

  // ── Segunda ─────────────────────────────────────────────────────────────
  'Segunda Superior':          LeagueTheme(primary: Color(0xFF003A70), accent: Color(0xFFFFD700), background: Color(0xFFE8F0FF)),
  'Segunda Intermedia':        LeagueTheme(primary: Color(0xFF003A70), accent: Color(0xFFFFD700), background: Color(0xFFE8F0FF)),
  // ── Tercera ──────────────────────────────────────────────────────────────
  'Tercera Superior':          LeagueTheme(primary: Color(0xFF1B5E20), accent: Color(0xFFFFD700), background: Color(0xFFEBF5EB)),
  'Tercera Intermedia':        LeagueTheme(primary: Color(0xFF1B5E20), accent: Color(0xFFFFD700), background: Color(0xFFEBF5EB)),
  // ── Desarrollo ───────────────────────────────────────────────────────────
  'Desarrollo Superior':       LeagueTheme(primary: Color(0xFF00695C), accent: Color(0xFFFFD700), background: Color(0xFFE8F5F3)),
  'Desarrollo Intermedia':     LeagueTheme(primary: Color(0xFF00695C), accent: Color(0xFFFFD700), background: Color(0xFFE8F5F3)),
  // ── Femenino ─────────────────────────────────────────────────────────────
  'Femenino TOP 9':            LeagueTheme(primary: Color(0xFF880E4F), accent: Color(0xFFFFD700), background: Color(0xFFFFF0F5)),
  'Femenino Primera División': LeagueTheme(primary: Color(0xFF880E4F), accent: Color(0xFFFFD700), background: Color(0xFFFFF0F5)),
  'Femenino Segunda División': LeagueTheme(primary: Color(0xFF880E4F), accent: Color(0xFFFFD700), background: Color(0xFFFFF0F5)),
  // ── M-19 ─────────────────────────────────────────────────────────────────
  'M-19 G1 A':                     LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-19 G1 B':                     LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-19 G1 Formativa A':           LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-19 G1 Formativa B':           LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-19 G1 Formativa C':           LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-19 G2 Nivel 1 A':             LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-19 G2 Nivel 1 A Eq B':        LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-19 G2 Nivel 1 B':             LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-19 G2 Nivel 1 B Eq B':        LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-19 G2 Nivel 2 C':             LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-19 G2 Nivel 2 C Eq B':        LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-19 G2 Nivel 2 D':             LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-19 G2 Nivel 2 D Eq B':        LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-19 G2 Nivel 2 Desarrollo':    LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-19 G2 Nivel 2 Desarrollo Eq B': LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  // ── M-17 ─────────────────────────────────────────────────────────────────
  'M-17 G2 Nivel 1 A':             LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-17 G2 Nivel 1 A Eq B':        LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-17 G2 Nivel 1 B':             LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-17 G2 Nivel 1 B Eq B':        LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-17 G2 Nivel 2 C':             LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-17 G2 Nivel 2 C Eq B':        LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-17 G1 A':                     LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-17 G1 B':                     LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-17 G1 C':                     LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-17 G1 Formativo A':           LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-17 G1 Formativo B':           LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-17 G1 Formativo C':           LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  // ── M-16 ─────────────────────────────────────────────────────────────────
  'M-16 G2 Nivel 1 A':             LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-16 G2 Nivel 1 A Eq B':        LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-16 G2 Nivel 1 B':             LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-16 G2 Nivel 1 B Eq B':        LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-16 G2 Nivel 2 C':             LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-16 G2 Nivel 2 C Eq B':        LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-16 G2 Nivel 2 Desarrollo':    LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-16 G2 Nivel 2 Desarrollo Eq B': LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-16 G1 A':                     LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-16 G1 B':                     LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-16 G1 Formativa A':           LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-16 G1 Formativa B':           LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  // ── M-15 ─────────────────────────────────────────────────────────────────
  'M-15 G2 Nivel 1 A':             LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-15 G2 Nivel 1 A Eq B':        LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-15 G2 Nivel 1 B':             LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-15 G2 Nivel 1 B Eq B':        LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-15 G2 Nivel 2 Desarrollo':    LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-15 G2 Nivel 2 Desarrollo Eq B': LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-15 G1 A':                     LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-15 G1 B':                     LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-15 G1 Formativa A':           LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  'M-15 G1 Formativa B':           LeagueTheme(primary: Color(0xFFB84800), accent: Color(0xFFFFD700), background: Color(0xFFFFF3EC)),
  // ── Circuito 7s ─────────────────────────────────────────────────────────
  '7s Dubai':                  LeagueTheme(primary: Color(0xFF8B6914), accent: Color(0xFFFFD700), background: Color(0xFFFFF8E1)),
  '7s Sudáfrica':              LeagueTheme(primary: Color(0xFF007749), accent: Color(0xFFFFB612), background: Color(0xFFE8FFF4)),
  '7s Singapore':              LeagueTheme(primary: Color(0xFFCC0001), accent: Color(0xFFFFFFFF), background: Color(0xFFFFEEEE)),
  '7s Australia':              LeagueTheme(primary: Color(0xFF00843D), accent: Color(0xFFFFD700), background: Color(0xFFE8FFF0)),
  '7s Canadá':                 LeagueTheme(primary: Color(0xFFCC0000), accent: Color(0xFFFFFFFF), background: Color(0xFFFFEEEE)),
  '7s USA':                    LeagueTheme(primary: Color(0xFF002868), accent: Color(0xFFBF0A30), background: Color(0xFFEEF2FF)),
  '7s Hong Kong':              LeagueTheme(primary: Color(0xFFDE2910), accent: Color(0xFFFFFFFF), background: Color(0xFFFFEEEE)),
};
