import day9.{Point}
import gleam/list
import gleam/string
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

const input = "7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3"

const cc_polygon = [
  Point(7, 1),
  Point(11, 1),
  Point(11, 7),
  Point(9, 7),
  Point(9, 5),
  Point(2, 5),
  Point(2, 3),
  Point(7, 3),
]

const cc_polygon_1 = [
  Point(0, 0),
  Point(10, 0),
  Point(10, 4),
  Point(2, 4),
  Point(2, 6),
  Point(12, 6),
  Point(12, 8),
  Point(13, 8),
  Point(13, 9),
  Point(12, 9),
  Point(12, 12),
  Point(0, 12),
]

const cc_polygon_2 = [
  Point(3, 2),
  Point(17, 2),
  Point(17, 13),
  Point(13, 13),
  Point(13, 11),
  Point(15, 11),
  Point(15, 8),
  Point(11, 8),
  Point(11, 15),
  Point(18, 15),
  Point(18, 17),
  Point(4, 17),
  Point(4, 12),
  Point(6, 12),
  Point(6, 5),
  Point(3, 5),
]

const cc_polygon_3 = [
  Point(3, 2),
  Point(13, 2),
  Point(13, 4),
  Point(8, 4),
  Point(8, 6),
  Point(11, 6),
  Point(11, 11),
  Point(7, 11),
  Point(7, 8),
  Point(5, 8),
  Point(5, 10),
  Point(3, 10),
]

pub fn part_1_test() {
  let r =
    input
    |> string.split("\n")
    |> list.map(day9.parse)
    |> day9.part_1

  assert r == 50
}

pub fn simple_is_rect_inside_test() {
  let polygon = [Point(0, 0), Point(10, 0), Point(10, 10), Point(0, 10)]
  let lines = day9.to_lines(polygon)

  assert day9.is_rect_inside(#(Point(0, 0), Point(10, 10)), lines) == True
  assert day9.is_rect_inside(#(Point(0, 0), Point(10, 10)), lines) == True
  assert day9.is_rect_inside(#(Point(10, 10), Point(1, 1)), lines) == True
  assert day9.is_rect_inside(#(Point(5, 5), Point(10, 10)), lines) == True
  assert day9.is_rect_inside(#(Point(2, 3), Point(8, 6)), lines) == True

  assert day9.is_rect_inside(#(Point(11, 11), Point(12, 12)), lines) == False
  assert day9.is_rect_inside(#(Point(12, 12), Point(11, 11)), lines) == False
  assert day9.is_rect_inside(#(Point(8, 10), Point(11, 11)), lines) == False
}

pub fn concave_is_rect_inside_test() {
  let lines = day9.to_lines(cc_polygon_1)
  assert day9.is_rect_inside(#(Point(0, 0), Point(10, 10)), lines) == False
  assert day9.is_rect_inside(#(Point(2, 4), Point(2, 6)), lines) == True
  assert day9.is_rect_inside(#(Point(2, 4), Point(12, 6)), lines) == False
  assert day9.is_rect_inside(#(Point(0, 0), Point(10, 0)), lines) == True
  assert day9.is_rect_inside(#(Point(0, 0), Point(10, 4)), lines) == True
  assert day9.is_rect_inside(#(Point(0, 12), Point(12, 6)), lines) == True
  assert day9.is_rect_inside(#(Point(0, 12), Point(13, 9)), lines) == False
}

pub fn part_2_test() {
  assert day9.part_2(cc_polygon) == 24
  assert day9.part_2(cc_polygon_1) == 91
  assert day9.part_2(cc_polygon_2) == 66
  assert day9.part_2(cc_polygon_3) == 35
}

pub fn area_test() {
  assert day9.area(Point(0, 0), Point(11, 0)) == 12
  assert day9.area(Point(0, 11), Point(0, 0)) == 12
  assert day9.area(Point(0, 0), Point(11, 11)) == 144
}
