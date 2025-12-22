import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn score_part1(input: String) -> Result(Int, Nil) {
  score_part1_loop(input, #(0, 0))
}

fn score_part1_loop(input, acc: #(Int, Int)) -> Result(Int, Nil) {
  case string.length(input) {
    0 -> int.parse(int.to_string(acc.0) <> int.to_string(acc.1))
    1 -> {
      let digit = parse_first_digit(input)

      let r = case digit {
        d if d > acc.1 -> #(acc.0, d)
        _ -> acc
      }

      score_part1_loop(string.drop_start(input, 1), r)
    }
    _ -> {
      let digit = parse_first_digit(input)

      let r = case digit {
        d if d > acc.0 -> #(d, 0)
        d if d > acc.1 -> #(acc.0, d)
        _ -> acc
      }

      score_part1_loop(string.drop_start(input, 1), r)
    }
  }
}

fn parse_first_digit(input: String) -> Int {
  let digit =
    string.first(input)
    |> result.try(int.parse)
    |> result.unwrap(0)
  digit
}

pub fn score_part2(num_str: String, max_len: Int) -> Result(Int, Nil) {
  let len = string.length(num_str)
  let res = list.repeat(0, max_len)

  list.index_fold(res, #("", 0), fn(acc, _v, idx) {
    let end = len - max_len + idx + 1
    let next = find_next_largest(num_str, acc.1, end)

    #(acc.0 <> next.0, next.1 + 1)
  })
  |> fn(v) { v.0 }
  |> int.parse
}

fn find_next_largest(num_str, start, end) -> #(String, Int) {
  string.to_graphemes(num_str)
  |> list.index_fold(#("0", start), fn(acc, char, idx) {
    case idx >= start && idx < end {
      True -> {
        let best = result.unwrap(int.parse(acc.0), 0)
        let current = result.unwrap(int.parse(char), 0)

        case current {
          v if v > best -> #(char, idx)
          _ -> acc
        }
      }
      False -> acc
    }
  })
}

pub fn main() -> Nil {
  case simplifile.read(from: "input.txt") {
    Ok(contents) -> {
      let lines = string.split(contents, "\n")

      let part1 =
        list.map(lines, score_part1)
        |> list.fold(0, fn(sum, v) { sum + result.unwrap(v, 0) })

      let part1_1 =
        list.map(lines, score_part2(_, 2))
        |> list.fold(0, fn(sum, v) { sum + result.unwrap(v, 0) })

      let part2 =
        list.map(lines, score_part2(_, 12))
        |> list.fold(0, fn(sum, v) { sum + result.unwrap(v, 0) })

      io.println("Part 1   - " <> int.to_string(part1))
      io.println("Part 1.1 - " <> int.to_string(part1_1))
      io.println("Part 2   - " <> int.to_string(part2))
    }
    Error(_e) -> io.println("Error reading file")
  }
}
