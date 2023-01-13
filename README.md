# Cuid2

[![Pub Version](https://img.shields.io/pub/v/cuid2?color=cyan)](https://pub.dev/packages/cuid2)
[![Pub Publisher](https://img.shields.io/pub/publisher/cuid2)](https://pub.dev/publishers/obsidia.io/packages)
[![License](https://img.shields.io/badge/license-MIT-blueviolet)](https://github.com/obsidiaHQ/cuid2/blob/master/LICENSE)

Secure, collision-resistant ids optimized for horizontal scaling and performance. Next generation UUIDs.

Need unique ids in your app? Forget UUIDs and GUIDs which often collide in large apps. Use Cuid2, instead.

**Cuid2 is:**

* **Secure:** It's not feasible to guess the next id, existing valid ids, or learn anything about the referenced data from the id. Cuid2 uses multiple, independent entropy sources and hashes them with a security-audited, NIST-standard cryptographically secure hashing algorithm (Sha3).
* **Collision resistant:** It's extremely unlikely to generate the same id twice (by default, you'd need to generate roughly 4,000,000,000,000,000,000 ids ([`sqrt(36^(24-1) * 26) = 4.0268498e+18`](https://en.wikipedia.org/wiki/Birthday_problem#Square_approximation)) to reach 50% chance of collision.
* **Horizontally scalable:** Generate ids on multiple machines without coordination.
* **Offline-compatible:** Generate ids without a network connection.
* **URL and name-friendly:** No special characters.
* **Fast and convenient:** No async operations. Won't introduce user-noticeable delays. Less than 5k, gzipped.
* **But not *too fast*:** If you can hash too quickly you can launch parallel attacks to find duplicates or break entropy-hiding. For unique ids, the fastest runner loses the security race.


**Cuid2 is not good for:**

* Sequential ids (see the [note on K-sortable ids](https://github.com/paralleldrive/cuid2#note-on-k-sortablesequentialmonotonically-increasing-ids), below)
* High performance tight loops, such as render loops (if you don't need cross-host unique ids or security, consider a simple counter for this use-case, or try [Ulid](https://github.com/ulid/javascript) or [NanoId](https://github.com/ai/nanoid)).


**[Learn more](https://github.com/paralleldrive/cuid2)**

## Install
```
dart pub add cuid2
```


## Usage

```dart
import 'package:cuid2/cuid2.dart';

void main() {
  final id = cuid();  // default options
  final id30 = cuidSecure(30);  // set length to 30, use Random.secure()
  final cc = cuidConfig(length: 30);  // custom config - see example

  print(cc.gen())
  print(id); // eh82waoo5fi41lgncwv5oxxb
  print(id30); // oxjkyfqo3aqk3jigelnuyp3ef299qx
}
```

## Testing

a histogram analysis is done on every batch of tests to ensure a fair and random distribution across the whole entropy range. Any bias found during the analysis would increase the chances of ID collision and cause the tests to fail automatically.

![Histogram](https://i.imgur.com/07X7moo.png)