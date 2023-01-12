import 'package:test/test.dart';
import './utils.dart';

void main() async {
  final n = 200000;
  info('Testing $n unique IDs...');
  final pool = await createIdPool(max: n);
  final ids = pool['ids'];
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
    expect(set.length, equals(n));
    expect(histogram.length, equals(20));
  });

  test('produce a histogram within distribution tolerance', () {
    expect(histogram.every((x) => x > minBinSize && x < maxBinSize), isTrue);
    expect(set.length, equals(n));
  });

  test('bucket count must be 20', () {
    expect(histogram.length, equals(20));
  });
}
