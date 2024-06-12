import gleam/option.{type Option}
import position.{type Position}

pub type Player {
  White
  Black
  Both
}

pub type Orientation {
  WhiteOriented
  BlackOriented
}

pub type Piece {
  Pawn(en_passant: Option(Position))
  Knight
  Bishop
  Rook
  Queen
  King
}

pub type PlayerPiece {
  PlayerPiece(player: Player, piece: Piece, moved: Bool)
}

pub type Castling {
  KingSide
  QueenSide
}

pub type MoveData {
  MoveData(
    player: Player,
    player_piece: Option(PlayerPiece),
    move_type: Option(MoveType),
    from: Position,
    to: Position,
    captured_piece: Option(PlayerPiece),
    en_passant: Option(Position),
    promotion: Bool,
    castling: Option(Castling),
  )
}

pub type MoveType {
  Capture
  Goto
  PawnJump
  CastleKingSide
  CastleQueenSide
  EnPassant
  Promotion
}

pub type Destinations =
  List(Position)

pub type Origin =
  Position

pub type Destination =
  Position

pub type MovesInlined =
  List(#(Origin, Destination))

pub type Moves =
  List(#(Origin, Destinations))
