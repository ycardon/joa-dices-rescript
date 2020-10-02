open Belt.List
let toArray = Array.of_list

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
let count = (roll, face) => roll->reduce(0, (c, f) => f == face ? c + 1 : c)

// cancel roll faces by an amount of shield count
// ((roll, int), face) => (roll, int)
let cancel = ((roll, shieldCount), face) =>
  roll->reduceReverse((list{}, shieldCount), ((r, sc), f) =>
    sc <= 0 ? (r->add(f), 0) : f == face ? (r, sc - 1) : (r->add(f), sc)
  )

// give the result of a fight (apply defence shields on the attack and remove shields from the attack)
let fight = (attack, defense) => {
  let (fight, _) = (attack, defense->count(Shield))->cancel(Kill)->cancel(Disrupt)->cancel(Push)
  fight->keep(face => face != Shield)
}

// print a roll
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
  )->toArray
