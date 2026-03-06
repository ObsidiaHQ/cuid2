## 4.1.0

- Migrated `dart:html` to `package:web` (now a dependency).
- SDK constraint updated to `>=3.4.0 <4.0.0`.
- Updated dependencies.

---

## 4.0.0

- Add **CLI** (`dart run cuid2` or `cuid2`).
- Add `throwIfInsecure` option: when set, throws `UnsupportedError` if secure RNG is unavailable instead of falling back to non-secure `Random()`.
- Add optional custom `random` (e.g. `double Function()`) to `cuidConfig` for injectable RNG.
- **`isCuid`**: validation now requires first character to be a letter `[a-z]` (per CUID2 spec).
- **`cuid` / `cuidSecure`**: default length uses `Cuid.defaultLength`; `cuidSecure` uses secure RNG and rethrows `UnsupportedError` when secure RNG is unavailable.
- SDK constraint updated to `>=3.0.0 <4.0.0`.
- Updated dependencies.

### Breaking changes

- **`cuidConfig`**
  - `fingerprint` is now `String?` (value), not `String Function()?`.
  - `secure` removed; use `throwIfInsecure: true` to require secure RNG and fail otherwise.
- **`Cuid`**
  - Constructor uses named parameters; `fingerprint` on `Cuid` instances is now `String?` (use `cuid.fingerprint` instead of `cuid.fingerprint!()`).
- **`isCuid`**
  - Strings that start with a digit are no longer considered valid.

---

## 3.1.0

- Fix fingerprinting on web.
- Increase min SDK version from 2.12.0 to 2.14.0.

## 3.0.0

- Refactor code and bring it up to cuid2.js v2.2.0.
- Add more tests.
- **[BREAKING]** `counter` parameter is now `int Function()?` instead of `Function?`.

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

- **[BREAKING]** Remove `entropyLength` param from `cuid()` and `cuidSecure()`.

## 1.0.0

- Initial version.
