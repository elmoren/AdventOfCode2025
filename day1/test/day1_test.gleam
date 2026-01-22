import day1
import gleam/list
import gleam/string
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

const input = "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82"

pub fn mod_test() {
  assert day1.mod(-1, 100) == 99
  assert day1.mod(101, 100) == 1
}

pub fn part_1_test() {
  let result =
    input
    |> string.split("\n")
    |> list.map(day1.parse)
    |> day1.solve(50, _)

  assert result.0 == 3
  assert result.1 == 6
}
