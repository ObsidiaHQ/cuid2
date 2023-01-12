## 1.0.0

- Initial version.

## 2.0.0

- Add `cuidConfig()` for more customizability.
- Example: 
```dart
Function myCounter(int start) {
    return () => start += 5;
}

final cc = cuidConfig(counter: myCounter(0));
final id = cc.gen();
```
- __[BREAKING]__ remove `entropyLength` param from `cuid()` and `cuidSecure()`