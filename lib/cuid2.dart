// Copyright 2023 (c) George Mamar
//
// Licensed under MIT license
// ...

/// `cuid2` is a [Dart](https://dart.dev/) implementation of the [cuid2](https://github.com/paralleldrive/cuid2) library.
///
/// For technical details is recommended to check the original documentation where the inner details are explained.
///
/// Example usage:
///
/// ```dart
///   // cuid generator
///   print(cuid()); // => cl8qj639w000l7n6e6p689uad
///
///   // cuid using secure random generator
///   print(cuidSecure()); // => cl8qjcei8000kfq6e3a1q19os
///
///   // custom id length (defaults to 24)
///   print(cuid(30)); // => oxjkyfqo3aqk3jigelnuyp3ef299qx
///
///   final myCuid = cuidConfig(length: 30);
///   final id = myCuid.gen();
/// ```
library cuid2;

import 'src/cuid2_base.dart' show Cuid;

/// Generates a new id (default length of 24).
String cuid([int length = 24]) => Cuid(length).gen();

/// Generates a new id using cryptographic random generator (default length of 24).
///
/// Falls back to `Random()` if the system can not provide a secure source of random numbers. Check [Random.secure()]
String cuidSecure([int length = 24]) => Cuid(length, true).gen();

/// Creates a generator with the given options.
///
/// `length` _optional_ sets the length of the generated IDs (default is 24).
///
/// `counter` _optional_ custom session counter function. Ex. with increments of 5:
/// ```dart
///   myCounter(int start) => () => count+=5;
///   final config = cuidConfig(counter: myCounter(3));
/// ```
/// `fingerprint` _optional_ custom fingerprint function:
/// ```dart
///   String myfingerprint() => "uniqueFingerprint123";
///   final config = cuidConfig(fingerprint: myfingerprint);
/// ```
///
/// `secure` _optional_ uses [Random.secure()] when set to true (if available), otherwise (default & fallback) it uses [Random()]
Cuid cuidConfig(
        {int length = 24,
        Function? counter,
        String Function()? fingerprint,
        bool secure = false}) =>
    Cuid(length, secure, counter, fingerprint);
