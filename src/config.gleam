import gleam/option.{type Option}
import types.{type Moves, type MovesInlined, type Orientation, type Player}

pub type Config {
  Config(moveable: Option(Moveable), orientation: Option(Orientation))
}

pub type Moveable {
  Moveable(
    player: Option(Player),
    promotions: Option(MovesInlined),
    fen: Option(String),
    moves: Option(Moves),
    after: Option(fn(types.MoveData) -> Nil),
  )
}
