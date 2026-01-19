import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/set.{type Set}
import gleam/string
import simplifile

pub type Point {
  Point(x: Int, y: Int, z: Int)
}

pub fn parse(input: List(String)) -> List(Point) {
  input
  |> list.map(fn(v) {
    string.split(v, ",")
    |> list.map(int.parse)
    |> list.map(fn(v) {
      case v {
        Ok(v) -> v
        Error(Nil) -> panic as "Invalid parse"
      }
    })
  })
  |> list.map(fn(v) {
    case v {
      [x, y, z] -> Point(x:, y:, z:)
      _ -> panic as "Unexpected input size"
    }
  })
}

pub fn distance(a: Point, b: Point) -> Result(Float, Nil) {
  let dx = b.x - a.x
  let dy = b.y - a.y
  let dz = b.z - a.z

  int.square_root(dx * dx + dy * dy + dz * dz)
}

pub fn find(haystack: List(set.Set(Point)), needle: Point) -> Option(Set(Point)) {
  haystack
  |> list.find(fn(e) { set.contains(e, needle) })
  |> option.from_result
}

pub fn part1(boxes: List(Point), len: Int) -> Int {
  list.combination_pairs(boxes)
  |> list.sort(fn(a, b) {
    let d1 =
      distance(a.0, a.1)
      |> result.unwrap(0.0)

    let d2 =
      distance(b.0, b.1)
      |> result.unwrap(0.0)

    float.compare(d1, d2)
  })
  |> list.take(len)
  |> list.fold([], fn(acc, v) {
    // Find existing. Each point should exist exactly once in the sets
    let c1 = find(acc, v.0)
    let c2 = find(acc, v.1)

    // Remove the sets that were found
    let rest =
      acc
      |> list.filter(fn(s) {
        case c1 {
          Some(_c) -> !set.contains(s, v.0)
          None -> True
        }
      })
      |> list.filter(fn(s) {
        case c2 {
          Some(_c) -> !set.contains(s, v.1)
          None -> True
        }
      })

    case c1, c2 {
      None, Some(s) -> [set.insert(s, v.0), ..rest]
      Some(s), None -> [set.insert(s, v.1), ..rest]
      Some(s1), Some(s2) -> [set.union(s1, s2), ..rest]
      None, None -> [set.from_list([v.0, v.1]), ..rest]
    }
  })
  |> list.map(fn(s) { set.size(s) })
  |> list.sort(int.compare)
  |> list.reverse
  |> list.take(3)
  |> list.fold(1, fn(acc, s) { acc * s })
}

pub fn main() -> Nil {
  case simplifile.read("input.txt") {
    Ok(input) -> {
      let points =
        string.split(input, "\n")
        |> parse

      io.println("Part 1: " <> int.to_string(part1(points, 1000)))
      io.println("Part 2: ")
    }

    Error(_e) -> panic as "Cannot read file"
  }
}
