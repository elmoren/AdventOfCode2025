import day10
import gleam/int
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
