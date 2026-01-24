import gleam/int
import gleam/io
import gleam/list
import gleam/regexp.{type Options, type Regexp, check}
import gleam/result
import gleam/string
import simplifile

fn parse(input: String) -> List(#(Int, Int)) {
  input
  |> string.split(",")
  |> list.map(fn(v) {
    case string.split(v, "-") {
      [a, b] -> #(a, b)
      _ -> panic as "Invalid input"
    }
  })
  |> list.map(fn(v) {
    case int.parse(v.0), int.parse(v.1) {
      Ok(a), Ok(b) -> #(a, b)
      _, _ -> panic as "Invalid parse"
    }
  })
}

fn score(ranges: List(#(Int, Int)), re: Regexp) -> Int {
  ranges
  |> list.map(fn(v) { list.range(v.0, v.1) })
  |> list.flatten()
  |> list.filter(fn(v) { check(re, int.to_string(v)) })
  |> int.sum
}

pub fn main() -> Nil {
  let options = regexp.Options(case_insensitive: False, multi_line: True)
  let re1 = case regexp.compile("^([0-9]+)\\1$", options) {
    Ok(r) -> r
    Error(e) -> panic as "Invalid regex"
  }

  let re2 = case regexp.compile("^([0-9]+)\\1+$", options) {
    Ok(r) -> r
    Error(e) -> panic as "Invalid regex"
  }

  case simplifile.read("input.txt") {
    Ok(lines) -> {
      let input = parse(lines)
      let part_1 = score(input, re1)
      let part_2 = score(input, re2)

      io.println("Part 1: " <> int.to_string(part_1))
      io.println("Part 2: " <> int.to_string(part_2))
    }
    Error(e) -> panic as simplifile.describe_error(e)
  }
}
