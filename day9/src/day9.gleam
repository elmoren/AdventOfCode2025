import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub type Point {
  Point(x: Int, y: Int)
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
  |> list.sort(fn(a, b) { int.compare(area(b.0, b.1), area(a.0, a.1)) })
  |> list.first
  |> fn(v) {
    case v {
      Ok(v) -> area(v.0, v.1)
      Error(_e) -> panic as "Invalid Point"
    }
  }
}

pub fn area(a: Point, b: Point) -> Int {
  { 1 + int.absolute_value({ a }.x - { b }.x) }
  * { 1 + int.absolute_value({ a }.y - { b }.y) }
}

pub fn part_2(points: List(Point)) -> Int {
  let lines = to_lines(points)

  points
  |> list.combination_pairs
  |> list.sort(fn(a, b) { int.compare(area(b.0, b.1), area(a.0, a.1)) })
  |> list.drop_while(fn(rect) { !is_rect_inside(rect, lines) })
  |> list.first
  |> fn(v) {
    case v {
      Ok(v) -> {
        area(v.0, v.1)
      }
      Error(_e) -> panic as "Invalid Point"
    }
  }
}

pub fn to_lines(points: List(Point)) -> List(#(Point, Point)) {
  let first = case list.first(points) {
    Ok(v) -> v
    Error(Nil) -> panic as "Invalid empty input"
  }

  points
  |> list.append([first])
  |> list.window_by_2
}

pub fn is_rect_inside(
  rect: #(Point, Point),
  lines: List(#(Point, Point)),
) -> Bool {
  let x_r =
    list.range({ rect.0 }.x, { rect.1 }.x)
    |> list.map(fn(x) { [Point(x, { rect.0 }.y), Point(x, { rect.1 }.y)] })
    |> list.flatten

  let x_y =
    list.range({ rect.0 }.y, { rect.1 }.y)
    |> list.map(fn(y) { [Point({ rect.0 }.x, y), Point({ rect.1 }.x, y)] })
    |> list.flatten

  list.flatten([x_r, x_y])
  |> list.unique
  |> list.all(fn(p) { is_point_inside(p, lines) })
}

pub fn is_point_inside(point: Point, lines: List(#(Point, Point))) -> Bool {
  let to_check =
    lines
    |> list.filter(fn(l) { int.max({ l.0 }.x, { l.1 }.x) >= point.x })
    |> list.filter(fn(l) {
      int.min({ l.0 }.y, { l.1 }.y) <= point.y
      && int.max({ l.0 }.y, { l.1 }.y) >= point.y
    })

  let point_on_line =
    to_check
    |> list.any(fn(l) {
      case { l.0 }.x == { l.1 }.x {
        True -> {
          let min_y = int.min({ l.0 }.y, { l.1 }.y)
          let max_y = int.max({ l.0 }.y, { l.1 }.y)
          point.x == { l.0 }.x && min_y <= point.y && max_y >= point.y
        }
        False -> {
          let min_x = int.min({ l.0 }.x, { l.1 }.x)
          let max_x = int.max({ l.0 }.x, { l.1 }.x)
          point.y == { l.0 }.y && min_x <= point.x && max_x >= point.x
        }
      }
    })

  case point_on_line {
    True -> True
    False -> {
      to_check
      |> list.filter(fn(l) { { l.0 }.x == { l.1 }.x })
      |> list.fold(0, fn(acc, line) {
        case { line.0 }.y > { line.1 }.y {
          True -> acc + 1
          False -> acc - 1
        }
      })
      |> fn(total) { total != 0 }
    }
  }
}

pub fn main() -> Nil {
  case simplifile.read("input.txt") {
    Ok(lines) -> {
      let points =
        lines
        |> string.split("\n")
        |> list.map(parse)

      let part1 = points |> part_1
      io.println("Part 1: " <> int.to_string(part1))

      let part2 = points |> part_2
      io.println("Part 2: " <> int.to_string(part2))
    }
    Error(e) -> panic as simplifile.describe_error(e)
  }
}
