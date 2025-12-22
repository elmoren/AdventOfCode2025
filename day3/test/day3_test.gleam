import day3
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn part1_score_item_test() {
  assert day3.score_part1("000") == Ok(0)
  assert day3.score_part1("001") == Ok(1)
  assert day3.score_part1("010") == Ok(10)
  assert day3.score_part1("5") == Ok(5)
  assert day3.score_part1("987654321111111") == Ok(98)
  assert day3.score_part1("811111111111119") == Ok(89)
  assert day3.score_part1("234234234234278") == Ok(78)
  assert day3.score_part1("818181911112111") == Ok(92)
}

pub fn part2_score_item_test() {
  assert day3.score_part2("987654321111111", 12) == Ok(987_654_321_111)
  assert day3.score_part2("811111111111119", 12) == Ok(811_111_111_119)
  assert day3.score_part2("234234234234278", 12) == Ok(434_234_234_278)
  assert day3.score_part2("818181911112111", 12) == Ok(888_911_112_111)
}
