import lustre
import lustre/event
import lustre/element/html.{div}
import lustre/attribute.{class, id, property}
import board
import types
import gleam/list.{range}
import gleam/map
import gleam/option.{None, Some}

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "[data-lustre-app]", Nil)

  Nil
}

fn init(_) {
  board.starting_position_board()
}

type Msg {
  RightClick(index: Int)
  LeftClick(index: Int)
}

fn update(model: board.Board, msg) {
  case msg {
    RightClick(index) -> {
      let model =
        map.fold(
          model.squares,
          model,
          fn(model, square_index, square) {
            let new_squares =
              map.insert(
                model.squares,
                square_index,
                types.Square(..square, selected: False, targeted: False),
              )
            board.Board(squares: new_squares)
          },
        )
      let assert Ok(square) = map.get(model.squares, index)
      let new_square = case square.highlighted {
        True -> {
          types.Square(..square, highlighted: False)
        }
        False -> {
          types.Square(..square, highlighted: True)
        }
      }
      let new_squares = map.insert(model.squares, index, new_square)
      board.Board(squares: new_squares)
    }
    LeftClick(index) -> {
      let destinations = case map.get(model.squares, index) {
        Ok(square) -> {
          case square.moves_to_play {
            None -> []
            Some(moves) -> {
              moves.moves
            }
          }
        }
        Error(_) -> []
      }
      map.fold(
        model.squares,
        model,
        fn(model, square_index, square) {
          let selected = case #(index == square_index, square.player_piece) {
            #(True, Some(_)) -> True
            _ -> False
          }
          let targeted = case
            list.contains(destinations, types.position_from_int(square_index))
          {
            True -> True
            False -> False
          }
          let new_squares =
            map.insert(
              model.squares,
              square_index,
              types.Square(
                ..square,
                highlighted: False,
                selected: selected,
                targeted: targeted,
              ),
            )
          board.Board(squares: new_squares)
        },
      )
    }
  }
}

const color_order = [
  "whiteSquare", "blackSquare", "whiteSquare", "blackSquare", "whiteSquare",
  "blackSquare", "whiteSquare", "blackSquare", "blackSquare", "whiteSquare",
  "blackSquare", "whiteSquare", "blackSquare", "whiteSquare", "blackSquare",
  "whiteSquare", "blackSquare", "whiteSquare", "blackSquare", "whiteSquare",
]

fn draw_board(model: board.Board) {
  let list_of_int_index: List(Int) = range(0, 63)

  list.fold(
    list_of_int_index,
    [],
    fn(square_list, index) {
      let assert Ok(class_name) = list.at(color_order, index % 16)
      let assert Ok(square) = map.get(model.squares, index)

      let square_color = case class_name {
        "whiteSquare" -> "#f0d9b5"
        "blackSquare" -> "#b58863"
      }
      let square_div =
        div(
          [
            class(class_name),
            case square.highlighted {
              True ->
                attribute.style([#("border-color", "rgba(0, 128, 0, 0.655)")])
              False -> attribute.style([#("border-color", square_color)])
            },
            case square.selected {
              True ->
                attribute.style([#("border-color", "rgba(0, 128, 0, 0.655)")])
              False -> attribute.style([])
            },
            case square.targeted {
              True ->
                attribute.style([#("border-color", "rgba(0, 128, 0, 0.655)")])
              False -> attribute.style([])
            },
            event.on("contextmenu", fn(_) { Ok(RightClick(index)) }),
            event.on("click", fn(_) { Ok(LeftClick(index)) }),
          ],
          {
            case square.player_piece {
              None -> []
              Some(player_piece) -> {
                case #(player_piece.piece, player_piece.player) {
                  #(types.Pawn(_), types.White) -> [
                    html.img([
                      attribute.src("assets/Chess_plt45.svg"),
                      property("draggable", "false"),
                    ]),
                  ]
                  #(types.Pawn(_), types.Black) -> [
                    html.img([
                      attribute.src("assets/Chess_pdt45.svg"),
                      property("draggable", "false"),
                    ]),
                  ]
                  #(types.Knight, types.White) -> [
                    html.img([
                      attribute.src("assets/Chess_nlt45.svg"),
                      property("draggable", "false"),
                    ]),
                  ]
                  #(types.Knight, types.Black) -> [
                    html.img([
                      attribute.src("assets/Chess_ndt45.svg"),
                      property("draggable", "false"),
                    ]),
                  ]
                  #(types.Bishop, types.White) -> [
                    html.img([
                      attribute.src("assets/Chess_blt45.svg"),
                      property("draggable", "false"),
                    ]),
                  ]
                  #(types.Bishop, types.Black) -> [
                    html.img([
                      attribute.src("assets/Chess_bdt45.svg"),
                      property("draggable", "false"),
                    ]),
                  ]
                  #(types.Rook, types.White) -> [
                    html.img([
                      attribute.src("assets/Chess_rlt45.svg"),
                      property("draggable", "false"),
                    ]),
                  ]
                  #(types.Rook, types.Black) -> [
                    html.img([
                      attribute.src("assets/Chess_rdt45.svg"),
                      property("draggable", "false"),
                    ]),
                  ]
                  #(types.Queen, types.White) -> [
                    html.img([
                      attribute.src("assets/Chess_qlt45.svg"),
                      property("draggable", "false"),
                    ]),
                  ]
                  #(types.Queen, types.Black) -> [
                    html.img([
                      attribute.src("assets/Chess_qdt45.svg"),
                      property("draggable", "false"),
                    ]),
                  ]
                  #(types.King, types.White) -> [
                    html.img([
                      attribute.src("assets/Chess_klt45.svg"),
                      property("draggable", "false"),
                    ]),
                  ]
                  #(types.King, types.Black) -> [
                    html.img([
                      attribute.src("assets/Chess_kdt45.svg"),
                      property("draggable", "false"),
                    ]),
                  ]
                }
              }
            }
          },
        )

      [square_div, ..square_list]
    },
  )
}

fn view(model: board.Board) {
  div(
    [id("gameBoardBorder"), property("oncontextmenu", "return false;")],
    draw_board(model),
  )
}
