import lustre/event
import lustre/effect
import lustre/element/html.{div, style}
import lustre/attribute.{class, id, property}
import state.{type State, LeftClickMode, RightClickMode, State}
import position.{from_int, to_int}
import types.{Origin, White}
import config.{type Config, Config}
import gleam/list.{range}
import gleam/dict
import gleam/option.{None, Some}

pub fn init(_) {
  #(state.starting_position_board(), effect.none())
}

pub type Msg {
  RightClick(index: Int)
  LeftClick(index: Int)
  Set(config: Config)
}

pub fn update(model: state.State, msg) {
  let new_state = case msg {
    Set(config) -> {
      let new_model = case config.moveable {
        None -> {
          #(model, effect.none())
        }
        Some(config_moveable) -> {
          let new_player = case config_moveable.player {
            Some(types.White) -> Some(types.White)
            Some(types.Black) -> Some(types.Black)
            Some(types.Both) -> Some(types.Both)
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
            effect.none(),
          )
        }
      }
      new_model
    }
    RightClick(index) -> {
      case model.click_mode {
        RightClickMode(highlighted) -> {
          let new_highlight = from_int(index)
          let highlighted = [new_highlight, ..highlighted]
          #(
            State(..model, click_mode: RightClickMode(highlighted)),
            effect.none(),
          )
        }
        LeftClickMode(_, _) -> #(
          State(..model, click_mode: RightClickMode([from_int(index)])),
          effect.none(),
        )
      }
    }
    LeftClick(index) -> {
      case model.moveable.player {
        None -> {
          let new_selected = None
          let new_targeted = []
          #(
            State(
              ..model,
              click_mode: LeftClickMode(new_selected, new_targeted),
            ),
            effect.none(),
          )
        }
        Some(moveable_player) -> {
          case moveable_player == model.turn {
            False -> {
              let new_selected = None
              let new_targeted = []
              #(
                State(
                  ..model,
                  click_mode: LeftClickMode(new_selected, new_targeted),
                ),
                effect.none(),
              )
            }
            True ->
              case model.click_mode {
                LeftClickMode(selected, targeted) -> {
                  case selected {
                    Some(selected_pos) -> {
                      case #(selected_pos == from_int(index), targeted) {
                        #(True, _) -> {
                          let new_selected = None
                          let new_targeted = []
                          #(
                            State(
                              ..model,
                              click_mode: LeftClickMode(
                                new_selected,
                                new_targeted,
                              ),
                            ),
                            effect.none(),
                          )
                        }
                        #(False, []) -> {
                          let new_selected = Some(from_int(index))
                          let new_targeted = case model.moveable.moves {
                            None -> []
                            Some(moves) -> {
                              let maybe_moves =
                                list.find(moves.moves, fn(move) {
                                  move.0 == Origin(origin: from_int(index))
                                })
                              case maybe_moves {
                                Error(_) -> []
                                Ok(moves) -> {
                                  let dests = moves.1
                                  dests.destinations
                                }
                              }
                            }
                          }
                          #(
                            State(
                              ..model,
                              click_mode: LeftClickMode(
                                new_selected,
                                new_targeted,
                              ),
                            ),
                            effect.none(),
                          )
                        }
                        #(False, dests) -> {
                          case list.contains(dests, from_int(index)) {
                            False -> {
                              let new_selected = Some(from_int(index))
                              let new_targeted = case model.moveable.moves {
                                None -> []
                                Some(moves) -> {
                                  let maybe_moves =
                                    list.find(moves.moves, fn(move) {
                                      move.0 == Origin(origin: from_int(index))
                                    })
                                  case maybe_moves {
                                    Error(_) -> []
                                    Ok(moves) -> {
                                      let dests = moves.1
                                      dests.destinations
                                    }
                                  }
                                }
                              }
                              #(
                                State(
                                  ..model,
                                  click_mode: LeftClickMode(
                                    new_selected,
                                    new_targeted,
                                  ),
                                ),
                                effect.none(),
                              )
                            }
                            True -> {
                              let assert Ok(piece) =
                                dict.get(model.pieces, to_int(selected_pos))
                              let new_pieces =
                                dict.insert(model.pieces, index, piece)
                                |> dict.delete(to_int(selected_pos))
                              let new_selected = None
                              let new_targeted = []
                              let new_turn = case model.turn {
                                types.White -> types.Black
                                types.Black -> types.White
                                types.Both -> types.Both
                              }
                              #(
                                State(
                                  ..model,
                                  turn: new_turn,
                                  pieces: new_pieces,
                                  click_mode: LeftClickMode(
                                    new_selected,
                                    new_targeted,
                                  ),
                                ),
                                effect.from(fn(_) {
                                  case model.moveable.after {
                                    None -> Nil
                                    Some(after) ->
                                      after(types.MoveData(
                                        player: model.turn,
                                        player_piece: None,
                                        move_type: None,
                                        from: selected_pos,
                                        to: from_int(index),
                                        captured_piece: None,
                                        en_passant: None,
                                        promotion: None,
                                        castling: None,
                                      ))
                                  }
                                }),
                              )
                            }
                          }
                        }
                      }
                    }
                    None -> {
                      let #(new_selected, new_targeted) = case
                        model.moveable.player
                      {
                        None -> #(None, None)
                        Some(player) -> {
                          let maybe_clicked_piece =
                            dict.get(model.pieces, index)
                          case maybe_clicked_piece {
                            Error(_) -> #(None, None)
                            Ok(piece) ->
                              case piece.player == player {
                                False -> #(None, None)
                                True -> {
                                  let new_targeted = case model.moveable.moves {
                                    None -> None
                                    Some(moves) -> {
                                      let maybe_moves =
                                        list.find(moves.moves, fn(move) {
                                          move.0
                                          == Origin(origin: from_int(index))
                                        })
                                      case maybe_moves {
                                        Error(_) -> None
                                        Ok(moves) -> Some(moves)
                                      }
                                    }
                                  }
                                  #(Some(from_int(index)), new_targeted)
                                }
                              }
                          }
                        }
                      }
                      let new_targeted = case new_targeted {
                        None -> []
                        Some(moves) -> {
                          let dests = moves.1
                          dests.destinations
                        }
                      }
                      #(
                        State(
                          ..model,
                          click_mode: LeftClickMode(new_selected, new_targeted),
                        ),
                        effect.none(),
                      )
                    }
                  }
                }

                RightClickMode(_) -> {
                  let #(new_selected, new_targeted) = case
                    model.moveable.player
                  {
                    None -> #(None, None)
                    Some(player) -> {
                      let maybe_clicked_piece = dict.get(model.pieces, index)
                      case maybe_clicked_piece {
                        Error(_) -> #(None, None)
                        Ok(piece) ->
                          case piece.player == player {
                            False -> #(None, None)
                            True -> {
                              let new_targeted = case model.moveable.moves {
                                None -> None
                                Some(moves) -> {
                                  let maybe_moves =
                                    list.find(moves.moves, fn(move) {
                                      move.0 == Origin(origin: from_int(index))
                                    })
                                  case maybe_moves {
                                    Error(_) -> None
                                    Ok(moves) -> Some(moves)
                                  }
                                }
                              }
                              #(Some(from_int(index)), new_targeted)
                            }
                          }
                      }
                    }
                  }
                  let new_targeted = case new_targeted {
                    None -> []
                    Some(moves) -> {
                      let dests = moves.1
                      dests.destinations
                    }
                  }
                  #(
                    State(
                      ..model,
                      click_mode: LeftClickMode(new_selected, new_targeted),
                    ),
                    effect.none(),
                  )
                }
              }
          }
        }
      }
    }
  }

  new_state
}

const color_order = [
  "whiteSquare", "blackSquare", "whiteSquare", "blackSquare", "whiteSquare",
  "blackSquare", "whiteSquare", "blackSquare", "blackSquare", "whiteSquare",
  "blackSquare", "whiteSquare", "blackSquare", "whiteSquare", "blackSquare",
  "whiteSquare", "blackSquare", "whiteSquare", "blackSquare", "whiteSquare",
]

fn draw_board(model: state.State) {
  let list_of_int_index: List(Int) = range(0, 63)

  list.fold(list_of_int_index, [], fn(square_list, index) {
    let assert Ok(class_name) = list.at(color_order, index % 16)

    let square_color = case class_name {
      "whiteSquare" -> "#f0d9b5"
      "blackSquare" -> "#b58863"
    }
    let square_mark_flag = case model.click_mode {
      LeftClickMode(selected, targeted) -> {
        let selected = case selected {
          None -> False
          Some(selected) -> selected == from_int(index)
        }
        let targeted = list.contains(targeted, from_int(index))
        selected || targeted
      }
      RightClickMode(highlighted) -> {
        list.contains(highlighted, from_int(index))
      }
    }
    let maybe_clicked_piece = dict.get(model.pieces, index)
    let square_div =
      div(
        [
          class(class_name),
          case square_mark_flag {
            True ->
              attribute.style([#("border-color", "rgba(0, 128, 0, 0.655)")])
            False -> attribute.style([#("border-color", square_color)])
          },
          event.on("contextmenu", fn(_) { Ok(RightClick(index)) }),
          event.on("click", fn(_) { Ok(LeftClick(index)) }),
        ],
        {
          case maybe_clicked_piece {
            Error(_) -> []
            Ok(player_piece) -> {
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
  })
}

pub fn view(model: state.State) {
  div([id("chessboard"), property("oncontextmenu", "return false;")], [
    // TODO: replace with css file that we can import
    style(
      [],
      "
        #chessboard {
            width: 480px;
            height: 480px;
            float: left;
            line-height: 0;
            -webkit-user-drag: none;
            user-select: none;
            -moz-user-select: none;
            -webkit-user-select: none;
            -ms-user-select: none;
        }

        #chessboard>* {
            margin: 0;
            padding: 0;
        }

        h1 {
            text-align: center;
            font-family: sans-serif;
        }

        img {
            display: block;
            width: 100%;
            height: 100%;
            margin-left: auto;
            margin-right: auto;
            margin-top: auto;
            margin-bottom: auto;
            
        }

        .whiteSquare {
            display: inline-block;
            width: 60px;
            /* TODO: replace px with percentage */
            height: 60px;
            box-sizing: border-box;
            background-color: #f0d9b5;
            border-style: solid;
            border-width: 5px;
            border-color: #f0d9b5;
        }

        .blackSquare {
            display: inline-block;
            width: 60px;
            height: 60px;
            background-color: #b58863;
            box-sizing: border-box;
            border-style: solid;
            border-width: 5px;
            border-color: #b58863;
        }
    ",
    ),
    ..draw_board(model)
  ])
}
