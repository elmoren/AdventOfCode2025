import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub type Point {
  Point(x: Int, y: Int)
}

pub type Line {
  Line(a: Point, b: Point)
}

pub fn parse(line: String) -> Point {
  line
  |> string.split(",")
  |> list.map(int.parse)
  |> fn(parsed) {
    case parsed {
      [Ok(x), Ok(y)] -> Point(x:, y:)
      _ -> panic as "Invalid parse"
    }
  }
}

pub fn part_1(points: List(Point)) -> Int {
  points
  |> list.combination_pairs
  |> list.fold(0, fn(acc, v) {
    let area =
      { 1 + int.absolute_value({ v.0 }.x - { v.1 }.x) }
      * { 1 + int.absolute_value({ v.0 }.y - { v.1 }.y) }

    case area > acc {
      True -> area
      False -> acc
    }
  })
}

pub fn part_2(points: List(Point)) -> Int {
  let first = case list.first(points) {
    Ok(v) -> v
    Error(Nil) -> panic as "Invalid empty input"
  }

  points
  |> list.append([first])
  |> list.window_by_2
  |> list.map(fn(w) {
    let #(a, b) = w
    Line(a: Point(a.x, a.y), b: Point(b.x, b.y))
  })

  0
}

pub fn main() -> Nil {
  case simplifile.read("input.txt") {
    Ok(lines) -> {
      let points =
        lines
        |> string.split("\n")
        |> list.map(parse)

      let part1 = points |> part_1
      let part2 = points |> part_2

      io.println("Part 1: " <> int.to_string(part1))
      io.println("Part 2: " <> int.to_string(part2))
    }
    Error(e) -> panic as simplifile.describe_error(e)
  }
}
