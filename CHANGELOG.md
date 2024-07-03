# Changelog

## v1.0.2 - 2024-07-03

Breaking changes:

- Renamed `size()` to `unique_size()`. Having both a `total()` and a `size()` function is confusing - hopefully this is clearer.
- `most_common()` has been split into `most_common()` and `most_common_n()`. Previously, the signature was:

```gleam
pub fn most_common(counter: Counter(a), n: Option(Int)) -> List(#(a, Int))
```

The new signatures are:

```gleam
pub fn most_common(counter: Counter(a)) -> List(#(a, Int))
pub fn most_common_n(counter: Counter(a), n: Int) -> List(#(a, Int))
```

Trying to replicate Python's `most_common()` method, which uses a default argument, doesn't quite translate nicely to Gleam. Having to provide `option.None`, when you want the entire list, reads a bit oddly. Now, you can just call `most_common()` and it will return the entire list. If you want the top `n` most common items, call `most_common_n()`.

## v1.0.1 - 2024-06-28

- Fixed some documentation.
- Made `[startest](https://github.com/maxdeviant/startest/tree/main)` a dev dependency.

## v1.0.0 - 2024-06-28

- Initial release.
