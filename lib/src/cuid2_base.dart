import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/digests/sha3.dart';

class Cuid {
  static final _cache = <String, Cuid>{};

  int idLength = 24;
  final int _entropyLength = 32;
  int Function()? counter;
  Random _random = Random();
  String Function()? fingerprint;

  // ~22k hosts before 50% chance of initial counter collision
  // with a remaining counter range of 9.0e+15 in JavaScript.
  final int initialCountMax = 476782367;

  final List<String> _alphabet =
      List.generate(26, (i) => String.fromCharCode(i + 97));

  Cuid._create(
      [this.idLength = 24,
      bool secure = false,
      int Function()? counter,
      String Function()? fingerprint]) {
    if (secure) {
      try {
        _random = Random.secure();
      } on UnsupportedError {
        print("Random.secure() is not supported, but 'secure' flag was true");
      }
    }

    this.fingerprint = fingerprint ?? _createFingerprint;
    this.counter = counter ??
        _createCounter((_random.nextDouble() * initialCountMax).floor());
  }

  factory Cuid(
      [int idLength = 24,
      bool secure = false,
      int Function()? counter,
      String Function()? fingerprint]) {
    return _cache.putIfAbsent(
        '$secure$idLength${counter.hashCode}${fingerprint.hashCode}',
        () => Cuid._create(idLength, secure, counter, fingerprint));
  }

  String _createEntropy({int length = 4}) {
    String entropy = "";

    while (entropy.length < length) {
      entropy =
          "$entropy${(_random.nextDouble() * 36).floor().toRadixString(36)}";
    }

    return entropy;
  }

  /// Adapted from https://github.com/juanelas/bigint-conversion
  /// MIT License Copyright (c) 2018 Juan Hernández Serrano
  BigInt bufToBigInt(Uint8List buf) {
    final bits = 8;

    BigInt value = BigInt.zero;
    for (final i in buf) {
      final bi = BigInt.from(i);
      value = (value << bits) + bi;
    }
    return value;
  }

  String _hash([String input = ""]) {
    final d = SHA3Digest(512);
    final sha3 = d.process(utf8.encode(input) as Uint8List);

    // Drop the first character because it will bias the histogram
    // to the left.
    return bufToBigInt(sha3).toRadixString(36).substring(1);
  }

  String _randomLetter() {
    return _alphabet[(_random.nextDouble() * _alphabet.length).floor()];
  }

  /// This is a fingerprint of the host environment. It is used to help
  /// prevent collisions when generating ids in a distributed system.
  /// You can also pass your own fingerprint function in the constructor.
  String _createFingerprint() {
    final hostname = Platform.localHostname;
    final version = Platform.operatingSystemVersion;
    final os = Platform.operatingSystem;
    final fingerprint = '${_pad(pid.toRadixString(36), 3)}$hostname$version$os';
    final entropy = _createEntropy(length: _entropyLength);
    final sourceString = '$fingerprint$entropy';

    return _hash(sourceString).substring(0, _entropyLength);
  }

  String _pad(String value, int len) {
    return value.toString().padLeft(len, "0");
  }

  int Function() _createCounter(int count) => () => count++;

  /// Generates a new id based on the instance configuration
  String gen() {
    final firstLetter = _randomLetter();
    final time = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    String count = counter!().toRadixString(36);

    // The salt should be long enough to be globally unique across the full
    // length of the hash. For simplicity, we use the same length as the
    // intended id output.
    final salt = _createEntropy(length: idLength);
    final hashInput = "$time$salt$count${fingerprint!()}";

    return "$firstLetter${_hash(hashInput).substring(1, idLength)}";
  }
}
