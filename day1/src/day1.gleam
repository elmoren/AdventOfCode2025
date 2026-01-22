import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

const max = 100

pub fn parse(line: String) -> Int {
  case string.pop_grapheme(line) {
    Ok(#("R", len)) -> int.parse(len) |> result.unwrap(0)
    Ok(#("L", len)) -> int.parse(len) |> result.unwrap(0) |> int.negate
    _ -> panic as "Invalid input"
  }
}

// 
pub fn mod(a: Int, b: Int) -> Int {
  { { { a % b } + b } % b }
}

pub fn solve(start: Int, steps: List(Int)) -> #(Int, Int) {
  steps
  |> list.fold(#(start, 0, 0), fn(acc, c) {
    let wraps = int.absolute_value(c) / max
    let next = acc.0 + { c % 100 }
    let dial = mod(next, max)

    let extra = case acc.0 {
      0 -> 0
      _ -> {
        case next {
          n if n <= 0 -> 1
          n if n >= 100 -> 1
          _ -> 0
        }
      }
    }

    case dial {
      0 -> #(dial, acc.1 + 1, acc.2 + wraps + extra)
      _ -> #(dial, acc.1, acc.2 + wraps + extra)
    }
  })
  |> fn(v) { #(v.1, v.2) }
}

pub fn main() -> Nil {
  case simplifile.read("input.txt") {
    Ok(input) -> {
      let steps = input |> string.split("\n") |> list.map(parse)
      let result = steps |> solve(50, _)

      io.println("Part 1: " <> int.to_string(result.0))
      io.println("Part 2: " <> int.to_string(result.1))
    }
    Error(e) -> panic as simplifile.describe_error(e)
  }
}
