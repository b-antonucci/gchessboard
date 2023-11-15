import lustre
import lustre/event
import lustre/element/html.{div}
import lustre/attribute.{class, id, property}
import state
import types
import square
import position.{from_int, to_int}
import gleam/list.{range}
import gleam/map
import gleam/option.{None, Some}

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "[data-lustre-app]", Nil)

  Nil
}

fn init(_) {
  state.starting_position_board()
}

type Msg {
  RightClick(index: Int)
  LeftClick(index: Int)
}

fn update(model: state.State, msg) {
  case msg {
    RightClick(index) -> {
      let model =
        map.fold(
          model.squares,
          model,
          fn(model, square_index, square) {
            let new_squares = case square.status {
              None | Some(square.Highlighted) -> model.squares
              Some(square.Selected) | Some(square.Targeted) -> {
                map.insert(
                  model.squares,
                  square_index,
                  square.Square(..square, status: None),
                )
              }
            }
            state.State(..model, squares: new_squares)
          },
        )
      let assert Ok(square) = map.get(model.squares, index)
      let new_square = case square.status {
        Some(square.Highlighted) -> {
          square.Square(..square, status: None)
        }
        _ -> {
          square.Square(..square, status: Some(square.Highlighted))
        }
      }
      let new_squares = map.insert(model.squares, index, new_square)
      state.State(..model, squares: new_squares)
    }
    LeftClick(index) -> {
      let assert Ok(left_clicked_square) = map.get(model.squares, index)
      case left_clicked_square.status {
        Some(square.Selected) -> {
          map.fold(
            model.squares,
            model,
            fn(model, square_index, square) {
              let new_squares =
                map.insert(
                  model.squares,
                  square_index,
                  square.Square(..square, status: None),
                )
              state.State(..model, squares: new_squares)
            },
          )
        }
        Some(square.Targeted) -> {
          map.fold(
            model.squares,
            model,
            fn(model, square_index, square) {
              let new_squares = case square_index == index {
                True -> {
                  let assert Some(origin_square) = model.selected_square

                  let player_piece = origin_square.player_piece
                  map.insert(
                    model.squares,
                    square_index,
                    square.Square(
                      ..square,
                      moves_to_play: None,
                      status: None,
                      player_piece: player_piece,
                    ),
                  )
                }
                False -> {
                  let assert Some(origin_square) = model.selected_square
                  let player_piece = case
                    square_index == to_int(origin_square.position)
                  {
                    True -> None
                    False -> square.player_piece
                  }
                  map.insert(
                    model.squares,
                    square_index,
                    square.Square(
                      ..square,
                      moves_to_play: None,
                      player_piece: player_piece,
                      status: None,
                    ),
                  )
                }
              }
              state.State(..model, squares: new_squares)
            },
          )
        }
        _ -> {
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
              let selected = case
                #(index == square_index, square.player_piece)
              {
                #(True, Some(player_piece)) if player_piece.player == model.moveable.player ->
                  True
                _ -> False
              }
              let targeted = list.contains(destinations, from_int(square_index))

              let status = case #(selected, targeted) {
                #(True, _) -> Some(square.Selected)
                #(False, True) -> Some(square.Targeted)
                #(False, False) -> None
                #(True, True) -> panic("This should never happen")
              }
              let new_squares =
                map.insert(
                  model.squares,
                  square_index,
                  square.Square(..square, status: status),
                )
              case selected {
                True -> {
                  state.State(
                    ..model,
                    squares: new_squares,
                    selected_square: Some(square),
                  )
                }
                False -> {
                  state.State(..model, squares: new_squares)
                }
              }
            },
          )
        }
      }
    }
  }
}

const color_order = [
  "whiteSquare", "blackSquare", "whiteSquare", "blackSquare", "whiteSquare",
  "blackSquare", "whiteSquare", "blackSquare", "blackSquare", "whiteSquare",
  "blackSquare", "whiteSquare", "blackSquare", "whiteSquare", "blackSquare",
  "whiteSquare", "blackSquare", "whiteSquare", "blackSquare", "whiteSquare",
]

fn draw_board(model: state.State) {
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
            case square.status {
              Some(_) ->
                attribute.style([#("border-color", "rgba(0, 128, 0, 0.655)")])
              None -> attribute.style([#("border-color", square_color)])
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

fn view(model: state.State) {
  div(
    [id("gameBoardBorder"), property("oncontextmenu", "return false;")],
    draw_board(model),
  )
}
