import 'package:cuid2/cuid2.dart';

void info(txt) {
  print('# - $txt');
}

BigInt idToBigInt(String id, {radix = 36}) {
  return id.split('').fold(
      BigInt.zero,
      (r, v) =>
          r * BigInt.from(radix) + BigInt.from(int.parse(v, radix: radix)));
}

Iterable<int> createHistogram(Iterable<BigInt> data, {int bucketCount = 20}) {
  BigInt max = data.reduce((curr, next) => curr > next ? curr : next);
  BigInt interval = BigInt.from((max / BigInt.from(bucketCount)));
  List<Map<String, dynamic>> bins = [];

  // Setup Bins
  for (BigInt i = BigInt.zero; i < BigInt.from(bucketCount); i += BigInt.one) {
    bins.add(
        {'min': i * interval, 'max': interval + (i * interval), 'count': 0});
  }

  for (var number in data) {
    for (var j = 0; j < bins.length; j++) {
      var bin = bins[j];
      if (number > bin['min'] && number <= bin['max']) {
        bin['count']++;
        break; // An item can only be in one bin.
      }
    }
  }

  return bins.map((e) => e['count'] as int);
}

Future<Map<String, dynamic>> createIdPool({max = 100000}) async {
  final set = <String>{};

  for (var i = 0; i < max; i++) {
    set.add(cuid());
    if (i % 10000 == 0) print('${(i / max * 100).floor()}%');
    if (set.length < i) {
      info('Collision at: $i');
      break;
    }
  }
  info('No collisions detected');

  final ids = [...set];
  final numbers = ids.map((x) => idToBigInt(x.substring(1)));
  final histogram = createHistogram(numbers);
  return {'ids': ids, 'numbers': numbers, 'histogram': histogram};
}
