import birl.{now}
import birl/duration
import gleam/dict
import gleam/int
import gleam/io
import gleam/iterator
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/pair
import gleam/result

pub fn main() {
  let times = 20_000_000
  let counter_1 = build_big_counter(new(), times)
  let counter_2 = build_big_counter(new(), times)

  let a = now()
  // let counter_3 = counter_1 |> add(counter_2)
  counter_2 |> elements
  let duration =
    now() |> birl.difference(a) |> duration.blur_to(duration.MilliSecond)
  // io.debug(counter_3)
  io.debug(duration)
  // io.debug(counter_3 |> total)

  // let a = 10_000_001
  // 10_000_000
  // let c =
  //   iterator.range(0, 10_000_000)
  //   |> iterator.map(fn(_) { int.random(100) })
  //   |> iterator.fold(new(), fn(counter, num) { counter |> insert(num) })

  // c |> io.debug
  // c |> size |> io.debug
  // c |> total |> io.debug
}

fn build_big_counter(counter: Counter(Int), n: Int) -> Counter(Int) {
  let counter = counter |> update([1, 2, 3])

  case n > 0 {
    True -> build_big_counter(counter, n - 1)
    False -> counter
  }
}

pub opaque type Counter(a) {
  Counter(d: dict.Dict(a, Int))
}

pub fn new() -> Counter(a) {
  Counter(d: dict.new())
}

// TODO: Name?
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
  |> list.reduce(fn(a, b) { a + b })
  |> result.unwrap(0)
}

pub fn most_common(counter: Counter(a), n: Option(Int)) -> List(#(a, Int)) {
  let counter =
    counter
    |> to_dict
    |> dict.to_list
    // This could be made more efficient by not sorting the whole list in the case of n = Some(Int)
    |> list.sort(fn(a, b) { int.compare(b.1, a.1) })

  case n {
    Some(n) -> counter |> list.take(n)
    None -> counter
  }
}

pub fn elements(counter: Counter(a)) -> List(a) {
  counter.d
  |> dict.to_list
  |> list.fold([], fn(items, item) {
    prepend_repeated_item(item.0, item.1, items)
  })
}

// Can this be turned into some more gleam-like code?
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
  dict.combine(counter_1.d, counter_2.d, fn(a, b) { a + b }) |> Counter
}

pub fn subtract(counter_1: Counter(a), counter_2: Counter(a)) -> Counter(a) {
  let dict_1 = counter_1.d
  let dict_2 = counter_2.d

  // TODO: Better names
  let diff = dict.drop(dict_2, dict.keys(dict_1))
  let diff_2 = dict.drop(dict_2, dict.keys(diff))

  dict.combine(dict_1, diff_2, fn(a, b) { a - b })
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
// Decide if we want to wrap more dict functions or delete them in favor of to_dict and from_dict
