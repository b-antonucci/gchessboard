import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import position.{type Position, Position}
import types.{type Moves, type MovesInlined, type Orientation, type Player}

pub type Moveable {
  Moveable(
    player: Option(Player),
    moves: Option(Moves),
    promotions: Option(MovesInlined),
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
    orientation: Orientation,
    visibility: Bool,
  )
}

// TODO: i need to write a seperate module for handling fen client side
// logic like this would go in that module
pub fn expand_fen_placement_row(row: String) -> String {
  let expanded_row =
    list.fold(string.split(row, ""), "", fn(acc, placement_data) {
      case placement_data {
        "1" -> string.append(acc, "1")
        "2" -> {
          string.append(acc, "11")
        }
        "3" -> {
          string.append(acc, "111")
        }
        "4" -> {
          string.append(acc, "1111")
        }
        "5" -> {
          string.append(acc, "11111")
        }
        "6" -> {
          string.append(acc, "111111")
        }
        "7" -> {
          string.append(acc, "1111111")
        }
        "8" -> {
          string.append(acc, "11111111")
        }
        "p" | "r" | "n" | "b" | "q" | "k" | "P" | "R" | "N" | "B" | "Q" | "K" -> {
          string.append(acc, placement_data)
        }

        _ -> panic as "Invalid placement data"
      }
    })

  expanded_row
}

// TODO: i need to write a seperate module for handling fen client side
// logic like this would go in that module
pub fn update_board_with_fen(state: State, fen: String) -> State {
  let assert Ok(piece_positions) = list.first(string.split(fen, " "))
  // convert a fen position to a list of tuples
  let list_of_pieces =
    piece_positions
    |> string.split("/")
    |> list.index_map(fn(row, y) {
      row
      |> expand_fen_placement_row
      |> string.split("")
      |> list.index_fold([], fn(acc, piece, x) {
        case piece {
          "1" -> acc
          _ -> {
            let position = { 56 - { y * 8 } } + x
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
              _ -> panic as "Invalid piece"
            }
            let piece_type = case piece {
              "r" | "R" -> types.Rook
              "n" | "N" -> types.Knight
              "b" | "B" -> types.Bishop
              "q" | "Q" -> types.Queen
              "k" | "K" -> types.King
              "p" | "P" -> types.Pawn(None)
              _ -> panic as "Invalid piece"
            }
            list.prepend(acc, #(
              position,
              types.PlayerPiece(moved: False, piece: piece_type, player: player),
            ))
          }
        }
      })
    })

  let list_of_pieces = list.flatten(list_of_pieces)

  State(
    state.turn,
    dict.from_list(list_of_pieces),
    state.click_mode,
    state.moveable,
    state.orientation,
    state.visibility,
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
  let moveable =
    Moveable(
      player: Some(types.White),
      promotions: None,
      moves: None,
      after: None,
    )

  State(
    types.White,
    dict.from_list(list_of_pieces_rewrite),
    LeftClickMode(selected: None, targeted: []),
    moveable,
    types.WhiteOriented,
    visibility: False,
  )
}
