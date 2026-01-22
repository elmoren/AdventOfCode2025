import day9
import gleam/list
import gleam/string
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

const input = "7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3"

pub fn part_1_test() {
  let r =
    input
    |> string.split("\n")
    |> list.map(day9.parse)
    |> day9.part_1

  assert r == 50
}

pub fn part_2_test() {
  let r =
    input
    |> string.split("\n")
    |> list.map(day9.parse)
    |> day9.part_2

  assert r == 24
}
