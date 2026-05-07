"""
Script para descargar todos los logos de rugby y guardarlos localmente.
Ejecutar desde la raíz del proyecto: python scripts/download_logos.py
"""

import os
import re
import time
import urllib.request
import urllib.error
from pathlib import Path

OUTPUT_DIR = Path(__file__).parent.parent / "assets" / "logos"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# Todos los logos del archivo logos.dart
LOGOS = {
    # ── Carpetas (home) ──────────────────────────────────────────────────────
    "folder_urba":           "https://upload.wikimedia.org/wikipedia/en/thumb/1/1f/Urba_logo.png/200px-Urba_logo.png",
    "folder_circuito_7s":    "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/SVNS_Logo_%282023%29.svg/200px-SVNS_Logo_%282023%29.svg.png",

    # ── Clubes URBA ──────────────────────────────────────────────────────────
    "club_hindu":            "https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Hindu_club_logo.svg/120px-Hindu_club_logo.svg.png",
    "club_alumni":           "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Alumni_rugby_logo.svg/120px-Alumni_rugby_logo.svg.png",
    "club_sic":              "https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/San_Isidro_Club_logo.svg/120px-San_Isidro_Club_logo.svg.png",
    "club_casi":             "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/CA_san_isidro_logo.svg/120px-CA_san_isidro_logo.svg.png",
    "club_belgrano_athletic":"https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Escudo_de_Belgrano_Athletic_Club.svg/120px-Escudo_de_Belgrano_Athletic_Club.svg.png",
    "club_los_tilos":        "https://upload.wikimedia.org/wikipedia/commons/thumb/7/78/Lostilos_logo.svg/120px-Lostilos_logo.svg.png",
    "club_regatas":          "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Regatas_BV_flaglogo.svg/120px-Regatas_BV_flaglogo.svg.png",
    "club_atletico_rosario": "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bb/Atlet_rosario_logo.svg/120px-Atlet_rosario_logo.svg.png",
    "club_los_matreros":     "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Los_matreros_rc_logo.png/120px-Los_matreros_rc_logo.png",
    "club_cuba":             "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Universitario_BA_logo.svg/120px-Universitario_BA_logo.svg.png",
    "club_newman":           "https://upload.wikimedia.org/wikipedia/en/thumb/1/1c/Club_newman_escudo.png/120px-Club_newman_escudo.png",
    "club_champagnat":       "https://upload.wikimedia.org/wikipedia/en/thumb/6/60/Club_champagnat_logo.png/120px-Club_champagnat_logo.png",
    "club_buenos_aires_crc": "https://upload.wikimedia.org/wikipedia/en/thumb/1/17/Buenos_Aires_CRC_Crest.svg/120px-Buenos_Aires_CRC_Crest.svg.png",
    "club_la_plata":         "https://upload.wikimedia.org/wikipedia/en/thumb/d/d7/La_Plata_Rugby_Club_Crest.svg/120px-La_Plata_Rugby_Club_Crest.svg.png",

    # ── Super Rugby Pacific ──────────────────────────────────────────────────
    "srp_crusaders":         "https://upload.wikimedia.org/wikipedia/en/thumb/b/bd/Crusaders_%28rugby_union%29_logo.png/200px-Crusaders_%28rugby_union%29_logo.png",
    "srp_blues":             "https://upload.wikimedia.org/wikipedia/en/thumb/c/cd/Auckland_Blues_rugby_logo.webp/200px-Auckland_Blues_rugby_logo.webp.png",
    "srp_chiefs":            "https://upload.wikimedia.org/wikipedia/en/thumb/8/87/Chiefs_rugby_union_logo.jpg/200px-Chiefs_rugby_union_logo.jpg",
    "srp_highlanders":       "https://upload.wikimedia.org/wikipedia/en/thumb/a/a7/Highlanders_NZ_rugby_union_team_logo.svg/200px-Highlanders_NZ_rugby_union_team_logo.svg.png",
    "srp_hurricanes":        "https://upload.wikimedia.org/wikipedia/en/thumb/2/28/Wellington_Hurricanes_logo.png/200px-Wellington_Hurricanes_logo.png",
    "srp_brumbies":          "https://upload.wikimedia.org/wikipedia/en/thumb/5/53/Brumbies_Rugby_logo.svg/200px-Brumbies_Rugby_logo.svg.png",
    "srp_waratahs":          "https://upload.wikimedia.org/wikipedia/en/thumb/6/6f/Waratahs_logo.svg/200px-Waratahs_logo.svg.png",
    "srp_reds":              "https://upload.wikimedia.org/wikipedia/en/thumb/e/e1/QLD_reds_logo.svg/200px-QLD_reds_logo.svg.png",
    "srp_western_force":     "https://upload.wikimedia.org/wikipedia/en/thumb/0/01/Western_force_rugby_logo.png/200px-Western_force_rugby_logo.png",
    "srp_moana_pasifika":    "https://upload.wikimedia.org/wikipedia/en/thumb/2/20/Moana_Pasifika_logo.jpg/200px-Moana_Pasifika_logo.jpg",
    "srp_fijian_drua":       "https://upload.wikimedia.org/wikipedia/en/thumb/9/9c/FijianDruaLogo.svg/200px-FijianDruaLogo.svg.png",

    # ── United Rugby Championship ────────────────────────────────────────────
    "urc_zebre":             "https://upload.wikimedia.org/wikipedia/en/thumb/5/5d/Zebre_parma_logo23.png/200px-Zebre_parma_logo23.png",
    "urc_cardiff":           "https://upload.wikimedia.org/wikipedia/en/thumb/1/1f/Cardiff_Rugby_logo_%282021%29.jpg/200px-Cardiff_Rugby_logo_%282021%29.jpg",
    "urc_benetton":          "https://upload.wikimedia.org/wikipedia/en/thumb/a/ac/Benetton_rugby.svg/200px-Benetton_rugby.svg.png",
    "urc_dragons":           "https://upload.wikimedia.org/wikipedia/en/thumb/9/9b/Dragons_RFC_logo.png/200px-Dragons_RFC_logo.png",
    "urc_scarlets":          "https://upload.wikimedia.org/wikipedia/en/thumb/0/07/Scarlets_logo.svg/200px-Scarlets_logo.svg.png",
    "urc_edinburgh":         "https://upload.wikimedia.org/wikipedia/en/thumb/e/e3/Edinburgh_Rugby_logo_2018.svg/200px-Edinburgh_Rugby_logo_2018.svg.png",
    "urc_ospreys":           "https://upload.wikimedia.org/wikipedia/en/thumb/2/2c/Ospreys_Rugby_logo.svg/200px-Ospreys_Rugby_logo.svg.png",
    "urc_leinster":          "https://upload.wikimedia.org/wikipedia/en/thumb/a/a4/LeinsterRugby_logo_2019.svg/200px-LeinsterRugby_logo_2019.svg.png",
    "urc_munster":           "https://upload.wikimedia.org/wikipedia/en/thumb/f/fb/Munster_Rugby_logo.svg/200px-Munster_Rugby_logo.svg.png",
    "urc_ulster":            "https://upload.wikimedia.org/wikipedia/en/thumb/c/c0/Ulster_Rugby_logo.svg/200px-Ulster_Rugby_logo.svg.png",
    "urc_connacht":          "https://upload.wikimedia.org/wikipedia/en/thumb/6/67/ConnachtRugby_2017logo.svg/200px-ConnachtRugby_2017logo.svg.png",
    "urc_glasgow":           "https://upload.wikimedia.org/wikipedia/en/thumb/0/06/Glasgow_Warriors_Logo.svg/200px-Glasgow_Warriors_Logo.svg.png",
    "urc_stormers":          "https://upload.wikimedia.org/wikipedia/en/thumb/e/e3/Stormers_logo.svg/200px-Stormers_logo.svg.png",
    "urc_lions":             "https://upload.wikimedia.org/wikipedia/en/thumb/e/e6/Lions_rugby_logo_2007.png/200px-Lions_rugby_logo_2007.png",
    "urc_bulls":             "https://upload.wikimedia.org/wikipedia/en/thumb/c/cf/Bulls_rugby_logo.jpg/200px-Bulls_rugby_logo.jpg",
    "urc_sharks":            "https://upload.wikimedia.org/wikipedia/en/thumb/9/9f/Sharks_rugby_union_logo.png/200px-Sharks_rugby_union_logo.png",

    # ── Super Rugby Américas ─────────────────────────────────────────────────
    "sra_cobras":            "https://upload.wikimedia.org/wikipedia/en/thumb/e/ec/Cobras_xv_logo.png/200px-Cobras_xv_logo.png",
    "sra_black_lions":       "https://upload.wikimedia.org/wikipedia/en/thumb/f/f3/Black_lion_rugby_logo.png/200px-Black_lion_rugby_logo.png",
    "sra_cheetahs":          "https://upload.wikimedia.org/wikipedia/en/thumb/d/d2/Logo_Cheetahs_Rugby.svg/200px-Logo_Cheetahs_Rugby.svg.png",

    # ── Top 14 francés ───────────────────────────────────────────────────────
    "top14_toulouse":        "https://upload.wikimedia.org/wikipedia/en/thumb/9/93/StadeToulousainLogo.svg/200px-StadeToulousainLogo.svg.png",
    "top14_bordeaux":        "https://upload.wikimedia.org/wikipedia/en/thumb/b/b1/UnionBordeauxBeglesLogo.svg/200px-UnionBordeauxBeglesLogo.svg.png",
    "top14_stade_francais":  "https://upload.wikimedia.org/wikipedia/en/thumb/e/ea/Stade_francais_logo18.svg/200px-Stade_francais_logo18.svg.png",
    "top14_montpellier":     "https://upload.wikimedia.org/wikipedia/en/thumb/d/d9/Logo_Montpellier_H%C3%A9rault_rugby_2013.svg/200px-Logo_Montpellier_H%C3%A9rault_rugby_2013.svg.png",
    "top14_clermont":        "https://upload.wikimedia.org/wikipedia/en/thumb/0/03/ASMClermontLogo.svg/200px-ASMClermontLogo.svg.png",
    "top14_racing92":        "https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/Racing_92_%28logo%29.svg/200px-Racing_92_%28logo%29.svg.png",
    "top14_castres":         "https://upload.wikimedia.org/wikipedia/en/thumb/b/bd/Castres_olympique_badge.png/200px-Castres_olympique_badge.png",
    "top14_la_rochelle":     "https://upload.wikimedia.org/wikipedia/en/thumb/e/e2/StadeRochelaisLogo.svg/200px-StadeRochelaisLogo.svg.png",
    "top14_bayonne":         "https://r2.thesportsdb.com/images/media/team/badge/z0fq591714808782.png",
    "top14_toulon":          "https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/RCT_LOGO.png/200px-RCT_LOGO.png",
    "top14_lyon":            "https://upload.wikimedia.org/wikipedia/en/thumb/f/fd/Lyon_Olympique_Universitaire.svg/200px-Lyon_Olympique_Universitaire.svg.png",
    "top14_perpignan":       "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Usa_perpignan_badge.png/200px-Usa_perpignan_badge.png",
    "top14_pau":             "https://upload.wikimedia.org/wikipedia/en/thumb/8/8a/Section_Paloise_2024.png/200px-Section_Paloise_2024.png",
    "top14_montauban":       "https://upload.wikimedia.org/wikipedia/en/thumb/3/3f/Us_montauban.png/200px-Us_montauban.png",

    # ── Premiership inglesa ──────────────────────────────────────────────────
    "pre_northampton":       "https://upload.wikimedia.org/wikipedia/en/thumb/7/7e/Northampton_Saints_Logo.svg/200px-Northampton_Saints_Logo.svg.png",
    "pre_bath":              "https://upload.wikimedia.org/wikipedia/en/thumb/e/ef/Bath_Rugby_logo.png/200px-Bath_Rugby_logo.png",
    "pre_leicester":         "https://upload.wikimedia.org/wikipedia/en/thumb/a/ac/Leicester_Tigers_logo.svg/200px-Leicester_Tigers_logo.svg.png",
    "pre_exeter":            "https://upload.wikimedia.org/wikipedia/en/thumb/b/b7/Exeter_Chiefs_new_logo_2022.png/200px-Exeter_Chiefs_new_logo_2022.png",
    "pre_bristol":           "https://upload.wikimedia.org/wikipedia/en/thumb/0/02/Bristol_Bears_logo.svg/200px-Bristol_Bears_logo.svg.png",
    "pre_saracens":          "https://upload.wikimedia.org/wikipedia/en/thumb/3/3f/Saracens_F.C._Logo.svg/200px-Saracens_F.C._Logo.svg.png",
    "pre_sale":              "https://upload.wikimedia.org/wikipedia/en/thumb/5/5e/Sale_Sharks_logo.svg/200px-Sale_Sharks_logo.svg.png",
    "pre_gloucester":        "https://upload.wikimedia.org/wikipedia/en/thumb/8/8c/Gloucester_Rugby_%282018%29_logo.svg/200px-Gloucester_Rugby_%282018%29_logo.svg.png",
    "pre_harlequins":        "https://upload.wikimedia.org/wikipedia/en/thumb/9/92/Harlequin_FC_logo.svg/200px-Harlequin_FC_logo.svg.png",
    "pre_newcastle":         "https://upload.wikimedia.org/wikipedia/en/thumb/8/80/Newcastle_Red_Bulls_logo.png/200px-Newcastle_Red_Bulls_logo.png",

    # ── Torneo del Interior ──────────────────────────────────────────────────
    "tdi_tucuman":           "https://upload.wikimedia.org/wikipedia/en/thumb/2/25/Tucuman_Rugby_Club_Crest.svg/200px-Tucuman_Rugby_Club_Crest.svg.png",
    "tdi_gimnasia_rosario":  "https://upload.wikimedia.org/wikipedia/en/thumb/5/59/Club_ger_logo.png/200px-Club_ger_logo.png",
    "tdi_marista":           "https://upload.wikimedia.org/wikipedia/en/thumb/f/f5/Marista_rc_escudo.png/200px-Marista_rc_escudo.png",
    "tdi_duendes":           "https://upload.wikimedia.org/wikipedia/en/thumb/d/d0/Duendes_Rugby_Club_Crest.svg/200px-Duendes_Rugby_Club_Crest.svg.png",
    "tdi_jockey_rosario":    "https://upload.wikimedia.org/wikipedia/en/thumb/7/7a/Jockey_rosario_logo.png/200px-Jockey_rosario_logo.png",
    "tdi_tala":              "https://upload.wikimedia.org/wikipedia/en/thumb/0/08/Tala_Rugby_Club_Crest.svg/200px-Tala_Rugby_Club_Crest.svg.png",
    "tdi_cordoba_athletic":  "https://upload.wikimedia.org/wikipedia/en/thumb/3/39/Cordoba_Athletic_Club_Crest.svg/200px-Cordoba_Athletic_Club_Crest.svg.png",
    "tdi_universitario_cba": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Universitario_cba_logo.svg/200px-Universitario_cba_logo.svg.png",
    "tdi_jockey_cordoba":    "https://upload.wikimedia.org/wikipedia/en/thumb/b/b1/Jockey_club_cba_logo.png/200px-Jockey_club_cba_logo.png",
    "tdi_la_tablada":        "https://upload.wikimedia.org/wikipedia/en/thumb/7/7f/Club_La_Tablada_Crest.svg/200px-Club_La_Tablada_Crest.svg.png",
    "tdi_santa_fe_rugby":    "https://upload.wikimedia.org/wikipedia/en/thumb/9/98/Santa_Fe_Rugby_Club_Crest.svg/200px-Santa_Fe_Rugby_Club_Crest.svg.png",
    "tdi_estudiantes_parana":"https://upload.wikimedia.org/wikipedia/en/thumb/8/87/Estudiantes_parana_logo.png/200px-Estudiantes_parana_logo.png",
    "tdi_curne":             "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/Escudo_CURNE.png/200px-Escudo_CURNE.png",

    # ── Selecciones y federaciones internacionales ───────────────────────────
    "nat_ireland":           "https://upload.wikimedia.org/wikipedia/en/thumb/e/e9/Irfu_jersey_logo.svg/200px-Irfu_jersey_logo.svg.png",
    "nat_france":            "https://upload.wikimedia.org/wikipedia/en/thumb/1/1f/Logo_XV_de_France_masculin_2019.png/200px-Logo_XV_de_France_masculin_2019.png",
    "nat_england":           "https://upload.wikimedia.org/wikipedia/en/thumb/3/39/England_national_rugby_team_logo.svg/200px-England_national_rugby_team_logo.svg.png",
    "nat_scotland":          "https://upload.wikimedia.org/wikipedia/en/thumb/a/a2/Scotland_national_rugby_union_team_logo.png/200px-Scotland_national_rugby_union_team_logo.png",
    "nat_wales":             "https://upload.wikimedia.org/wikipedia/en/thumb/d/d6/Welsh_Rugby_Union_logo.svg/200px-Welsh_Rugby_Union_logo.svg.png",
    "nat_italy":             "https://upload.wikimedia.org/wikipedia/en/thumb/b/bb/Italian_Rugby_Federation_logo.svg/200px-Italian_Rugby_Federation_logo.svg.png",
    "nat_argentina":         "https://upload.wikimedia.org/wikipedia/en/thumb/7/74/Los_pumas_argentina_logo23.png/200px-Los_pumas_argentina_logo23.png",
    "nat_australia":         "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Wallabies_Vertical_Primary_RGB.svg/200px-Wallabies_Vertical_Primary_RGB.svg.png",
    "nat_new_zealand":       "https://upload.wikimedia.org/wikipedia/en/thumb/f/fb/All_Blacks_logo.svg/200px-All_Blacks_logo.svg.png",
    "nat_south_africa":      "https://upload.wikimedia.org/wikipedia/en/thumb/8/83/South_Africa_national_rugby_union_team.svg/200px-South_Africa_national_rugby_union_team.svg.png",
    "nat_fiji":              "https://upload.wikimedia.org/wikipedia/en/thumb/e/e3/Logo_Fiji_Rugby_2019.svg/200px-Logo_Fiji_Rugby_2019.svg.png",
    "nat_usa":               "https://upload.wikimedia.org/wikipedia/en/thumb/e/e0/United_States_national_rugby_union_team_logo.png/200px-United_States_national_rugby_union_team_logo.png",
    "nat_canada":            "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Rugby_Canada_logo.svg/200px-Rugby_Canada_logo.svg.png",
    "nat_uruguay":           "https://upload.wikimedia.org/wikipedia/en/thumb/e/e1/Los_teros_logo.png/200px-Los_teros_logo.png",
    "nat_japan":             "https://upload.wikimedia.org/wikipedia/en/thumb/3/37/Logo_JRFU.svg/200px-Logo_JRFU.svg.png",
    "nat_spain":             "https://upload.wikimedia.org/wikipedia/en/thumb/f/f0/Spain_Rugby_logo.svg/200px-Spain_Rugby_logo.svg.png",
    "nat_portugal":          "https://upload.wikimedia.org/wikipedia/en/thumb/7/7e/Portuguese_Rugby.png/200px-Portuguese_Rugby.png",
    "nat_georgia":           "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/Georgian_RU_logo_2023.png/200px-Georgian_RU_logo_2023.png",
    "nat_romania":           "https://upload.wikimedia.org/wikipedia/en/thumb/7/77/Romania_national_rugby_union_team_logo.png/200px-Romania_national_rugby_union_team_logo.png",
    "nat_hong_kong":         "https://upload.wikimedia.org/wikipedia/en/thumb/0/04/Hong_Kong_China_Rugby_Union.svg/200px-Hong_Kong_China_Rugby_Union.svg.png",
    "nat_chile":             "https://upload.wikimedia.org/wikipedia/en/thumb/3/3d/Condores_Chile_Rugby.png/200px-Condores_Chile_Rugby.png",
    "nat_kenya":             "https://flagcdn.com/w80/ke.png",
    "nat_samoa":             "https://flagcdn.com/w80/ws.png",
    "nat_tonga":             "https://flagcdn.com/w80/to.png",
    "nat_korea":             "https://flagcdn.com/w80/kr.png",
    "nat_great_britain":     "https://flagcdn.com/w80/gb.png",
    "nat_brazil":            "https://flagcdn.com/w80/br.png",
    "nat_germany":           "https://flagcdn.com/w80/de.png",
    "nat_netherlands":       "https://flagcdn.com/w80/nl.png",
    "nat_belgium":           "https://flagcdn.com/w80/be.png",
    "nat_russia":            "https://flagcdn.com/w80/ru.png",
    "nat_zimbabwe":          "https://flagcdn.com/w80/zw.png",
    "nat_namibia":           "https://flagcdn.com/w80/na.png",
    "nat_uganda":            "https://flagcdn.com/w80/ug.png",

    # ── Ligas / torneos ──────────────────────────────────────────────────────
    "league_top14":          "https://upload.wikimedia.org/wikipedia/en/thumb/d/dd/Logo_Top14_2012.png/200px-Logo_Top14_2012.png",
    "league_premiership":    "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/Logo_of_Premiership_Rugby_2018.svg/330px-Logo_of_Premiership_Rugby_2018.svg.png",
    "league_urc":            "https://upload.wikimedia.org/wikipedia/en/thumb/0/07/United_Rugby_Championship_logo.svg/200px-United_Rugby_Championship_logo.svg.png",
    "league_champions_cup":  "https://upload.wikimedia.org/wikipedia/en/thumb/6/65/InvestecChampionsCupLogo.svg/250px-InvestecChampionsCupLogo.svg.png",
    "league_challenge_cup":  "https://upload.wikimedia.org/wikipedia/en/thumb/0/03/EPCRchallengecuplogo.svg/250px-EPCRchallengecuplogo.svg.png",
    "league_srp":            "https://upload.wikimedia.org/wikipedia/en/2/25/Super_Rugby_Pacific_logo.png",
    "league_6nations":       "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/SixNationsRugbyCup.svg/250px-SixNationsRugbyCup.svg.png",
    "league_rugby_champ":    "https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/The_Rugby_Championship_logo_%28white_background%29.png/250px-The_Rugby_Championship_logo_%28white_background%29.png",
    "league_sra":            "https://upload.wikimedia.org/wikipedia/en/2/27/Super_Rugby_Americas_logo.png",
    "league_urba":           "https://upload.wikimedia.org/wikipedia/en/thumb/1/1f/Urba_logo.png/200px-Urba_logo.png",
}

HEADERS = {
    "User-Agent": "Mozilla/5.0 (compatible; RugbyScoreApp/1.0; educational use)"
}

ok = []
failed = []

print(f"Descargando {len(LOGOS)} logos en {OUTPUT_DIR}...\n")

for name, url in LOGOS.items():
    ext = ".png"  # todos los Wikimedia /thumb/ se sirven como PNG
    dest = OUTPUT_DIR / f"{name}{ext}"

    if dest.exists():
        print(f"  ✓ (ya existe) {name}")
        ok.append(name)
        continue

    try:
        req = urllib.request.Request(url, headers=HEADERS)
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = resp.read()
        with open(dest, "wb") as f:
            f.write(data)
        print(f"  ✓ {name}  ({len(data)//1024} KB)")
        ok.append(name)
    except Exception as e:
        print(f"  ✗ {name}: {e}")
        failed.append((name, url, str(e)))

    time.sleep(0.15)  # pausa cortés con Wikimedia

print(f"\n{'='*50}")
print(f"OK: {len(ok)}   Fallidos: {len(failed)}")
if failed:
    print("\nLogos que fallaron (hay que buscarlos manualmente):")
    for name, url, err in failed:
        print(f"  {name}: {url}")
        print(f"    → {err}")

print("\nListo. Revisá assets/logos/ para ver los archivos descargados.")
