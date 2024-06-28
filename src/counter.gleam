import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/pair
import gleam/result

/// A `Counter` is a specialized dictionary used for counting the occurrences of items. `Counter` is implemented using the `gleam/dict` module.
pub opaque type Counter(a) {
  Counter(d: dict.Dict(a, Int))
}

/// Creates a new empty `Counter`.
pub fn new() -> Counter(a) {
  Counter(d: dict.new())
}

/// Inserts an item into the `Counter`.
pub fn insert(counter: Counter(a), item: a) -> Counter(a) {
  counter.d
  |> dict.update(item, fn(count) { { count |> option.unwrap(0) } + 1 })
  |> Counter
}

/// Returns the number of times an item has been inserted into the `Counter`.
pub fn get(counter: Counter(a), item: a) -> Int {
  counter.d |> dict.get(item) |> result.unwrap(0)
}

/// Returns the sum of all counts in the `Counter`.
pub fn total(counter: Counter(a)) -> Int {
  counter.d
  |> dict.to_list
  |> list.map(pair.second)
  |> int.sum
}

/// Returns a list containing of item-count tuples, sorted by count in descending order.
/// If `n` is `None`, the entire list is returned. If `n` is `Some(Int)`, at most `n` items are returned.
pub fn most_common(counter: Counter(a), n: Option(Int)) -> List(#(a, Int)) {
  let counter =
    counter
    |> to_list
    // This could probably be made more efficient by not sorting the whole list in the case of n = Some(Int)
    |> list.sort(fn(a, b) { int.compare(b.1, a.1) })

  case n {
    Some(n) -> counter |> list.take(n)
    None -> counter
  }
}

/// Returns a list of all the unique items in the `Counter`.
pub fn keys(counter: Counter(a)) -> List(a) {
  counter.d
  |> dict.keys
}

/// Returns a list of all the counts in the `Counter`.
pub fn values(counter: Counter(a)) -> List(Int) {
  counter.d
  |> dict.values
}

/// Returns a non-unique list of all the items in the `Counter`. Each item will be repeated in the list the number of times it was inserted into the `Counter`.
pub fn elements(counter: Counter(a)) -> List(a) {
  counter.d
  |> dict.to_list
  |> list.fold([], fn(items, item) {
    prepend_repeated_item(item.0, item.1, items)
  })
}

fn prepend_repeated_item(item: a, times: Int, acc: List(a)) -> List(a) {
  use <- bool.guard(times <= 0, acc)
  prepend_repeated_item(item, times - 1, [item, ..acc])
}

/// Updates the `Counter` from a list of items.
pub fn update(counter: Counter(a), items: List(a)) -> Counter(a) {
  items |> list.fold(counter, fn(counter, item) { counter |> insert(item) })
}

/// Add the counts from two `Counter`s into a new `Counter`.
pub fn add(counter_1: Counter(a), counter_2: Counter(a)) -> Counter(a) {
  dict.combine(counter_1.d, counter_2.d, int.add) |> Counter
}

/// Subtracts the counts in the second `Counter` from the first `Counter`, returning a new `Counter` with the results.
/// Only items present in both `Counter`s will be used when subtracting counts from the first `Counter` and any item with a count of zero or less will be omitted from the new `Counter`.
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

/// Returns the number of unique items in the `Counter`.
pub fn size(counter: Counter(a)) -> Int {
  counter.d |> dict.size
}

/// Returns a list of item-count tuples.
pub fn to_list(counter: Counter(a)) -> List(#(a, Int)) {
  counter.d
  |> dict.to_list
}

/// Creates a `Counter` from a list of items.
pub fn from_list(items: List(a)) -> Counter(a) {
  update(new(), items)
}

/// Returns the underlying `gleam/dict` of the `Counter`.
pub fn to_dict(counter: Counter(a)) -> dict.Dict(a, Int) {
  counter.d
}

/// Creates a `Counter` from a `gleam/dict` of item-count pairs.
pub fn from_dict(d: dict.Dict(a, Int)) -> Counter(a) {
  d |> Counter
}
