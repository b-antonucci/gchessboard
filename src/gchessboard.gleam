import lustre
import lustre/event
import lustre/effect
import lustre/element/html.{div}
import lustre/attribute.{class, id, property}
import state
import position.{Position, from_int, to_int}
import rank.{Four, One, Three, Two}
import file.{A, B, C, D, E, F, G, H}
import types
import square
import config.{type Config, Config}
import gleam/list.{range}
import gleam/map
import gleam/option.{None, Some}

@external(javascript, "./ffi.js", "alert")
pub fn alert() -> Nil

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(interface) = lustre.start(app, "[data-lustre-app]", Nil)

  let config =
    Config(moveable: Some(config.Moveable(
      player: None,
      after: None,
      moves: Some(types.Moves(moves: [
        #(
          types.Origin(origin: Position(file: B, rank: One)),
          types.Destinations(destinations: [
            Position(file: A, rank: Three),
            Position(file: C, rank: Three),
          ]),
        ),
        #(
          types.Origin(origin: Position(file: G, rank: One)),
          types.Destinations(destinations: [
            Position(file: F, rank: Three),
            Position(file: H, rank: Three),
          ]),
        ),
        #(
          types.Origin(origin: Position(file: A, rank: Two)),
          types.Destinations(destinations: [
            Position(file: A, rank: Three),
            Position(file: A, rank: Four),
          ]),
        ),
        #(
          types.Origin(origin: Position(file: B, rank: Two)),
          types.Destinations(destinations: [
            Position(file: B, rank: Three),
            Position(file: B, rank: Four),
          ]),
        ),
        #(
          types.Origin(origin: Position(file: C, rank: Two)),
          types.Destinations(destinations: [
            Position(file: C, rank: Three),
            Position(file: C, rank: Four),
          ]),
        ),
        #(
          types.Origin(origin: Position(file: D, rank: Two)),
          types.Destinations(destinations: [
            Position(file: D, rank: Three),
            Position(file: D, rank: Four),
          ]),
        ),
        #(
          types.Origin(origin: Position(file: E, rank: Two)),
          types.Destinations(destinations: [
            Position(file: E, rank: Three),
            Position(file: E, rank: Four),
          ]),
        ),
        #(
          types.Origin(origin: Position(file: F, rank: Two)),
          types.Destinations(destinations: [
            Position(file: F, rank: Three),
            Position(file: F, rank: Four),
          ]),
        ),
        #(
          types.Origin(origin: Position(file: G, rank: Two)),
          types.Destinations(destinations: [
            Position(file: G, rank: Three),
            Position(file: G, rank: Four),
          ]),
        ),
        #(
          types.Origin(origin: Position(file: H, rank: Two)),
          types.Destinations(destinations: [
            Position(file: H, rank: Three),
            Position(file: H, rank: Four),
          ]),
        ),
      ])),
    )))

  interface(Set(config))

  Nil
}

fn init(_) {
  #(state.starting_position_board(), effect.none())
}

type Msg {
  RightClick(index: Int)
  LeftClick(index: Int)
  Set(config: Config)
}

fn update(model: state.State, msg) {
  let new_state = case msg {
    Set(config) -> {
      let #(new_model, new_moves) = case config.moveable {
        None -> {
          #(model, None)
        }
        Some(config_moveable) -> {
          let new_player = case config_moveable.player {
            Some(types.White) -> types.White
            Some(types.Black) -> types.Black
            None -> model.moveable.player
          }
          let new_after = case config_moveable.after {
            Some(after) -> Some(after)
            None -> model.moveable.after
          }
          let new_moves = case config_moveable.moves {
            Some(moves) -> Some(moves)
            None -> model.moveable.moves
          }
          #(
            state.State(
              ..model,
              moveable: state.Moveable(
                player: new_player,
                moves: new_moves,
                after: new_after,
              ),
            ),
            new_moves,
          )
        }
      }
      let new_model = case new_moves {
        None -> new_model
        Some(moves) -> {
          let map_of_moves = map.from_list(moves.moves)
          let new_model =
            map.fold(
              model.squares,
              model,
              fn(model, square_index, square) {
                let new_moves_to_play = case
                  map.get(
                    map_of_moves,
                    types.Origin(origin: position.from_int(square_index)),
                  )
                {
                  Ok(moves) -> Some(moves)
                  Error(_) -> None
                }
                let new_square =
                  square.Square(..square, moves_to_play: new_moves_to_play)
                let new_squares =
                  map.insert(model.squares, square_index, new_square)
                state.State(..model, squares: new_squares)
              },
            )
          new_model
        }
      }
      new_model
    }
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
                  moves.destinations
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
  #(new_state, effect.none())
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
    [id("chessboard"), property("oncontextmenu", "return false;")],
    draw_board(model),
  )
}
