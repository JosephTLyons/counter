import counter
import gleam/int
import gleam/list
import gleam/pair
import gleam/string
import gleeunit

pub fn main() {
  gleeunit.main()
}

pub fn insert_test() {
  let counter = counter.new()

  assert counter.get(counter, "a") == 0

  let counter = counter |> counter.insert("a")

  assert counter.get(counter, "a") == 1

  let counter = counter |> counter.insert("b")

  assert counter.get(counter, "b") == 1

  let counter = counter |> counter.insert("b") |> counter.insert("b")

  assert counter.get(counter, "b") == 3
}

pub fn total_test() {
  let counter = counter.new()

  assert counter.total(counter) == 0

  let counter = counter |> counter.insert("a")

  assert counter.total(counter) == 1

  let counter = counter |> counter.insert("b")

  assert counter.total(counter) == 2

  let counter = counter |> counter.insert("a") |> counter.insert("a")

  assert counter.total(counter) == 4
}

pub fn items_test() {
  let counter = counter.new()

  assert counter.to_list(counter) == []

  let counter = counter |> counter.insert("dog")
  assert counter.to_list(counter) == [#("dog", 1)]

  let counter = counter |> counter.insert("cat")

  assert counter
    |> counter.to_list
    |> list.sort(fn(a, b) { string.compare(pair.first(a), pair.first(b)) })
    == [#("cat", 1), #("dog", 1)]

  let counter = counter |> counter.insert("dog") |> counter.insert("dog")

  assert counter
    |> counter.to_list
    |> list.sort(fn(a, b) { string.compare(pair.first(a), pair.first(b)) })
    == [#("cat", 1), #("dog", 3)]
}

pub fn most_common_test() {
  let counter = counter.new()

  assert counter.most_common(counter) == []

  let counter = counter |> counter.insert("dog")
  assert counter.most_common(counter) == [#("dog", 1)]

  let counter = counter |> counter.insert("cat")
  assert counter.most_common(counter) == [#("cat", 1), #("dog", 1)]

  let counter = counter |> counter.insert("dog") |> counter.insert("dog")

  assert counter.most_common(counter) == [#("dog", 3), #("cat", 1)]

  let counter = counter |> counter.insert("cat") |> counter.insert("mouse")

  assert counter.most_common(counter)
    == [#("dog", 3), #("cat", 2), #("mouse", 1)]

  assert counter.most_common_n(counter, 2) == [#("dog", 3), #("cat", 2)]
}

pub fn values_test() {
  assert counter.from_list(["cat", "cat", "dog", "mouse"])
    |> counter.values
    |> list.sort(int.compare)
    == [1, 1, 2]
}

pub fn keys_test() {
  let counter = counter.new()

  assert counter.keys(counter) == []

  let counter = counter |> counter.insert("dog")
  assert counter.keys(counter) == ["dog"]

  let counter = counter |> counter.insert("cat")
  assert counter.keys(counter) == ["cat", "dog"]

  let counter = counter |> counter.insert("dog") |> counter.insert("dog")

  assert counter
    |> counter.keys
    |> list.sort(string.compare)
    == ["cat", "dog"]

  let counter = counter |> counter.insert("cat") |> counter.insert("mouse")

  assert counter
    |> counter.keys
    |> list.sort(string.compare)
    == ["cat", "dog", "mouse"]
}

pub fn elements_test() {
  let counter = counter.new()

  assert counter.elements(counter) == []

  let counter = counter |> counter.insert("dog")
  assert counter.elements(counter) == ["dog"]

  let counter = counter |> counter.insert("cat")
  assert counter
    |> counter.elements
    |> list.sort(string.compare)
    == ["cat", "dog"]

  let counter = counter |> counter.insert("dog") |> counter.insert("dog")

  assert counter
    |> counter.elements
    |> list.sort(string.compare)
    == ["cat", "dog", "dog", "dog"]
}

pub fn from_list_test() {
  assert counter.keys(counter.from_list([])) == []

  let items = ["dog"]

  assert counter.keys(counter.from_list(items)) == items

  let items = ["cat", "dog", "mouse"]

  assert counter.from_list(items)
    |> counter.keys
    |> list.sort(string.compare)
    == items
}

pub fn update_from_counter_test() {
  let counter = counter.from_list(["dog", "cat", "mouse"])
  let counter = counter |> counter.update(["bird", "duck", "hourse"])

  assert counter
    |> counter.keys
    |> list.sort(string.compare)
    == ["bird", "cat", "dog", "duck", "hourse", "mouse"]
}

pub fn add_test() {
  let counter_1 = counter.from_list(["dog", "cat", "mouse"])
  let counter_2 = counter.from_list(["dog", "moose", "bear"])
  let counter = counter_1 |> counter.add(counter_2)

  assert counter
    |> counter.elements
    |> list.sort(string.compare)
    == ["bear", "cat", "dog", "dog", "moose", "mouse"]
}

pub fn subtact_test() {
  let counter_1 = counter.from_list(["dog", "cat", "mouse"])
  let counter_2 = counter.from_list(["dog", "cat", "bear"])
  let counter = counter_1 |> counter.subtract(counter_2)

  assert counter
    |> counter.elements
    |> list.sort(string.compare)
    == ["mouse"]

  let counter_1 = counter.from_list(["dog", "cat", "mouse"])
  let counter_2 = counter.from_list(["dog", "dog", "cat"])
  let counter = counter_1 |> counter.subtract(counter_2)

  assert counter
    |> counter.elements
    |> list.sort(string.compare)
    == ["mouse"]
}
