import lustre
import lustre/event
import lustre/element/html.{div}
import lustre/attribute.{class, id, property}
import board.{empty_board}

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "[data-lustre-app]", Nil)

  Nil
}

fn init(_) {
  #(empty_board(), False)
}

type Msg {
  RightClick
}

fn update(model, msg) {
  case msg {
    RightClick -> {
      case model {
        #(board, True) -> #(board, False)
        #(board, False) -> #(board, True)
      }
    }
  }
}

fn view(model) {
  div(
    [id("gameBoardBorder"), property("oncontextmenu", "return false;")],
    [
      div(
        [
          class("whiteSquare"),
          case model {
            #(_, True) -> attribute.style([#("background-color", "red")])
            #(_, False) -> attribute.style([#("background-color", "white")])
          },
          event.on("contextmenu", fn(_) { Ok(RightClick) }),
        ],
        [],
      ),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
      div([class("blackSquare")], []),
      div([class("whiteSquare")], []),
    ],
  )
}
