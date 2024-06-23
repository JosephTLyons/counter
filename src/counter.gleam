import birl.{now}
import gleam/dict
import gleam/int
import gleam/io
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
  let b = now()

  // io.debug(counter_3)
  io.debug(birl.difference(b, a))
  // io.debug(counter_3 |> total)
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
  |> dict.to_list
  |> list.map(pair.second)
}

pub fn keys(counter: Counter(a)) -> List(a) {
  counter.d
  |> dict.to_list
  |> list.map(pair.first)
}

pub fn elements(counter: Counter(a)) -> List(a) {
  counter.d
  |> dict.to_list
  |> list.map(fn(a) { list.repeat(a.0, a.1) })
  |> list.flatten
}

pub fn elements_2(counter: Counter(a)) -> List(a) {
  counter.d
  |> dict.to_list
  |> do_elem([])
}

fn do_elem(items: List(#(a, Int)), acc: List(a)) -> List(a) {
  case items {
    [] -> acc
    [first, ..rest] -> {
      let acc = do_elements_2(first.0, first.1, acc)
      do_elem(rest, acc)
    }
  }
}

fn do_elements_2(item: a, times: Int, acc: List(a)) -> List(a) {
  case times > 0 {
    True -> do_elements_2(item, times - 1, [item, ..acc])
    False -> acc
  }
}

pub fn from_list(items: List(a)) -> Counter(a) {
  do_from_list(items, new())
}

fn do_from_list(items: List(a), acc: Counter(a)) -> Counter(a) {
  case items {
    [] -> acc
    [first, ..rest] -> {
      let acc = acc |> insert(first)
      do_from_list(rest, acc)
    }
  }
}

pub fn update(counter: Counter(a), items: List(a)) -> Counter(a) {
  do_from_list(items, counter)
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
// Look at code and see what all non-required inputs there are
