import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../config/logos.dart';
import '../pages/onboarding_page.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class ProfileAvatarButton extends StatelessWidget {
  const ProfileAvatarButton({super.key});

  void _showMenu(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final profile = UserService.instance.profile;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            if (profile != null) ...[
              _TeamHeader(team: profile.hinchaTeam),
              const SizedBox(height: 8),
            ],
            if (user?.email != null)
              Text(
                user!.email!,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            const SizedBox(height: 24),
            const Divider(color: Colors.white12),
            ListTile(
              leading: const Icon(Icons.swap_horiz_rounded, color: Color(0xFF4CAF50)),
              title: const Text(
                'Cambiar equipo',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid == null) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OnboardingPage(
                      uid: uid,
                      isChangingTeam: true,
                      currentTeam: profile?.hinchaTeam,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                Navigator.pop(context);
                await AuthService.instance.signOut();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserService.instance,
      builder: (context, _) {
        final team = UserService.instance.profile?.hinchaTeam;
        final logo = team != null ? clubLogo(team) : null;
        return GestureDetector(
          onTap: () => _showMenu(context),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1B3A23),
              border: Border.all(color: const Color(0xFF4CAF50), width: 1.5),
            ),
            child: ClipOval(
              child: logo != null
                  ? Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(logo, fit: BoxFit.contain),
                    )
                  : const Icon(
                      Icons.person_rounded,
                      color: Colors.white54,
                      size: 18,
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _TeamHeader extends StatelessWidget {
  final String team;
  const _TeamHeader({required this.team});

  @override
  Widget build(BuildContext context) {
    final logo = clubLogo(team);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (logo != null)
          Image.asset(logo, height: 44, width: 44, fit: BoxFit.contain),
        const SizedBox(width: 12),
        Text(
          team,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
