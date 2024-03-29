import types.{type Moves, type Player}
import gleam/option.{type Option}

pub type Config {
  Config(moveable: Option(Moveable))
}

pub type Moveable {
  Moveable(
    player: Option(Player),
    fen: Option(String),
    moves: Option(Moves),
    after: Option(fn(types.MoveData) -> Nil),
  )
}
