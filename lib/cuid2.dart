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
///   cuid(); // => cl8qj639w000l7n6e6p689uad
///
///   // cuid using secure random generator
///   cuidSecure(); // => cl8qjcei8000kfq6e3a1q19os
///
///   // custom id length (defaults to 24)
///   cuid(30); // => oxjkyfqo3aqk3jigelnuyp3ef299qx
/// ```
library cuid2;

import 'src/cuid2_base.dart' show Cuid;

/// Generates a new id with default length of 24
String cuid([int idLength = 24, int entropyLength = 32]) =>
    Cuid(idLength, entropyLength).gen();

/// Generates a new id using cryptographic random generator.
///
/// Falls back to `Random()` if the system can not provide a secure source of random numbers. Check [Random.secure()](https://api.dart.dev/stable/2.18.6/dart-math/Random/Random.secure.html)
String cuidSecure([int idLength = 24, int entropyLength = 32]) =>
    Cuid(idLength, entropyLength, true).gen();
