/// Everything collected across the Profile Setup flow's two steps.
///
/// This is plain, in-memory state — there's no backend field yet to persist
/// a completed profile against a user. `onComplete` in [ProfileSetupScreen]
/// hands one of these back to the caller.
/// TODO: once a backend exists (e.g. Firestore `users/{uid}`), write this
/// out there instead of just holding it in memory.
///
/// [skinToneIndex], [hairstyleIndex], and [jerseyColorIndex] are no longer
/// set by any active step (avatar customization was cut from this flow --
/// see [AvatarStep]), but are kept here at their defaults rather than
/// removed, since Settings customization will need somewhere to write them
/// back to once it exists.
class ProfileSetupData {
  String nickname;
  int skinToneIndex;
  int hairstyleIndex;
  int jerseyColorIndex;
  Set<String> positions;

  /// Always has a value -- the experience slider can't visually represent
  /// "unset" -- so this defaults to 'Intermediate' rather than being
  /// nullable. [experienceTouched] is the separate signal for whether the
  /// player actually moved it.
  String experience;

  /// False until the player drags the experience slider at least once.
  /// Experience isn't a required field, so without this there'd be no way
  /// to later tell "chose Intermediate" from "never touched it" -- kept
  /// now, while it's cheap, in case that distinction matters once a
  /// backend exists.
  bool experienceTouched;

  Set<String> courtTypes;

  ProfileSetupData({
    this.nickname = '',
    this.skinToneIndex = 0,
    this.hairstyleIndex = 0,
    this.jerseyColorIndex = 0,
    Set<String>? positions,
    this.experience = 'Intermediate',
    this.experienceTouched = false,
    Set<String>? courtTypes,
  }) : positions = positions ?? <String>{},
       courtTypes = courtTypes ?? <String>{};
}
