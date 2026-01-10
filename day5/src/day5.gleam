import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type Range =
  #(Int, Int)

pub type Ranges =
  List(Range)

pub type Ingredients =
  List(Int)

pub type PuzzleInput {
  PuzzleInput(ranges: Ranges, ingredients: Ingredients)
}

pub fn parse_input(input) -> PuzzleInput {
  let parts =
    string.split(input, "\n")
    |> list.split_while(fn(e) { !string.is_empty(e) })

  let ranges =
    parts.0
    |> list.try_map(fn(e) { string.split_once(e, "-") })
    |> result.unwrap(list.new())
    |> list.map(fn(t) {
      #(result.unwrap(int.parse(t.0), 0), result.unwrap(int.parse(t.1), 0))
    })

  let ingredients =
    parts.1
    |> list.drop(1)
    |> list.map(int.parse)
    |> list.map(fn(e) {
      case e {
        Ok(v) -> v
        Error(_e) -> panic as "Invalid input"
      }
    })

  PuzzleInput(ranges:, ingredients:)
}

pub fn flatten(puzzle: PuzzleInput) -> PuzzleInput {
  PuzzleInput(
    ranges: flatten_range(puzzle.ranges),
    ingredients: puzzle.ingredients,
  )
}

fn flatten_range(input: Ranges) -> Ranges {
  list.fold(input, [], fn(acc, x) { add_to_range(acc, x) })
}

fn range_overlaps(a: Range, b: Range) -> Bool {
  a.0 <= b.1 && b.0 <= a.1
}

fn add_to_range(ranges: Ranges, to_add: Range) -> Ranges {
  let parts = list.partition(ranges, fn(r) { range_overlaps(r, to_add) })

  let combined =
    parts.0
    |> list.fold(to_add, fn(acc, x) {
      #(int.min(acc.0, x.0), int.max(acc.1, x.1))
    })

  list.prepend(parts.1, combined)
  |> list.sort(fn(a, b) { int.compare(a.0, b.0) })
}

pub fn is_fresh(ingredient, fresh: Ranges) {
  list.any(fresh, fn(r) { r.0 <= ingredient && r.1 >= ingredient })
}

pub fn part1(puzzle: PuzzleInput) -> Int {
  puzzle.ingredients
  |> list.count(is_fresh(_, puzzle.ranges))
}

pub fn part2(puzzle: PuzzleInput) -> Int {
  list.fold(puzzle.ranges, 0, fn(acc, e) { e.1 - e.0 + acc + 1 })
}

pub fn main() -> Nil {
  case simplifile.read("input.txt") {
    Ok(input) -> {
      let puzzle = parse_input(input) |> flatten
      let part_1 = part1(puzzle)
      let part_2 = part2(puzzle)

      io.println("Part 1: " <> int.to_string(part_1))
      io.println("Part 2: " <> int.to_string(part_2))
    }
    Error(_e) -> io.println("Error parsing file")
  }
}
