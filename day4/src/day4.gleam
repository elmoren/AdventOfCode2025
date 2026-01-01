import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

type Point =
  #(Int, Int)

type PuzzleMap =
  dict.Dict(Point, String)

pub fn parse_input(input: String) -> PuzzleMap {
  input
  |> string.split("\n")
  |> list.index_fold(dict.new(), fn(acc, line, i) {
    list.index_fold(string.to_graphemes(line), acc, fn(acc, c, j) {
      case c {
        "@" -> dict.insert(acc, #(i, j), c)
        _ -> acc
      }
    })
  })
}

pub fn count_neighbors(puzzle_map: PuzzleMap, point: Point) -> Int {
  let neighbors = [
    #(point.0 - 1, point.1 - 1),
    #(point.0 - 1, point.1),
    #(point.0 - 1, point.1 + 1),
    #(point.0, point.1 - 1),
    #(point.0, point.1 + 1),
    #(point.0 + 1, point.1 - 1),
    #(point.0 + 1, point.1),
    #(point.0 + 1, point.1 + 1),
  ]

  neighbors
  |> list.filter_map(fn(pos) { dict.get(puzzle_map, pos) })
  |> list.length
}

pub fn part1(matrix: PuzzleMap) -> Int {
  dict.filter(matrix, fn(_k, v) { v == "@" })
  |> dict.keys
  |> list.map(count_neighbors(matrix, _))
  |> list.count(fn(e) { e < 4 })
}

pub fn part2(matrix: PuzzleMap) -> Int {
  dict.size(matrix) - dict.size(remove_rolls(matrix))
}

fn remove_rolls(matrix: PuzzleMap) -> PuzzleMap {
  let to_remove =
    dict.filter(matrix, fn(_k, v) { v == "@" })
    |> dict.keys
    |> list.filter(fn(k) { count_neighbors(matrix, k) < 4 })

  case list.length(to_remove) {
    l if l > 0 -> {
      remove_rolls(dict.drop(matrix, to_remove))
    }
    _ -> matrix
  }
}

pub fn main() -> Nil {
  case simplifile.read(from: "input.txt") {
    Ok(input) -> {
      let puzzle_map = parse_input(input)

      io.println("Part 1: " <> int.to_string(part1(puzzle_map)))
      io.println("Part 2: " <> int.to_string(part2(puzzle_map)))
    }
    Error(_e) -> io.println("Error reading file")
  }
}
