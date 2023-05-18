import 'dart:io';

/// This is a fingerprint of the host environment. It is used to help
/// prevent collisions when generating ids in a distributed system.
/// You can also pass your own fingerprint function in the constructor.
String createFingerprint() {
  String fingerprint = "";

  try {
    fingerprint += 'Mobile\n';
    fingerprint += 'OS: ${Platform.operatingSystem}\n';
    fingerprint += 'OS Version: ${Platform.operatingSystemVersion}\n';
    fingerprint += 'Locale: ${Platform.localeName}\n';
    fingerprint += 'PID: $pid';
  } on Exception {
    fingerprint = '';
  }

  return fingerprint;
}
