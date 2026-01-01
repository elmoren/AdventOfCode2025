import day4
import gleam/dict
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

const input = "..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@."

pub fn part1_parse_test() {
  let d = day4.parse_input(input)

  assert dict.get(d, #(0, 3)) == Ok("@")
  assert dict.get(d, #(0, 4)) == Error(Nil)
  assert dict.get(d, #(0, 5)) == Ok("@")
  assert dict.get(d, #(6, 0)) == Error(Nil)
  assert dict.get(d, #(6, 1)) == Ok("@")
  assert dict.get(d, #(6, 2)) == Error(Nil)
}

pub fn count_neighbors_test() {
  let d = day4.parse_input(input)

  assert day4.count_neighbors(d, #(0, 0)) == 2
  assert day4.count_neighbors(d, #(0, 1)) == 4
  assert day4.count_neighbors(d, #(0, 9)) == 3
  assert day4.count_neighbors(d, #(3, 0)) == 4
  assert day4.count_neighbors(d, #(3, 1)) == 7
  assert day4.count_neighbors(d, #(3, 9)) == 5
  assert day4.count_neighbors(d, #(9, 0)) == 1
  assert day4.count_neighbors(d, #(9, 9)) == 2
}

pub fn part1_score_test() {
  let d = day4.parse_input(input)

  assert day4.part1(d) == 13
}

pub fn part2_score_test() {
  let d = day4.parse_input(input)

  assert day4.part2(d) == 43
}
