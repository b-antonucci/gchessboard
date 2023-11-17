import types.{type Moves, type Player, Moves}
import position.{type Position, Position}
import gleam/map.{type Map}
import gleam/option.{type Option, None, Some}

pub type Moveable {
  Moveable(
    player: Option(Player),
    moves: Option(Moves),
    after: Option(fn(types.MoveData) -> Nil),
  )
}

pub type ClickMode {
  RightClickMode(highlighted: List(Position))
  LeftClickMode(selected: Option(Position), targeted: List(Position))
}

pub type State {
  State(
    turn: Player,
    pieces: Map(Int, types.PlayerPiece),
    click_mode: ClickMode,
    moveable: Moveable,
  )
}

pub fn starting_position_board() -> State {
  let list_of_pieces_rewrite = [
    #(
      0,
      types.PlayerPiece(moved: False, piece: types.Rook, player: types.White),
    ),
    #(
      1,
      types.PlayerPiece(moved: False, piece: types.Knight, player: types.White),
    ),
    #(
      2,
      types.PlayerPiece(moved: False, piece: types.Bishop, player: types.White),
    ),
    #(
      3,
      types.PlayerPiece(moved: False, piece: types.Queen, player: types.White),
    ),
    #(
      4,
      types.PlayerPiece(moved: False, piece: types.King, player: types.White),
    ),
    #(
      5,
      types.PlayerPiece(moved: False, piece: types.Bishop, player: types.White),
    ),
    #(
      6,
      types.PlayerPiece(moved: False, piece: types.Knight, player: types.White),
    ),
    #(
      7,
      types.PlayerPiece(moved: False, piece: types.Rook, player: types.White),
    ),
    #(
      8,
      types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.White,
      ),
    ),
    #(
      9,
      types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.White,
      ),
    ),
    #(
      10,
      types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.White,
      ),
    ),
    #(
      11,
      types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.White,
      ),
    ),
    #(
      12,
      types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.White,
      ),
    ),
    #(
      13,
      types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.White,
      ),
    ),
    #(
      14,
      types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.White,
      ),
    ),
    #(
      15,
      types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.White,
      ),
    ),
    #(
      48,
      types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.Black,
      ),
    ),
    #(
      49,
      types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.Black,
      ),
    ),
    #(
      50,
      types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.Black,
      ),
    ),
    #(
      51,
      types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.Black,
      ),
    ),
    #(
      52,
      types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.Black,
      ),
    ),
    #(
      53,
      types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.Black,
      ),
    ),
    #(
      54,
      types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.Black,
      ),
    ),
    #(
      55,
      types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.Black,
      ),
    ),
    #(
      56,
      types.PlayerPiece(moved: False, piece: types.Rook, player: types.Black),
    ),
    #(
      57,
      types.PlayerPiece(moved: False, piece: types.Knight, player: types.Black),
    ),
    #(
      58,
      types.PlayerPiece(moved: False, piece: types.Bishop, player: types.Black),
    ),
    #(
      59,
      types.PlayerPiece(moved: False, piece: types.Queen, player: types.Black),
    ),
    #(
      60,
      types.PlayerPiece(moved: False, piece: types.King, player: types.Black),
    ),
    #(
      61,
      types.PlayerPiece(moved: False, piece: types.Bishop, player: types.Black),
    ),
    #(
      62,
      types.PlayerPiece(moved: False, piece: types.Knight, player: types.Black),
    ),
    #(
      63,
      types.PlayerPiece(moved: False, piece: types.Rook, player: types.Black),
    ),
  ]
  let moveable = Moveable(player: Some(types.White), moves: None, after: None)

  State(
    types.White,
    map.from_list(list_of_pieces_rewrite),
    LeftClickMode(selected: None, targeted: []),
    moveable,
  )
}
