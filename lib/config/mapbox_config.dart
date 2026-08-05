/// Runtime configuration for Mapbox.
///
/// Unlike the secret DOWNLOADS token (which lives in ~/.gradle/gradle.properties
/// and is only used at build time), these values are used by the running app.
///
/// - [publicAccessToken] is a PUBLIC token (starts with `pk.`). It is safe to
///   ship inside the app. Create one in your own Mapbox account dashboard; map
///   loads are billed to whoever owns this token.
/// - [styleUri] points at your friend's public style. Because the style is
///   public, any valid `pk.` token can load it.
class MapboxConfig {
  MapboxConfig._();

  static const String publicAccessToken = 'pk.eyJ1IjoicGFibG8tbmd1eWVuIiwiYSI6ImNtcnB5dDZ0ajAzc3oyd3EzajU0dWFmc2wifQ.msemuLg4bUmCjB0sREiDjA';
 
  static const String styleUri = 'mapbox://styles/pablo-nguyen/cmrqnug2m00e401s771jb658j';
}
