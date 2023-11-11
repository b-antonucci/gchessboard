pub type Rank {
  One
  Two
  Three
  Four
  Five
  Six
  Seven
  Eight
}

pub fn from_int(i: Int) -> Rank {
  case i {
    0 -> One
    1 -> Two
    2 -> Three
    3 -> Four
    4 -> Five
    5 -> Six
    6 -> Seven
    7 -> Eight
  }
}
