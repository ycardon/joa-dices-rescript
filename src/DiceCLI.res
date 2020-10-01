open Dices
open Belt
open Js.String2

type fight = {attack: array<string>, defense: array<string>, result: array<string>}

let frenchSyntax = true

let parseCLI = command => {
  let attack = ref(list{})
  let defense = ref(list{})
  let isDefense = ref(false)

  let addDice = (times, dice) =>
    if isDefense.contents {
      defense := defense.contents->List.concat(roll(times, dice))
    } else {
      attack := attack.contents->List.concat(roll(times, dice))
    }

  // parse the command
  command->Array.forEach(arg => {
    let times = switch Int.fromString(arg->slice(~from=0, ~to_=-1)) {
    | Some(int) => int
    | None => 1
    }
    switch arg->sliceToEnd(~from=-1)->toUpperCase {
    | "N" => addDice(times, blackDice)
    | "R" => addDice(times, redDice)
    | "J" | "Y" => addDice(times, yellowDice)
    | "B" => addDice(times, frenchSyntax ? whiteDice : blackDice)
    | "W" => addDice(times, whiteDice)
    | "G" => addDice(times, giganticDice)
    | "D" => addDice(times, doomDice)
    | "-" | "/" | ":" => isDefense := true
    | error => Js.log2(error, "is invalid, example: 3R W - 2Y")
    }
  })

  // compute and print the result of the fight
  {
    attack: attack.contents->toString,
    defense: defense.contents->toString,
    result: fight(attack.contents, defense.contents)->toString,
  }->Js.log
}

parseCLI(["3W", "3R", "-", "B"])
