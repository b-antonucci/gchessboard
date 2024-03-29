import types.{type Moves, type Player, Moves}
import position.{type Position, Position}
import gleam/string
import gleam/list
import gleam/dict.{type Dict}
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
    pieces: Dict(Int, types.PlayerPiece),
    click_mode: ClickMode,
    moveable: Moveable,
  )
}

pub fn update_board_with_fen(fen: String) -> State {
  let piece_positions = case string.split(fen, " ") {
    [positions, _, _, _, _, _] -> positions
    _ -> panic("Invalid FEN string")
  }
  // convert a fen position to a list of tuples
  let list_of_pieces =
    piece_positions
    |> string.split("/")
    |> list.index_map(fn(row, y) {
      row
      |> string.split("")
      |> list.index_map(fn(piece, x) {
        let position = { 55 - { y * 8 } } + x
        let player = case piece {
          "r" -> types.Black
          "n" -> types.Black
          "b" -> types.Black
          "q" -> types.Black
          "k" -> types.Black
          "p" -> types.Black
          "R" -> types.White
          "N" -> types.White
          "B" -> types.White
          "Q" -> types.White
          "K" -> types.White
          "P" -> types.White
          _ -> panic("Invalid piece")
        }
        let piece_type = case piece {
          "r" | "R" -> types.Rook
          "n" | "N" -> types.Knight
          "b" | "B" -> types.Bishop
          "q" | "Q" -> types.Queen
          "k" | "K" -> types.King
          "p" | "P" -> types.Pawn(None)
          _ -> panic("Invalid piece")
        }
        #(
          position,
          types.PlayerPiece(moved: False, piece: piece_type, player: player),
        )
      })
    })

  let list_of_pieces = list.flatten(list_of_pieces)
  let moveable = Moveable(player: Some(types.White), moves: None, after: None)

  State(
    types.White,
    dict.from_list(list_of_pieces),
    LeftClickMode(selected: None, targeted: []),
    moveable,
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
    dict.from_list(list_of_pieces_rewrite),
    LeftClickMode(selected: None, targeted: []),
    moveable,
  )
}
