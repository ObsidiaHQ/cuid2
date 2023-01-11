import 'package:cuid2/cuid2.dart';

void main() {
  final id = cuid();
  final id30 = cuidSecure(30);

  print(id); // eh82waoo5fi41lgncwv5oxxb
  print(id30); // oxjkyfqo3aqk3jigelnuyp3ef299qx
}
