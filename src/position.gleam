import file.{type File}
import rank.{type Rank}

pub type Position {
  Position(file: File, rank: Rank)
}

pub fn to_string(position: Position) -> String {
  let file = file.to_string(position.file)
  let rank = rank.to_string(position.rank)
  file <> rank
}

pub fn from_string(raw_pos_string: String) -> Position {
  case raw_pos_string {
    "a1" -> Position(file.A, rank.One)
    "a2" -> Position(file.A, rank.Two)
    "a3" -> Position(file.A, rank.Three)
    "a4" -> Position(file.A, rank.Four)
    "a5" -> Position(file.A, rank.Five)
    "a6" -> Position(file.A, rank.Six)
    "a7" -> Position(file.A, rank.Seven)
    "a8" -> Position(file.A, rank.Eight)
    "b1" -> Position(file.B, rank.One)
    "b2" -> Position(file.B, rank.Two)
    "b3" -> Position(file.B, rank.Three)
    "b4" -> Position(file.B, rank.Four)
    "b5" -> Position(file.B, rank.Five)
    "b6" -> Position(file.B, rank.Six)
    "b7" -> Position(file.B, rank.Seven)
    "b8" -> Position(file.B, rank.Eight)
    "c1" -> Position(file.C, rank.One)
    "c2" -> Position(file.C, rank.Two)
    "c3" -> Position(file.C, rank.Three)
    "c4" -> Position(file.C, rank.Four)
    "c5" -> Position(file.C, rank.Five)
    "c6" -> Position(file.C, rank.Six)
    "c7" -> Position(file.C, rank.Seven)
    "c8" -> Position(file.C, rank.Eight)
    "d1" -> Position(file.D, rank.One)
    "d2" -> Position(file.D, rank.Two)
    "d3" -> Position(file.D, rank.Three)
    "d4" -> Position(file.D, rank.Four)
    "d5" -> Position(file.D, rank.Five)
    "d6" -> Position(file.D, rank.Six)
    "d7" -> Position(file.D, rank.Seven)
    "d8" -> Position(file.D, rank.Eight)
    "e1" -> Position(file.E, rank.One)
    "e2" -> Position(file.E, rank.Two)
    "e3" -> Position(file.E, rank.Three)
    "e4" -> Position(file.E, rank.Four)
    "e5" -> Position(file.E, rank.Five)
    "e6" -> Position(file.E, rank.Six)
    "e7" -> Position(file.E, rank.Seven)
    "e8" -> Position(file.E, rank.Eight)
    "f1" -> Position(file.F, rank.One)
    "f2" -> Position(file.F, rank.Two)
    "f3" -> Position(file.F, rank.Three)
    "f4" -> Position(file.F, rank.Four)
    "f5" -> Position(file.F, rank.Five)
    "f6" -> Position(file.F, rank.Six)
    "f7" -> Position(file.F, rank.Seven)
    "f8" -> Position(file.F, rank.Eight)
    "g1" -> Position(file.G, rank.One)
    "g2" -> Position(file.G, rank.Two)
    "g3" -> Position(file.G, rank.Three)
    "g4" -> Position(file.G, rank.Four)
    "g5" -> Position(file.G, rank.Five)
    "g6" -> Position(file.G, rank.Six)
    "g7" -> Position(file.G, rank.Seven)
    "g8" -> Position(file.G, rank.Eight)
    "h1" -> Position(file.H, rank.One)
    "h2" -> Position(file.H, rank.Two)
    "h3" -> Position(file.H, rank.Three)
    "h4" -> Position(file.H, rank.Four)
    "h5" -> Position(file.H, rank.Five)
    "h6" -> Position(file.H, rank.Six)
    "h7" -> Position(file.H, rank.Seven)
    "h8" -> Position(file.H, rank.Eight)
    _ -> panic("Invalid position string")
  }
}

// TODO: See todo in file.gleam
pub fn from_int(index: Int) -> Position {
  let file = file.from_int(7 - { index % 8 })
  let rank = rank.from_int(index / 8)
  Position(file, rank)
}

// TODO: See todo in file.gleam
pub fn to_int(position: Position) -> Int {
  let file = 7 - file.to_int(position.file)
  let rank = rank.to_int(position.rank)
  rank * 8 + file
}
