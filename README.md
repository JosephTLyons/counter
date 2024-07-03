# counter

[![Package Version](https://img.shields.io/hexpm/v/counter)](https://hex.pm/packages/counter)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/counter/)

```sh
gleam add counter
```
```gleam
import counter
import gleam/io

pub fn main() {
  ["dog", "cat", "mouse", "dog", "dog", "cat"]
  |> counter.from_list
  |> counter.most_common
  |> io.debug // [#("dog", 3), #("cat", 2), #("mouse", 1)]
}

```
