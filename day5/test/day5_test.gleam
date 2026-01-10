import day5
import gleam/list
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

const input = "3-5
5-5
6-6
10-14
16-20
12-18

1
5
8
11
17
32"

const test_ranges = [#(3, 5), #(5, 5), #(6, 6), #(10, 14), #(16, 20), #(12, 18)]

const flat_ranges = [#(3, 5), #(6, 6), #(10, 20)]

const test_ingredients = [1, 5, 8, 11, 17, 32]

pub fn parse_input_test() {
  let puzzle = day5.parse_input(input)

  zip_assert(test_ranges, puzzle.ranges)
  zip_assert(test_ingredients, puzzle.ingredients)
}

pub fn flatten_ranges_test() {
  let puzzle = day5.parse_input(input) |> day5.flatten
  echo puzzle.ranges
  zip_assert(flat_ranges, puzzle.ranges)
}

pub fn part1_test() {
  let puzzle = day5.parse_input(input) |> day5.flatten

  assert day5.part1(puzzle) == 3
}

pub fn part2_test() {
  let puzzle = day5.parse_input(input) |> day5.flatten

  assert day5.part2(puzzle) == 15
}

fn zip_assert(expected: List(value), to_test: List(value)) {
  expected
  |> list.zip(to_test)
  |> list.each(fn(e) {
    assert e.0 == e.1
  })
}
