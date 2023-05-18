import 'dart:typed_data';

import 'package:cuid2/cuid2.dart';
import 'package:test/test.dart';

void main() {
  final id24 = cuid();
  final id16 = cuid(16);
  final id30 = cuid(30);
  final id30s = cuidSecure(30);

  test('must not be empty', () {
    expect(id24, isNotEmpty);
    expect(id30, isNotEmpty);
    expect(id30s, isNotEmpty);
  });

  test('must have required length', () {
    expect(id16.length, equals(16));
    expect(id24.length, equals(24));
    expect(id30.length, equals(30));
    expect(id30s.length, equals(30));
  });

  test('custom fingerprint is set', () {
    String myfingerprint() {
      return "klsdflsdflvcxlkaweporweqwqs";
    }

    final cuid = cuidConfig(fingerprint: myfingerprint);
    expect(cuid.fingerprint!(), equals(myfingerprint()));

    expect(cuidConfig().fingerprint!(), isNotEmpty);
  });

  test('custom counter increments count', () {
    int Function() myCounter(int start) => () => start += 5;

    final cuid = cuidConfig(counter: myCounter(0));
    expect([cuid.counter!(), cuid.counter!(), cuid.counter!()],
        equals([5, 10, 15]));
  });

  test('must be a valid cuid', () {
    expect(isCuid(cuid()), isTrue);
    expect(isCuid('$cuid()$cuid()'), isFalse);
  });

  test('bufToBigInt should return 0', () {
    expect(cuidConfig().bufToBigInt(Uint8List(2)), equals(BigInt.zero));
  });

  test('bufToBigInt should return 2^32 - 1', () {
    expect(
        cuidConfig().bufToBigInt(Uint8List.fromList([0xff, 0xff, 0xff, 0xff])),
        equals(BigInt.from(4294967295)));
  });
}
