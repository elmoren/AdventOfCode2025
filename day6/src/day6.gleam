import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/regexp
import gleam/result
import gleam/string
import simplifile

pub type Puzzle {
  Puzzle(
    operators: dict.Dict(Int, String),
    operands: dict.Dict(#(Int, Int), Int),
    rows: Int,
    cols: Int,
  )
}

pub fn parse_input(lines: List(String)) -> Puzzle {
  let parts = list.partition(lines, string.contains(_, "+"))

  let options = regexp.Options(case_insensitive: True, multi_line: False)
  let assert Ok(re) = regexp.compile("\\s+", with: options)

  let operators =
    parts.0
    |> list.first()
    |> result.unwrap("")
    |> string.trim()
    |> regexp.split(re, _)
    |> list.index_map(fn(v, idx) { #(idx, v) })
    |> dict.from_list()

  let operands =
    parts.1
    |> list.index_fold(dict.new(), fn(acc, line, i) {
      list.index_fold(regexp.split(re, string.trim(line)), acc, fn(acc, c, j) {
        dict.insert(acc, #(i, j), result.unwrap(int.parse(c), 0))
      })
    })

  let size =
    dict.keys(operands)
    |> list.fold(#(0, 0), fn(acc, a) {
      #(int.max(acc.0, a.0), int.max(acc.1, a.1))
    })

  Puzzle(operators:, operands:, rows: size.0 + 1, cols: size.1 + 1)
}

// I realized too late that its just a transpose and gleam has list.transpose built in
pub fn part1(puzzle: Puzzle) -> Int {
  let sets =
    list.map(list.range(0, puzzle.cols - 1), fn(c) {
      use r <- list.map(list.range(0, puzzle.rows - 1))
      case dict.get(puzzle.operands, #(r, c)) {
        Ok(v) -> v
        Error(_e) -> panic as "Index out of bounds"
      }
    })

  sets
  |> list.index_fold(0, fn(acc, operands, i) {
    let result = case dict.get(puzzle.operators, i) {
      Ok(v) if v == "*" -> operands |> int.product
      Ok(v) if v == "+" -> operands |> int.sum
      _ -> panic as "Invalid operator"
    }

    acc + result
  })
}

pub fn part2(lines: List(String)) -> Int {
  let parts = list.partition(lines, string.contains(_, "+"))

  let options = regexp.Options(case_insensitive: True, multi_line: False)
  let assert Ok(re) = regexp.compile("\\s+", with: options)

  let operators =
    parts.0
    |> list.first()
    |> result.unwrap("")
    |> string.trim()
    |> regexp.split(re, _)

  let operands =
    list.map(parts.1, string.to_graphemes)
    |> list.transpose()
    |> list.map(string.join(_, ""))
    |> list.map(string.trim)
    |> list.chunk(string.is_empty)
    |> list.filter(fn(l) { !list.contains(l, "") })
    |> list.map(fn(r) { list.map(r, fn(e) { result.unwrap(int.parse(e), 0) }) })

  operands
  |> list.zip(operators)
  |> list.fold(0, fn(acc, expressions) {
    let result = case expressions.1 {
      op if op == "*" -> int.product(expressions.0)
      op if op == "+" -> int.sum(expressions.0)
      _ -> panic as "Invalid operator"
    }
    result + acc
  })
}

pub fn main() -> Nil {
  case simplifile.read("input.txt") {
    Ok(input) -> {
      let lines = string.split(input, "\n")
      let puzzle = parse_input(lines)
      let part_1 = part1(puzzle)
      let part_2 = part2(lines)

      io.println("Part 1: " <> int.to_string(part_1))
      io.println("Part 2: " <> int.to_string(part_2))
    }
    Error(_e) -> panic as "Cannot read file"
  }
}
