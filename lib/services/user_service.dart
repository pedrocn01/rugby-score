import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserProfile {
  final String uid;
  final String hinchaTeam;
  final List<String> favoriteTeams;

  const UserProfile({
    required this.uid,
    required this.hinchaTeam,
    required this.favoriteTeams,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> data) => UserProfile(
    uid: uid,
    hinchaTeam: data['hinchaTeam'] as String? ?? '',
    favoriteTeams: List<String>.from(data['favoriteTeams'] as List? ?? []),
  );

  Map<String, dynamic> toMap() => {
    'hinchaTeam': hinchaTeam,
    'favoriteTeams': favoriteTeams,
  };

  UserProfile copyWith({String? hinchaTeam, List<String>? favoriteTeams}) => UserProfile(
    uid: uid,
    hinchaTeam: hinchaTeam ?? this.hinchaTeam,
    favoriteTeams: favoriteTeams ?? this.favoriteTeams,
  );
}

class UserService extends ChangeNotifier {
  UserService._();
  static final UserService instance = UserService._();

  final _db = FirebaseFirestore.instance;
  UserProfile? _profile;

  UserProfile? get profile => _profile;

  Future<void> loadProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        _profile = UserProfile.fromMap(uid, doc.data()!);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ UserService.loadProfile: $e');
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    try {
      await _db.collection('users').doc(profile.uid).set(
        profile.toMap(),
        SetOptions(merge: true),
      );
      _profile = profile;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ UserService.saveProfile: $e');
    }
  }

  Future<void> toggleFavorite(String teamName) async {
    if (_profile == null) return;
    final teams = List<String>.from(_profile!.favoriteTeams);
    if (teams.contains(teamName)) {
      teams.remove(teamName);
    } else {
      teams.add(teamName);
    }
    await saveProfile(_profile!.copyWith(favoriteTeams: teams));
  }

  bool isFavorite(String teamName) => _profile?.favoriteTeams.contains(teamName) ?? false;

  void clearProfile() {
    _profile = null;
    notifyListeners();
  }
}
