import 'package:cuid2/cuid2.dart';
import 'package:test/test.dart';

void main() {
  final id24 = cuid();
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

  test('must not get collisions (n=500k)', () {
    final s = <String>{};
    for (var i = 0; i < 500000; i++) {
      final c = cuid();
      if (s.contains(c)) {
        throw Exception('Collision detected at iteration %i');
      }
      s.add(c);
    }
  });
}
