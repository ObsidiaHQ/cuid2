import 'package:cuid2/cuid2.dart';

void main() {
  final id = cuid();
  final id30 = cuidSecure(30);

  Function myCounter(int start) {
    return () => start += 5;
  }

  String myfingerprint() {
    return "klsdflsdflvcxlkaweporweqwqs";
  }

  final myCuid = cuidConfig(counter: myCounter(0), fingerprint: myfingerprint);
  final idc = myCuid.gen();

  print(id); // eh82waoo5fi41lgncwv5oxxb
  print(id30); // oxjkyfqo3aqk3jigelnuyp3ef299qx
  print(idc); // xh32wamo5gi41lgncwv3aqk3
}
