import day8
import gleam/float
import gleam/list
import gleam/result
import gleam/string
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

const input = "162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689"

pub fn parse_test() {
  let r = day8.parse(input |> string.split("\n"))
  assert list.first(r) == Ok(day8.Point(162, 817, 812))
}

pub fn distance_test() {
  let d =
    result.unwrap(
      day8.distance(day8.Point(x: 0, y: 0, z: 0), day8.Point(x: 5, y: 5, z: 5)),
      0.0,
    )
  assert float.to_precision(d, 3) == 8.66
}

pub fn part1_test() {
  let r = day8.parse(input |> string.split("\n"))

  assert day8.part1(r, 10) == 40
}

pub fn part2_test() {
  let r = day8.parse(input |> string.split("\n"))

  assert day8.part2(r) == 25_272
}
