import types.{
  type File, type Rank, type Square, A, B, C, D, E, Eight, F, Five, Four, G, H,
  One, Seven, Six, Three, Two,
}
import gleam/map.{type Map}
import gleam/option.{None}
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
