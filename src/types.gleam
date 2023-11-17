import gleam/option.{type Option}
import position.{type Position}

pub type Player {
  White
  Black
  Both
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
    player_piece: PlayerPiece,
    move_type: MoveType,
    from: Position,
    to: Position,
    captured_piece: Option(PlayerPiece),
    en_passant: Option(Position),
    promotion: Option(Piece),
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

pub type Destinations {
  Destinations(destinations: List(Position))
}

pub type Origin {
  Origin(origin: Position)
}

pub type Moves {
  Moves(moves: List(#(Origin, Destinations)))
}
