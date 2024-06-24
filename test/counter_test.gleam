import counter
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/pair
import gleam/string
import gleeunit
import startest/expect

pub fn main() {
  gleeunit.main()
}

pub fn insert_test() {
  let counter = counter.new()

  counter |> counter.get(1) |> expect.to_equal(0)

  let counter = counter |> counter.insert(1)

  counter |> counter.get(1) |> expect.to_equal(1)

  let counter = counter |> counter.insert(2)

  counter |> counter.get(2) |> expect.to_equal(1)

  let counter = counter |> counter.insert(1)
  let counter = counter |> counter.insert(1)

  counter |> counter.get(1) |> expect.to_equal(3)
}

pub fn total_test() {
  let counter = counter.new()

  counter |> counter.total |> expect.to_equal(0)

  let counter = counter |> counter.insert(1)

  counter |> counter.total |> expect.to_equal(1)

  let counter = counter |> counter.insert(2)

  counter |> counter.total |> expect.to_equal(2)

  let counter = counter |> counter.insert(1)
  let counter = counter |> counter.insert(1)

  counter |> counter.total |> expect.to_equal(4)
}

pub fn items_test() {
  let counter = counter.new()

  counter |> counter.to_list |> expect.to_equal([])

  let counter = counter |> counter.insert("dog")
  counter |> counter.to_list |> expect.to_equal([#("dog", 1)])

  let counter = counter |> counter.insert("cat")
  counter
  |> counter.to_list
  |> list.sort(fn(a, b) { string.compare(pair.first(a), pair.first(b)) })
  |> expect.to_equal([#("cat", 1), #("dog", 1)])

  let counter = counter |> counter.insert("dog")
  let counter = counter |> counter.insert("dog")

  counter
  |> counter.to_list
  |> list.sort(fn(a, b) { string.compare(pair.first(a), pair.first(b)) })
  |> expect.to_equal([#("cat", 1), #("dog", 3)])
}

pub fn most_common_test() {
  let counter = counter.new()

  counter |> counter.most_common(None) |> expect.to_equal([])

  let counter = counter |> counter.insert("dog")
  counter |> counter.most_common(None) |> expect.to_equal([#("dog", 1)])

  let counter = counter |> counter.insert("cat")
  counter
  |> counter.most_common(None)
  |> expect.to_equal([#("cat", 1), #("dog", 1)])

  let counter = counter |> counter.insert("dog")
  let counter = counter |> counter.insert("dog")

  counter
  |> counter.most_common(None)
  |> expect.to_equal([#("dog", 3), #("cat", 1)])

  let counter = counter |> counter.insert("cat")
  let counter = counter |> counter.insert("mouse")

  counter
  |> counter.most_common(None)
  |> expect.to_equal([#("dog", 3), #("cat", 2), #("mouse", 1)])

  counter
  |> counter.most_common(Some(2))
  |> expect.to_equal([#("dog", 3), #("cat", 2)])
}

pub fn values_test() {
  counter.from_list(["cat", "cat", "dog", "mouse"])
  |> counter.values
  |> list.sort(int.compare)
  |> expect.to_equal([1, 1, 2])
}

pub fn keys_test() {
  let counter = counter.new()

  counter |> counter.keys |> expect.to_equal([])

  let counter = counter |> counter.insert("dog")
  counter |> counter.keys |> expect.to_equal(["dog"])

  let counter = counter |> counter.insert("cat")
  counter |> counter.keys |> expect.to_equal(["cat", "dog"])

  let counter = counter |> counter.insert("dog")
  let counter = counter |> counter.insert("dog")

  counter
  |> counter.keys
  |> list.sort(string.compare)
  |> expect.to_equal(["cat", "dog"])

  let counter = counter |> counter.insert("cat")
  let counter = counter |> counter.insert("mouse")

  counter
  |> counter.keys
  |> list.sort(string.compare)
  |> expect.to_equal(["cat", "dog", "mouse"])
}

pub fn elements_test() {
  let counter = counter.new()

  counter |> counter.elements |> expect.to_equal([])

  let counter = counter |> counter.insert("dog")
  counter |> counter.elements |> expect.to_equal(["dog"])

  let counter = counter |> counter.insert("cat")
  counter
  |> counter.elements
  |> list.sort(string.compare)
  |> expect.to_equal(["cat", "dog"])

  let counter = counter |> counter.insert("dog")
  let counter = counter |> counter.insert("dog")

  counter
  |> counter.elements
  |> list.sort(string.compare)
  |> expect.to_equal(["cat", "dog", "dog", "dog"])
}

pub fn from_list_test() {
  counter.from_list([]) |> counter.keys |> expect.to_equal([])

  let items = ["dog"]

  counter.from_list(items) |> counter.keys |> expect.to_equal(items)

  let items = ["cat", "dog", "mouse"]

  counter.from_list(items)
  |> counter.keys
  |> list.sort(string.compare)
  |> expect.to_equal(items)
}

pub fn update_from_counter_test() {
  let counter = counter.from_list(["dog", "cat", "mouse"])
  let counter = counter |> counter.update(["bird", "duck", "hourse"])

  counter
  |> counter.keys
  |> list.sort(string.compare)
  |> expect.to_equal(["bird", "cat", "dog", "duck", "hourse", "mouse"])
}

pub fn add_test() {
  let counter_1 = counter.from_list(["dog", "cat", "mouse"])
  let counter_2 = counter.from_list(["dog", "moose", "bear"])
  let counter = counter_1 |> counter.add(counter_2)

  counter
  |> counter.elements
  |> list.sort(string.compare)
  |> expect.to_equal(["bear", "cat", "dog", "dog", "moose", "mouse"])
}

pub fn subtact_test() {
  let counter_1 = counter.from_list(["dog", "cat", "mouse"])
  let counter_2 = counter.from_list(["dog", "cat", "bear"])
  let counter = counter_1 |> counter.subtract(counter_2)

  counter
  |> counter.elements
  |> list.sort(string.compare)
  |> expect.to_equal(["mouse"])

  let counter_1 = counter.from_list(["dog", "cat", "mouse"])
  let counter_2 = counter.from_list(["dog", "dog", "cat"])
  let counter = counter_1 |> counter.subtract(counter_2)

  counter
  |> counter.elements
  |> list.sort(string.compare)
  |> expect.to_equal(["mouse"])
}
