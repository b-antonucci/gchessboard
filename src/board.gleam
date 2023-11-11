import types.{
  type File, type Rank, type Square, A, B, C, D, E, Eight, F, Five, Four, G, H,
  One, Seven, Six, Three, Two,
}
import gleam/map.{type Map}
import gleam/option.{None, Some}
import gleam/list.{range}

const list_of_files: List(File) = [A, B, C, D, E, F, G, H]

const list_of_ranks: List(Rank) = [
  One,
  Two,
  Three,
  Four,
  Five,
  Six,
  Seven,
  Eight,
]

pub type Board {
  Board(squares: Map(Int, Square))
}

pub fn new_board() -> Board {
  let list_of_int_index: List(Int) = range(0, 63)

  let squares =
    list.fold(
      list_of_int_index,
      map.new(),
      fn(map, index) {
        map
        |> map.insert(
          index,
          types.Square(
            position: types.Position(
              file: {
                let assert Ok(file) = list.at(list_of_files, index % 8)
                file
              },
              rank: {
                let assert Ok(rank) = list.at(list_of_ranks, index / 8)
                rank
              },
            ),
            player_piece: None,
            move_to_play: None,
            highlighted: False,
          ),
        )
      },
    )

  Board(squares)
}

pub fn starting_position_board() -> Board {
  let list_of_pieces: List(#(Int, option.Option(types.PlayerPiece))) = [
    #(
      0,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Rook,
        player: types.White,
      )),
    ),
    #(
      1,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Knight,
        player: types.White,
      )),
    ),
    #(
      2,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Bishop,
        player: types.White,
      )),
    ),
    #(
      3,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Queen,
        player: types.White,
      )),
    ),
    #(
      4,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.King,
        player: types.White,
      )),
    ),
    #(
      5,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Bishop,
        player: types.White,
      )),
    ),
    #(
      6,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Knight,
        player: types.White,
      )),
    ),
    #(
      7,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Rook,
        player: types.White,
      )),
    ),
    #(
      8,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.White,
      )),
    ),
    #(
      9,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.White,
      )),
    ),
    #(
      10,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.White,
      )),
    ),
    #(
      11,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.White,
      )),
    ),
    #(
      12,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.White,
      )),
    ),
    #(
      13,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.White,
      )),
    ),
    #(
      14,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.White,
      )),
    ),
    #(
      15,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.White,
      )),
    ),
    #(16, None),
    #(17, None),
    #(18, None),
    #(19, None),
    #(20, None),
    #(21, None),
    #(22, None),
    #(23, None),
    #(24, None),
    #(25, None),
    #(26, None),
    #(27, None),
    #(28, None),
    #(29, None),
    #(30, None),
    #(31, None),
    #(32, None),
    #(33, None),
    #(34, None),
    #(35, None),
    #(36, None),
    #(37, None),
    #(38, None),
    #(39, None),
    #(40, None),
    #(41, None),
    #(42, None),
    #(43, None),
    #(44, None),
    #(45, None),
    #(46, None),
    #(47, None),
    #(
      48,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.Black,
      )),
    ),
    #(
      49,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.Black,
      )),
    ),
    #(
      50,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.Black,
      )),
    ),
    #(
      51,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.Black,
      )),
    ),
    #(
      52,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.Black,
      )),
    ),
    #(
      53,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.Black,
      )),
    ),
    #(
      54,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.Black,
      )),
    ),
    #(
      55,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Pawn(None),
        player: types.Black,
      )),
    ),
    #(
      56,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Rook,
        player: types.Black,
      )),
    ),
    #(
      57,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Knight,
        player: types.Black,
      )),
    ),
    #(
      58,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Bishop,
        player: types.Black,
      )),
    ),
    #(
      59,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Queen,
        player: types.Black,
      )),
    ),
    #(
      60,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.King,
        player: types.Black,
      )),
    ),
    #(
      61,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Bishop,
        player: types.Black,
      )),
    ),
    #(
      62,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Knight,
        player: types.Black,
      )),
    ),
    #(
      63,
      Some(types.PlayerPiece(
        moved: False,
        piece: types.Rook,
        player: types.Black,
      )),
    ),
  ]

  let squares =
    list.fold(
      list_of_pieces,
      map.new(),
      fn(map, index_and_piece) {
        map
        |> map.insert(
          index_and_piece.0,
          types.Square(
            position: types.Position(
              file: {
                let assert Ok(file) =
                  list.at(list_of_files, index_and_piece.0 % 8)
                file
              },
              rank: {
                let assert Ok(rank) =
                  list.at(list_of_ranks, index_and_piece.0 / 8)
                rank
              },
            ),
            player_piece: index_and_piece.1,
            move_to_play: None,
            highlighted: False,
          ),
        )
      },
    )

  Board(squares)
}
