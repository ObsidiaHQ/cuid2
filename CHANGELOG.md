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

- **[BREAKING]** remove `entropyLength` param from `cuid()` and `cuidSecure()`

## 3.0.0

- refactor code and bring it up to cuid2,js v2.2.0
- add more tests
- **[POSSIBLE BREAKING CHANGE]** `counter` parameter function is now of type `int Function()?` instead of `Function?`
