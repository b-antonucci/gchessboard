pub type File {
  A
  B
  C
  D
  E
  F
  G
  H
}

pub fn to_string(f: File) -> String {
  case f {
    A -> "a"
    B -> "b"
    C -> "c"
    D -> "d"
    E -> "e"
    F -> "f"
    G -> "g"
    H -> "h"
  }
}

pub fn from_int(i: Int) -> File {
  case i {
    0 -> H
    1 -> G
    2 -> F
    3 -> E
    4 -> D
    5 -> C
    6 -> B
    7 -> A
    _ -> panic as "Invalid file"
  }
}

pub fn to_int(f: File) -> Int {
  // TODO: The correspondence between the file and the integer is the wrong
  // way around. Need to change this and fix whatever breaks.
  case f {
    H -> 0
    G -> 1
    F -> 2
    E -> 3
    D -> 4
    C -> 5
    B -> 6
    A -> 7
  }
}
