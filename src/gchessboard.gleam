import lustre
import lustre/event
import lustre/element/html.{div}
import lustre/attribute.{class, id, property}
import board.{new_board}
import types
import gleam/list.{range}
import gleam/map

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "[data-lustre-app]", Nil)

  Nil
}

fn init(_) {
  new_board()
}

type Msg {
  RightClick(index: Int)
}

fn update(model: board.Board, msg) {
  case msg {
    RightClick(index) -> {
      let assert Ok(square) = map.get(model.squares, index)
      let new_square = case square.right_click_detected {
        True -> {
          types.Square(..square, right_click_detected: False)
        }
        False -> {
          types.Square(..square, right_click_detected: True)
        }
      }
      let new_squares = map.insert(model.squares, index, new_square)
      board.Board(squares: new_squares)
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
  let list_of_int_index: List(Int) = range(63, 0)

  list.fold(
    list_of_int_index,
    [],
    fn(square_list, index) {
      let assert Ok(class_name) = list.at(color_order, index % 16)
      let assert Ok(square) = map.get(model.squares, index)
      let background_color = case class_name {
        "whiteSquare" -> "white"
        "blackSquare" -> "black"
      }
      let square_div =
        div(
          [
            class(class_name),
            case square.right_click_detected {
              True -> attribute.style([#("background-color", "red")])
              False ->
                attribute.style([#("background-color", background_color)])
            },
            event.on("contextmenu", fn(_) { Ok(RightClick(index)) }),
          ],
          [],
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
