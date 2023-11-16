import types.{type Destinations, type PlayerPiece}
import position.{type Position}
import gleam/option.{type Option}

pub type Status {
  Highlighted
  Selected
  Targeted
}

pub type Square {
  Square(
    position: Position,
    player_piece: Option(PlayerPiece),
    moves_to_play: Option(Destinations),
    status: Option(Status),
  )
}
