import types.{type Player}
import gleam/option.{type Option}

pub type Config {
  Config(Option(Moveable), Option(Nil))
}

pub type Moveable {
  Moveable(player: Option(Player), after: Option(fn(types.MoveData) -> Nil))
}
