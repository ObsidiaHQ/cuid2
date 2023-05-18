import 'dart:html';

/// This is a fingerprint of the host environment. It is used to help
/// prevent collisions when generating ids in a distributed system.
/// You can also pass your own fingerprint function in the constructor.
String createFingerprint() {
  String fingerprint = "";

  try {
    // Running on the web
    fingerprint += 'Web\n';
    fingerprint += 'Browser: ${window.navigator.appCodeName}\n';
    fingerprint += 'Platform: ${window.navigator.platform}\n';
    fingerprint += 'User Agent: ${window.navigator.userAgent}\n';
  } on Exception {
    fingerprint = '';
  }
  return fingerprint;
}
