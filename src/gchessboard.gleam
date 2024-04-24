import config.{type Config, Config}
import gleam/dict
import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute.{class, property}
import lustre/effect
import lustre/element/html.{div, style}
import lustre/event
import position.{from_int, to_int}
import state.{type State, LeftClickMode, RightClickMode, State}
import types.{White}

pub fn init(_) {
  #(state.starting_position_board(), effect.none())
}

@external(javascript, "./ffi.js", "alert_js")
pub fn alert_js(message: String) -> Nil

pub type Msg {
  RightClick(index: Int)
  LeftClick(index: Int)
  NextTurn
  ToggleVisibility
  // TODO: I realize now that a 'builder pattern' would be better
  // suited to a typed langugage like gleam. Trying to use a 'config'
  // struct is a bit cumbersome.
  SetFen(fen: String)
  SetMoves(moves: types.Moves)
  SetMoveablePlayer(player: Option(types.Player))
  SetPromotions(promotions: types.MovesInlined)
  Set(config: Config)
}

pub fn update(model: state.State, msg) {
  let new_state = case msg {
    NextTurn -> {
      let new_turn = case model.turn {
        types.White -> types.Black
        types.Black -> types.White
        types.Both -> types.Both
      }
      #(state.State(..model, turn: new_turn), effect.none())
    }
    SetMoveablePlayer(player) -> {
      let new_model = case player {
        None -> {
          #(model, effect.none())
        }
        Some(player) -> {
          let new_moveable =
            state.Moveable(
              player: Some(player),
              promotions: model.moveable.promotions,
              moves: model.moveable.moves,
              after: model.moveable.after,
            )
          #(state.State(..model, moveable: new_moveable), effect.none())
        }
      }
      new_model
    }
    SetPromotions(promotions) -> {
      let new_moveable =
        state.Moveable(
          player: model.moveable.player,
          promotions: Some(promotions),
          moves: model.moveable.moves,
          after: model.moveable.after,
        )
      #(state.State(..model, moveable: new_moveable), effect.none())
    }
    SetMoves(moves) -> {
      #(
        state.State(
          ..model,
          moveable: state.Moveable(..model.moveable, moves: Some(moves)),
        ),
        effect.none(),
      )
    }
    SetFen(fen) -> {
      let new_model = state.update_board_with_fen(model, fen)
      #(new_model, effect.none())
    }
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
          let new_promotions = case config_moveable.promotions {
            Some(promotion) -> Some(promotion)
            None -> model.moveable.promotions
          }
          #(
            state.State(
              ..model,
              moveable: state.Moveable(
                player: new_player,
                promotions: new_promotions,
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
                      case selected_pos == from_int(index), targeted {
                        True, _ -> {
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
                        False, [] -> {
                          let new_selected = Some(from_int(index))
                          let new_targeted = case model.moveable.moves {
                            None -> []
                            Some(moves) -> {
                              let maybe_moves =
                                list.find(moves, fn(move) {
                                  move.0 == from_int(index)
                                })
                              case maybe_moves {
                                Error(_) -> []
                                Ok(moves) -> {
                                  let dests = moves.1
                                  dests
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
                        False, dests -> {
                          case list.contains(dests, from_int(index)) {
                            False -> {
                              let new_selected = Some(from_int(index))
                              let new_targeted = case model.moveable.moves {
                                None -> []
                                Some(moves) -> {
                                  let maybe_moves =
                                    list.find(moves, fn(move) {
                                      move.0 == from_int(index)
                                    })
                                  case maybe_moves {
                                    Error(_) -> []
                                    Ok(moves) -> {
                                      let dests = moves.1
                                      dests
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
                                    Some(after) -> {
                                      let promotion = case
                                        model.moveable.promotions
                                      {
                                        None -> False
                                        Some(promotions) ->
                                          case
                                            list.contains(promotions, #(
                                              selected_pos,
                                              from_int(index),
                                            ))
                                          {
                                            True -> True
                                            False -> False
                                          }
                                      }
                                      after(types.MoveData(
                                        player: model.turn,
                                        player_piece: None,
                                        move_type: None,
                                        from: selected_pos,
                                        to: from_int(index),
                                        captured_piece: None,
                                        en_passant: None,
                                        promotion: promotion,
                                        castling: None,
                                      ))
                                    }
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
                                        list.find(moves, fn(move) {
                                          move.0 == from_int(index)
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
                          dests
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
                                    list.find(moves, fn(move) {
                                      move.0 == from_int(index)
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
                      dests
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
    ToggleVisibility -> {
      let new_visibility = case model.visibility {
        True -> False
        False -> True
      }
      #(state.State(..model, visibility: new_visibility), effect.none())
    }
  }

  new_state
}

const color_order = [
  "blackSquare", "whiteSquare", "blackSquare", "whiteSquare", "blackSquare",
  "whiteSquare", "blackSquare", "whiteSquare", "whiteSquare", "blackSquare",
  "whiteSquare", "blackSquare", "whiteSquare", "blackSquare", "whiteSquare",
  "blackSquare",
]

fn draw_board(model: state.State) {
  let list_of_int_index: List(Int) = [
    7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 23, 22, 21, 20, 19, 18,
    17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 39, 38, 37, 36, 35, 34, 33, 32, 47,
    46, 45, 44, 43, 42, 41, 40, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60,
    59, 58, 57, 56,
  ]

  list.fold(list_of_int_index, [], fn(square_list, index) {
    let assert Ok(class_name) = list.at(color_order, index % 16)

    let square_color = case class_name {
      "whiteSquare" -> "#f0d9b5"
      "blackSquare" -> "#b58863"
      _ -> panic("Invalid class name")
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
              case player_piece.piece, player_piece.player {
                types.Pawn(_), types.White -> [
                  html.img([
                    attribute.src("assets/Chess_plt45.svg"),
                    property("draggable", "false"),
                  ]),
                ]
                types.Pawn(_), types.Black -> [
                  html.img([
                    attribute.src("assets/Chess_pdt45.svg"),
                    property("draggable", "false"),
                  ]),
                ]
                types.Knight, types.White -> [
                  html.img([
                    attribute.src("assets/Chess_nlt45.svg"),
                    property("draggable", "false"),
                  ]),
                ]
                types.Knight, types.Black -> [
                  html.img([
                    attribute.src("assets/Chess_ndt45.svg"),
                    property("draggable", "false"),
                  ]),
                ]
                types.Bishop, types.White -> [
                  html.img([
                    attribute.src("assets/Chess_blt45.svg"),
                    property("draggable", "false"),
                  ]),
                ]
                types.Bishop, types.Black -> [
                  html.img([
                    attribute.src("assets/Chess_bdt45.svg"),
                    property("draggable", "false"),
                  ]),
                ]
                types.Rook, types.White -> [
                  html.img([
                    attribute.src("assets/Chess_rlt45.svg"),
                    property("draggable", "false"),
                  ]),
                ]
                types.Rook, types.Black -> [
                  html.img([
                    attribute.src("assets/Chess_rdt45.svg"),
                    property("draggable", "false"),
                  ]),
                ]
                types.Queen, types.White -> [
                  html.img([
                    attribute.src("assets/Chess_qlt45.svg"),
                    property("draggable", "false"),
                  ]),
                ]
                types.Queen, types.Black -> [
                  html.img([
                    attribute.src("assets/Chess_qdt45.svg"),
                    property("draggable", "false"),
                  ]),
                ]
                types.King, types.White -> [
                  html.img([
                    attribute.src("assets/Chess_klt45.svg"),
                    property("draggable", "false"),
                  ]),
                ]
                types.King, types.Black -> [
                  html.img([
                    attribute.src("assets/Chess_kdt45.svg"),
                    property("draggable", "false"),
                  ]),
                ]
                _, _ -> []
              }
            }
          }
        },
      )

    [square_div, ..square_list]
  })
}

pub fn view(model: state.State) {
  div([attribute.attribute("id", "chessboard")], case model.visibility {
    True -> [
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
    ]
    False -> []
  })
}
