# counter

[![Package Version](https://img.shields.io/hexpm/v/counter)](https://hex.pm/packages/counter)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/counter/)

```sh
gleam add counter
```
```gleam
import counter
import gleam/io
import gleam/list
import gleam/option.{None}
import gleam/string

pub fn main() {
  [
    "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
    "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho",
    "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine",
    "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi",
    "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey",
    "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio",
    "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
    "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia",
    "Washington", "West Virginia", "Wisconsin", "Wyoming",
  ]
  |> list.map(fn(state) { state |> string.lowercase |> string.split("") })
  |> list.flatten
  |> counter.from_list
  |> counter.most_common(None)
  |> io.debug // [#("a", 61), #("i", 44), #("n", 43), ...]
}
```

Further documentation can be found at <https://hexdocs.pm/counter>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```
