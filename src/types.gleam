import gleam/option.{type Option}
import gleam/map.{type Map}

type Player {
  White
  Black
}

type Piece {
  Pawn(en_passant: Option(Position))
  Knight
  Bishop
  Rook
  Queen
  King
}

type PlayerPiece {
  PlayerPiece(player: Player, piece: Piece, moved: Bool)
}

type Rank {
  One
  Two
  Three
  Four
  Five
  Six
  Seven
  Eight
}

type File {
  A
  B
  C
  D
  E
  F
  G
  H
}

type Position {
  Position(file: File, rank: Rank)
}

type PlayerInfo {
  PlayerInfo(can_castle: Bool, in_check: Bool, king_position: Position)
}

type MoveType {
  Capture
  Goto
  PawnJump
  CastleKingSide
  CastleQueenSide
  EnPassant
  Promotion
}

type Move {
  Move(move_type: MoveType, position: Position)
}

type Square {
  Square(
    position: Position,
    player_piece: PlayerPiece,
    move_to_play: Option(Move),
  )
}

type Board {
  Board(squares: Map(Int, Square))
}
