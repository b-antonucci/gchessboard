import file.{type File}
import rank.{type Rank}

pub type Position {
  Position(file: File, rank: Rank)
}

pub fn from_int(index: Int) -> Position {
  let file = file.from_int(index % 8)
  let rank = rank.from_int(index / 8)
  Position(file, rank)
}

pub fn to_int(position: Position) -> Int {
  let file = file.to_int(position.file)
  let rank = rank.to_int(position.rank)
  rank * 8 + file
}
