import types.{type Square}
import gleam/map.{type Map}

pub type Board {
  Board(squares: Map(Int, Square))
}

pub fn empty_board() -> Board {
  let squares = map.new()
  Board(squares)
}
