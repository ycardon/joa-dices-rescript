open Dices
let log = Js.log
let concat = Belt.List.concat

// one roll
log("\n> 1 red")
redDice |> roll(3) |> toString |> log

// concatenate rolls
log("\n> 3 red, 2 yellow")
concat(roll(3, redDice), roll(2, yellowDice)) |> toString |> log

// a full fight
let attack = roll(4, redDice)
log("\n> attack")
attack |> toString |> log

let defense = roll(5, yellowDice)
log("\n> defense")
defense |> toString |> log

log("\n> fight")
fight(attack, defense) |> toString |> log
