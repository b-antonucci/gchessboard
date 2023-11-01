import gleam/int
import lustre
import lustre/element.{text}
import lustre/element/html.{button, div, p}
import lustre/event.{on_click}
import lustre/attribute.{id}

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "[data-lustre-app]", Nil)

  Nil
}

fn init(_) {
  0
}

type Msg {
  Incr
  Decr
}

fn update(model, msg) {
  case msg {
    Incr -> model + 1
    Decr -> model - 1
  }
}

fn view(model) {
  // let count = int.to_string(model)

  div(
    [id("gameBoardBorder")],
    [
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
      div([attribute.class("blackSquare")], []),
      div([attribute.class("whiteSquare")], []),
    ],
  )
}
