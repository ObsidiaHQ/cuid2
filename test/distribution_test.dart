import 'dart:convert';

import 'package:test/test.dart';
import './utils.dart';

void main() async {
  int n = 300000;
  info('Testing $n unique IDs...');
  final pool = await createIdPool(max: n);
  List<String> ids = pool['ids'];
  final sampleIds = ids.sublist(0, 10);
  final set = Set<String>.from(ids);
  final histogram = pool['histogram'];
  info('sample ids: $sampleIds');
  info('histogram: ${histogram.join(",")}');
  final expectedBinSize = (n / histogram.length).ceil();
  final tolerance = 0.05;
  final minBinSize = (expectedBinSize * (1 - tolerance)).round();
  final maxBinSize = (expectedBinSize * (1 + tolerance)).round();
  info('expectedBinSize: $expectedBinSize');
  info('minBinSize: $minBinSize');
  info('maxBinSize: $maxBinSize');

  test('produce a histogram within distribution tolerance', () {
    expect(histogram.every((x) => x > minBinSize && x < maxBinSize), isTrue);
  });

  test('contain only valid characters', () {
    expect(ids.every((id) => RegExp(r'^[a-z0-9]+$').hasMatch(id)), isTrue);
  });

  test('generate no collisions', () {
    expect(set.length, equals(n));
  });

  final idLength = 23;
  final totalLetters = idLength * n;
  final base = 36;
  final toleranceChars = 0.1;
  final expectedBinSizeChars = (totalLetters / base).ceil();
  final minBinSizeChars = (expectedBinSizeChars * (1 - toleranceChars)).round();
  final maxBinSizeChars = (expectedBinSizeChars * (1 + toleranceChars)).round();
  // Drop the first character because it will always be a letter, making
  // the letter frequency skewed.
  final testIds = ids.map((id) => id.substring(2)).toList();
  final Map<String, int> charFrequencies = {};
  testIds.forEach((id) {
    id.split('').forEach((char) {
      charFrequencies[char] = (charFrequencies[char] ?? 0) + 1;
    });
  });

  info("Testing character frequency...");
  info('expectedBinSize: $expectedBinSizeChars');
  info('minBinSize: $minBinSizeChars');
  info('maxBinSize: $maxBinSizeChars');
  info('charFrequencies: ${jsonEncode(charFrequencies)}');

  test('produce even character frequency', () {
    expect(
        charFrequencies.values
            .every((x) => x > minBinSizeChars && x < maxBinSizeChars),
        isTrue);
  });

  test('represent all character values', () {
    expect(charFrequencies.keys.length, base);
  });
}
