import day6
import gleam/dict
import gleam/list
import gleam/string
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

const input = "123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  "

const operators = ["*", "+", "*", "+"]

pub fn parse_input_test() {
  let puzzle = day6.parse_input(string.split(input, "\n"))

  operators
  |> list.index_map(fn(v, idx) {
    assert dict.get(puzzle.operators, idx) == Ok(v)
  })

  assert dict.get(puzzle.operands, #(0, 0)) == Ok(123)
  assert dict.get(puzzle.operands, #(0, 3)) == Ok(64)
  assert dict.get(puzzle.operands, #(2, 0)) == Ok(6)
  assert dict.get(puzzle.operands, #(2, 3)) == Ok(314)
}

pub fn part1_test() {
  let puzzle = day6.parse_input(string.split(input, "\n"))

  assert day6.part1(puzzle) == 4_277_556
}

pub fn part2_test() {
  assert day6.part2(string.split(input, "\n")) == 3_263_827
}
