import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/digests/sha3.dart';

class Cuid {
  static final _cache = <String, Cuid>{};

  int idLength = 24;
  final int _entropyLength = 32;
  Function? counter;
  Random _random = Random();
  String Function()? fingerprint;

  Cuid._create(
      [this.idLength = 24,
      bool secure = false,
      Function? counter,
      String Function()? fingerprint]) {
    if (secure) {
      try {
        _random = Random.secure();
      } on UnsupportedError {
        print("Random.secure() is not supported, but 'secure' flag was true");
      }
    }

    this.fingerprint = fingerprint ?? _createFingerprint;
    this.counter =
        counter ?? _createCounter((_random.nextDouble() * 2057).floor());
  }

  factory Cuid(
      [int idLength = 24,
      bool secure = false,
      Function? counter,
      String Function()? fingerprint]) {
    return _cache.putIfAbsent(
        '$secure$idLength${counter.hashCode}${fingerprint.hashCode}',
        () => Cuid._create(idLength, secure, counter, fingerprint));
  }

  final List<int> _primes = [
    109717,
    109721,
    109741,
    109751,
    109789,
    109793,
    109807,
    109819,
    109829,
    109831,
  ];

  final List<String> _alphabet =
      List.generate(26, (i) => String.fromCharCode(i + 97));

  String _createEntropy() {
    String entropy = "";

    while (entropy.length < _entropyLength) {
      final randomPrime =
          _primes[(_random.nextDouble() * _primes.length).floor()];
      entropy =
          "$entropy${(_random.nextDouble() * randomPrime).floor().toRadixString(36)}";
    }

    return entropy.substring(0, _entropyLength);
  }

  String _typedArrayToString(List<int> arr) {
    return arr.map((x) => x.toString()).join();
  }

  String _hash([String input = ""]) {
    final salt = _createEntropy();
    final text = "$input$salt";

    final d = SHA3Digest(512);
    final sha3 = d.process(utf8.encode(text) as Uint8List);

    return BigInt.parse(_typedArrayToString(sha3))
        .toRadixString(36)
        .substring(2);
  }

  String _randomLetter() {
    return _alphabet[(_random.nextDouble() * _alphabet.length).floor()];
  }

  String _createFingerprint() {
    final hostname = Platform.localHostname;
    final version = Platform.operatingSystemVersion;
    final os = Platform.operatingSystem;
    final fingerprint = '${_pad(pid.toRadixString(36), 3)}$hostname$version$os';

    return _hash(
        ((_random.nextDouble() + 1) * 2063).floor().toString() + fingerprint);
  }

  String _pad(String value, int len) {
    return value.toString().padLeft(len, "0");
  }

  _createCounter(int count) => () => count++;

  /// Generates a new id based on the instance configuration
  String gen() {
    final time = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    final randomEntropy = _createEntropy();
    final count = counter!();
    final firstLetter = _randomLetter();
    final hashInput = "$time$randomEntropy$count${fingerprint!()}";

    return "$firstLetter${_hash(hashInput).substring(1, idLength)}";
  }
}
