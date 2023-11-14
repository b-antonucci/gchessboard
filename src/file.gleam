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

pub fn from_int(i: Int) -> File {
  case i {
    0 -> A
    1 -> B
    2 -> C
    3 -> D
    4 -> E
    5 -> F
    6 -> G
    7 -> H
  }
}

pub fn to_int(f: File) -> Int {
  case f {
    A -> 0
    B -> 1
    C -> 2
    D -> 3
    E -> 4
    F -> 5
    G -> 6
    H -> 7
  }
}
