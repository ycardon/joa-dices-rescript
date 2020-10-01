open Belt.List

// all possible faces
type face =
  | Kill
  | Disrupt
  | Push
  | Shield
  | Blank
  | Trample
  | Death
  | Rally
  | DelayedRally

// dices definitions
type dice = list<face>

let blackDice: dice = list{Kill, Disrupt, Disrupt, Shield, Shield, Shield}
let redDice: dice = list{Kill, Kill, Disrupt, Disrupt, Push, Shield}
let yellowDice: dice = list{Disrupt, Push, Push, Shield, Blank, Blank}
let whiteDice: dice = list{Disrupt, Disrupt, Push, Shield, Shield, Blank}
let giganticDice: dice = list{Kill, Disrupt, Disrupt, Push, Trample, Trample}
let doomDice: dice = list{Disrupt, Death, Death, Rally, Rally, DelayedRally}

// roll a dice once
let rollOnce = dice => dice->shuffle->head

// roll a dice several times
let rec roll = (times, dice) =>
  times <= 0
    ? list{}
    : switch rollOnce(dice) {
      | None => list{}
      | Some(face) => roll(times - 1, dice)->add(face)
      }

// count the number of a given face in a roll result
let count = (roll, face) => roll->reduce(0, (n, i) => i == face ? n + 1 : n)

// cancel roll faces by an amount of shield count
let cancel = ((roll, shieldCount), face) =>
  roll->reduceReverse((list{}, shieldCount), ((r, s), f) =>
    s <= 0 ? (r->add(f), 0) : f == face ? (r, s - 1) : (r->add(f), s)
  )

// give the result of a fight (apply defence shields on the attack and remove shields from the attack)
let fight = (attack, defense) => {
  let (fight, _) = (attack, defense->count(Shield))->cancel(Kill)->cancel(Disrupt)->cancel(Push)
  fight->keep(face => face != Shield)
}

// print a roll (list<faces>)
let toString = roll => roll->map(face =>
    switch face {
    | Kill => "Kill"
    | Disrupt => "Disrupt"
    | Push => "Push"
    | Shield => "Shield"
    | Blank => "Blank"
    | Trample => "Trample"
    | Death => "Death"
    | Rally => "Rally"
    | DelayedRally => "Delayed Rally"
    }
  )->Array.of_list
