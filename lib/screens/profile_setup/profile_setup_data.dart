/// Everything collected across the Profile Setup flow's five steps.
///
/// This is plain, in-memory state — there's no backend field yet to persist
/// a completed profile against a user. `onComplete` in [ProfileSetupScreen]
/// hands one of these back to the caller.
/// TODO: once a backend exists (e.g. Firestore `users/{uid}`), write this
/// out there instead of just holding it in memory.
class ProfileSetupData {
  String nickname;
  int skinToneIndex;
  int hairstyleIndex;
  int jerseyColorIndex;
  Set<String> positions;
  String? experience;
  String? competitiveness;

  ProfileSetupData({
    this.nickname = '',
    this.skinToneIndex = 0,
    this.hairstyleIndex = 0,
    this.jerseyColorIndex = 0,
    Set<String>? positions,
    this.experience,
    this.competitiveness,
  }) : positions = positions ?? <String>{};
}
