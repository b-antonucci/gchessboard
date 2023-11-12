import gleam/option.{type Option}
import file.{type File}
import rank.{type Rank}

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

pub type Position {
  Position(file: File, rank: Rank)
}

pub fn position_from_int(index: Int) -> Position {
  let file = file.from_int(index % 8)
  let rank = rank.from_int(index / 8)
  Position(file, rank)
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

pub type Moves {
  Moves(moves: List(Position))
}

pub type Square {
  Square(
    position: Position,
    player_piece: Option(PlayerPiece),
    moves_to_play: Option(Moves),
    highlighted: Bool,
    selected: Bool,
    targeted: Bool,
  )
}
