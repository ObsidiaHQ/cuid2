import 'package:cuid2/cuid2.dart';
import 'package:test/test.dart';

void main() {
  final id24 = cuid();
  final id241 = cuid();
  final id242 = cuid();
  final id243 = cuid();
  final id30 = cuid(30);
  final id30s = cuidSecure(30);

  test('must not be empty', () {
    expect(id24, isNotEmpty);
    expect(id30, isNotEmpty);
    expect(id30s, isNotEmpty);
  });

  test('must have required length', () {
    expect(id24.length, equals(24));
    expect(id30.length, equals(30));
    expect(id30s.length, equals(30));
  });

  test('custom fingerprint is set', () {
    String myfingerprint() {
      return "klsdflsdflvcxlkaweporweqwqs";
    }

    final Cuid = cuidConfig(fingerprint: myfingerprint);
    expect(Cuid.fingerprint!(), equals(myfingerprint()));
    expect(Cuid.gen(), isNotEmpty);
    expect(Cuid.gen().length, equals(24));
  });

  test('custom counter is set', () {
    Function myCounter(int start) {
      return () => start += 5;
    }

    final Cuid = cuidConfig(counter: myCounter(0));
    expect(Cuid.counter!(), equals(myCounter(0)()));
    expect(Cuid.gen(), isNotEmpty);
    expect(Cuid.gen().length, equals(24));
  });
}
