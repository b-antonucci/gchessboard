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

pub fn position_to_int(position: Position) -> Int {
  let file = file.to_int(position.file)
  let rank = rank.to_int(position.rank)
  rank * 8 + file
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

pub type Moves {
  Moves(moves: List(Position))
}

pub type Square {
  Square(
    position: Position,
    player_piece: Option(PlayerPiece),
    moves_to_play: Option(Moves),
    // TODO: i should combine these into enum
    //       since they are mutually exclusive
    highlighted: Bool,
    selected: Bool,
    targeted: Bool,
  )
}
