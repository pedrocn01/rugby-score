import 'package:flutter/material.dart';
import '../config/logos.dart';
import '../services/user_service.dart';

class OnboardingPage extends StatefulWidget {
  final String uid;
  const OnboardingPage({super.key, required this.uid});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  String? _selected;
  bool _saving = false;
  late final TabController _tabCtrl;

  static const _categories = <String, List<String>>{
    'Selecciones': [
      'Argentina', 'England', 'France', 'Ireland', 'Scotland', 'Wales', 'Italy',
      'New Zealand', 'Australia', 'South Africa', 'Fiji', 'Uruguay', 'Chile',
      'USA', 'Japan', 'Samoa', 'Tonga', 'Georgia', 'Romania', 'Portugal',
      'Brazil', 'Namibia', 'Canada', 'Kenya', 'Hong Kong', 'Spain',
      'Belgium', 'Germany', 'Netherlands',
    ],
    'URBA': [
      'Hindú', 'Alumni', 'SIC', 'CASI', 'Belgrano Athletic', 'Los Tilos',
      'Regatas', 'Atlético del Rosario', 'Los Matreros', 'CUBA', 'Newman',
      'Champagnat', 'Buenos Aires CRC', 'La Plata',
    ],
    'TDI': [
      'Tucumán Rugby', 'Gimnasia y Esgrima de Rosario', 'Marista RC', 'Duendes RC',
      'Jockey Club de Rosario', 'Tala RC', 'Córdoba Athletic',
      'Universitario de Córdoba', 'Jockey Club de Córdoba', 'La Tablada',
      'Santa Fe Rugby', 'Estudiantes de Paraná', 'CURNE',
    ],
    'Super Rugby': [
      'Crusaders', 'Blues', 'Chiefs', 'Highlanders', 'Hurricanes', 'Brumbies',
      'Waratahs', 'Reds', 'Western Force', 'Moana Pasifika', 'Fijian Drua',
      'Cobras', 'Black Lions', 'Cheetahs',
    ],
    'Clubes': [
      'Zebre Parma', 'Cardiff Rugby', 'Benetton Rugby', 'Dragons RFC', 'Scarlets',
      'Edinburgh Rugby', 'Ospreys', 'Leinster', 'Munster', 'Ulster', 'Connacht',
      'Glasgow Warriors', 'Stormers', 'Lions', 'Bulls', 'Sharks',
      'Stade Toulousain', 'Bordeaux Bèglès', 'Stade Francais Paris', 'Montpellier',
      'Clermont', 'Racing 92', 'Castres Olympique', 'Stade Rochelais',
      'Aviron Bayonnais', 'RC Toulonnais', 'Lyon', 'Section Paloise',
      'Northampton Saints', 'Bath', 'Leicester Tigers', 'Exeter Chiefs',
      'Bristol Bears', 'Saracens', 'Sale Sharks', 'Gloucester',
      'Harlequins', 'Newcastle Falcons',
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (_selected == null) return;
    setState(() => _saving = true);
    await UserService.instance.saveProfile(UserProfile(
      uid: widget.uid,
      hinchaTeam: _selected!,
      favoriteTeams: [_selected!],
    ));
    // AuthGate rebuild automático via UserService.notifyListeners()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿De qué equipo sos hincha?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Elegí tu equipo principal',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: const Color(0xFF4CAF50),
          labelColor: const Color(0xFF4CAF50),
          unselectedLabelColor: Colors.white38,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          tabs: _categories.keys.map((k) => Tab(text: k)).toList(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: _categories.entries.map((entry) {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: entry.value.length,
                  itemBuilder: (context, i) {
                    final team = entry.value[i];
                    final logo = clubLogo(team);
                    final isSelected = _selected == team;
                    return GestureDetector(
                      onTap: () => setState(() => _selected = team),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1B3A23)
                              : const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF4CAF50)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (logo != null)
                              Image.asset(
                                logo,
                                height: 48,
                                width: 48,
                                fit: BoxFit.contain,
                              )
                            else
                              Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2A2A),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Icon(
                                  Icons.sports_rugby,
                                  color: Colors.white24,
                                  size: 24,
                                ),
                              ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                team,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFF4CAF50)
                                      : Colors.white60,
                                  fontSize: 10,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: AnimatedOpacity(
                  opacity: _selected != null ? 1.0 : 0.35,
                  duration: const Duration(milliseconds: 200),
                  child: ElevatedButton(
                    onPressed: _selected != null && !_saving ? _confirm : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B5E20),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF1B5E20),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _selected != null
                                ? 'Confirmar — $_selected'
                                : 'Elegí un equipo',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
