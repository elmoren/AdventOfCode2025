import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn part_1(input: List(String)) -> Int {
  case input {
    [first, ..rest] -> {
      let start: Int =
        first
        |> string.split_once("S")
        |> result.unwrap(#("", ""))
        |> fn(v) { string.length(v.0) }

      trace(start, rest)
    }

    _ -> panic as "Invalid input"
  }
}

pub fn trace(start: Int, lines: List(String)) -> Int {
  let r =
    list.fold(lines, #(0, [start]), fn(acc, v) {
      let splits: List(Int) = find_splitters(v)
      let n = trace_fold(acc.1, splits)
      #(acc.0 + n.0, n.1)
    })

  r.0
}

pub fn trace_fold(rays: List(Int), splitters: List(Int)) -> #(Int, List(Int)) {
  let r =
    list.fold(rays, #(0, []), fn(acc, r) {
      case list.contains(splitters, r) {
        False -> {
          #(acc.0, list.prepend(acc.1, r))
        }
        True -> {
          #(acc.0 + 1, list.prepend(acc.1, r - 1) |> list.prepend(r + 1))
        }
      }
    })
  #(r.0, list.unique(r.1))
}

pub fn find_splitters(line: String) -> List(Int) {
  line
  |> string.to_graphemes()
  |> list.index_fold([], fn(acc, v, idx) {
    case v {
      "^" -> list.prepend(acc, idx)
      _ -> acc
    }
  })
}

pub fn main() -> Nil {
  case simplifile.read("input.txt") {
    Ok(input) -> {
      let lines = string.split(input, "\n")

      let part1 = part_1(lines)

      io.println("Part 1: " <> int.to_string(part1))
      io.println("Part 2: ")
    }
    Error(_e) -> panic as "Cannot read file"
  }
}
