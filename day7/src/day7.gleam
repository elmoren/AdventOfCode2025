import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn solve(input: List(String)) -> #(Int, Int) {
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

pub fn trace(start: Int, lines: List(String)) -> #(Int, Int) {
  let timelines: dict.Dict(Int, Int) =
    dict.new()
    |> dict.insert(start, 1)
  let r =
    list.fold(lines, #(0, [start], timelines), fn(acc, v) {
      let splits: List(Int) = find_splitters(v)
      let n = trace_fold(acc.1, splits, acc.2)
      #(acc.0 + n.0, n.1, n.2)
    })

  let part2 =
    r.2
    |> dict.values
    |> int.sum

  #(r.0, part2)
}

pub fn trace_fold(
  rays: List(Int),
  splitters: List(Int),
  timelines: dict.Dict(Int, Int),
) -> #(Int, List(Int), dict.Dict(Int, Int)) {
  let r =
    list.fold(rays, #(0, [], timelines), fn(acc, r) {
      case list.contains(splitters, r) {
        False -> {
          #(acc.0, list.prepend(acc.1, r), acc.2)
        }
        True -> {
          let prev =
            dict.get(acc.2, r)
            |> result.unwrap(0)
          let left =
            dict.get(acc.2, r - 1)
            |> result.unwrap(0)
          let right =
            dict.get(acc.2, r + 1)
            |> result.unwrap(0)
          let new =
            acc.2
            |> dict.insert(r - 1, prev + left)
            |> dict.insert(r, 0)
            |> dict.insert(r + 1, prev + right)

          #(acc.0 + 1, list.prepend(acc.1, r - 1) |> list.prepend(r + 1), new)
        }
      }
    })

  #(r.0, list.unique(r.1), r.2)
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

      let result = solve(lines)
      io.println("Part 1: " <> int.to_string(result.0))
      io.println("Part 2: " <> int.to_string(result.1))
    }
    Error(_e) -> panic as "Cannot read file"
  }
}
