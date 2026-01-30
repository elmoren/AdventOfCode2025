import day10
import gleam/int
import gleam/list
import gleam/result
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn new_machine_test() {
  let machine =
    day10.new_machine(
      "[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}",
    )
  assert result.is_ok(machine) == True
  use m <- result.map(machine)
  assert Ok(m.lights) == int.base_parse("101110", 2)
  echo m
}

pub fn part_1_test() {
  let machines = [
    "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}",
    "[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}",
    "[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}",
  ]

  let answers = [2, 3, 2]

  list.zip(machines, answers)
  |> list.each(fn(v) {
    let assert Ok(r) = day10.new_machine(v.0)
    assert day10.solve(r) == v.1
  })
}
