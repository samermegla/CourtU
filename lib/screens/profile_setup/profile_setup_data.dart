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
  /// "unset" -- so this rests at 'New' rather than being nullable.
  /// [experienceTouched] is the separate signal for whether the player
  /// actually engaged with it.
  String experience;

  /// False until the player touches the experience slider. Experience IS a
  /// required field, but its resting value is indistinguishable from a real
  /// choice, so this is what the step's "can advance" check actually gates
  /// on -- without it there'd be no way to tell "chose New" from "never
  /// touched it".
  bool experienceTouched;

  Set<String> courtTypes;

  ProfileSetupData({
    this.nickname = '',
    this.skinToneIndex = 0,
    this.hairstyleIndex = 0,
    this.jerseyColorIndex = 0,
    Set<String>? positions,
    this.experience = 'New',
    this.experienceTouched = false,
    Set<String>? courtTypes,
  }) : positions = positions ?? <String>{},
       courtTypes = courtTypes ?? <String>{};
}
