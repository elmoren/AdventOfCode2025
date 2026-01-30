import gleam/int
import gleam/io
import gleam/list.{Continue, Stop}
import gleam/result
import gleam/string
import simplifile

pub type Machine {
  Machine(lights: Int, buttons: List(Int), joltages: List(Int))
}

pub fn new_machine(manual: String) -> Result(Machine, Nil) {
  let diagrams = string.split(manual, " ")
  let lights =
    diagrams
    |> list.first
    |> result.map(fn(r) {
      r
      |> string.reverse
      |> string.to_graphemes
      |> list.fold(0, fn(acc, c) {
        case c {
          "#" -> acc |> int.bitwise_shift_left(1) |> int.bitwise_or(1)
          "." -> acc |> int.bitwise_shift_left(1)
          _ -> acc
        }
      })
    })

  let #(btn, jtg) =
    diagrams
    |> list.drop(1)
    |> fn(l) { list.split(l, list.length(l) - 1) }

  let buttons =
    list.map(btn, fn(b) {
      b
      |> string.drop_start(1)
      |> string.drop_end(1)
      |> string.split(",")
      |> list.map(int.parse)
      |> result.all
      |> result.map(fn(b) {
        b
        |> list.fold(0, fn(acc, v) {
          int.bitwise_or(acc, int.bitwise_shift_left(1, v))
        })
      })
    })
    |> result.all

  let joltages =
    jtg
    |> list.first
    |> result.unwrap("")
    |> string.drop_start(1)
    |> string.drop_end(1)
    |> string.split(",")
    |> list.map(int.parse)
    |> result.all

  case lights, buttons, joltages {
    Ok(lights), Ok(buttons), Ok(joltages) ->
      Ok(Machine(lights:, buttons:, joltages:))
    _, _, _ -> Error(Nil)
  }
}

pub fn solve(machine: Machine) -> Int {
  let btn_len = list.length(machine.buttons)
  list.range(1, btn_len)
  |> list.fold_until(btn_len, fn(_acc, v) {
    let match =
      list.combinations(machine.buttons, v)
      |> list.fold_until(False, fn(_a, btns) {
        let r =
          list.fold(btns, 0, fn(acc, btn) { int.bitwise_exclusive_or(acc, btn) })
        case r == machine.lights {
          True -> Stop(True)
          False -> Continue(False)
        }
      })

    case match {
      True -> Stop(v)
      False -> Continue(v)
    }
  })
}

pub fn main() -> Nil {
  case simplifile.read("input.txt") {
    Ok(input) -> {
      let assert Ok(machines) =
        input |> string.split("\n") |> list.map(new_machine) |> result.all

      let part_1 =
        machines
        |> list.map(solve)
        |> int.sum

      io.println("Part 1: " <> int.to_string(part_1))
      io.println("Part 2: ")
    }
    Error(e) -> panic as simplifile.describe_error(e)
  }
}
