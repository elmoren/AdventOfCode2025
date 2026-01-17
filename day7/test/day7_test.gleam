import day7
import gleam/int
import gleam/list
import gleam/string
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

const input = ".......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
..............."

pub fn find_splitters_test() {
  assert day7.find_splitters(".......^.......") == [7]
  assert day7.find_splitters("^.^...^.....^.^") == [14, 12, 6, 2, 0]
}

pub fn trace_fold_test() {
  let r = day7.trace_fold([7], [7])
  assert #(r.0, list.sort(r.1, int.compare)) == #(1, [6, 8])

  let r = day7.trace_fold([7], [8])
  assert #(r.0, list.sort(r.1, int.compare)) == #(0, [7])

  let r = day7.trace_fold([7, 9], [7, 9])
  assert #(r.0, list.sort(r.1, int.compare)) == #(2, [6, 8, 10])
}

pub fn trace_test() {
  assert day7.part_1(string.split(input, "\n")) == 21
}
