import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/pair
import gleam/result

pub opaque type Counter(a) {
  Counter(d: dict.Dict(a, Int))
}

pub fn new() -> Counter(a) {
  Counter(d: dict.new())
}

pub fn insert(counter: Counter(a), item: a) -> Counter(a) {
  counter.d
  |> dict.update(item, fn(count) { { count |> option.unwrap(0) } + 1 })
  |> Counter
}

pub fn get(counter: Counter(a), item: a) -> Int {
  counter.d |> dict.get(item) |> result.unwrap(0)
}

pub fn total(counter: Counter(a)) -> Int {
  counter.d
  |> dict.to_list
  |> list.map(pair.second)
  |> int.sum
}

pub fn items(counter: Counter(a)) -> List(#(a, Int)) {
  counter.d
  |> dict.to_list
}

pub fn most_common(counter: Counter(a), n: Option(Int)) -> List(#(a, Int)) {
  let counter =
    counter
    |> items
    // This could be made more efficient by not sorting the whole list in the case of n = Some(Int)
    |> list.sort(fn(a, b) { int.compare(b.1, a.1) })

  case n {
    Some(n) -> counter |> list.take(n)
    None -> counter
  }
}

pub fn values(counter: Counter(a)) -> List(Int) {
  counter.d
  |> dict.values
}

pub fn elements(counter: Counter(a)) -> List(a) {
  counter.d
  |> dict.to_list
  |> list.fold([], fn(items, item) {
    prepend_repeated_item(item.0, item.1, items)
  })
}

// Can this be turned into some more gleam-like code, while avoiding list.flatten()?
fn prepend_repeated_item(item: a, times: Int, acc: List(a)) -> List(a) {
  case times > 0 {
    True -> prepend_repeated_item(item, times - 1, [item, ..acc])
    False -> acc
  }
}

pub fn from_list(items: List(a)) -> Counter(a) {
  update(new(), items)
}

pub fn update(counter: Counter(a), items: List(a)) -> Counter(a) {
  items |> list.fold(counter, fn(counter, item) { counter |> insert(item) })
}

pub fn add(counter_1: Counter(a), counter_2: Counter(a)) -> Counter(a) {
  dict.combine(counter_1.d, counter_2.d, int.add) |> Counter
}

pub fn subtract(counter_1: Counter(a), counter_2: Counter(a)) -> Counter(a) {
  let dict_1 = counter_1.d
  let dict_2 = counter_2.d

  // TODO: Better names
  let diff = dict.drop(dict_2, dict.keys(dict_1))
  let diff_2 = dict.drop(dict_2, dict.keys(diff))

  dict.combine(dict_1, diff_2, int.subtract)
  |> dict.filter(fn(_, b) { b > 0 })
  |> Counter
}

pub fn to_dict(counter: Counter(a)) -> dict.Dict(a, Int) {
  counter.d
}

pub fn from_dict(d: dict.Dict(a, Int)) -> Counter(a) {
  d |> Counter
}
// Look at code and see what all non-required inputs there are
