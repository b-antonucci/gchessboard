import gleam/option.{type Option}

pub type Player {
  White
  Black
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

pub type Rank {
  One
  Two
  Three
  Four
  Five
  Six
  Seven
  Eight
}

pub type File {
  A
  B
  C
  D
  E
  F
  G
  H
}

pub type Position {
  Position(file: File, rank: Rank)
}

pub type PlayerInfo {
  PlayerInfo(can_castle: Bool, in_check: Bool, king_position: Position)
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

pub type Move {
  Move(move_type: MoveType, position: Position)
}

pub type Square {
  Square(
    position: Position,
    player_piece: Option(PlayerPiece),
    move_to_play: Option(Move),
    highlighted: Bool,
  )
}
