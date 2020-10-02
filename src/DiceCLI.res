open Dices
open Belt
open Js.String

let _FRENCH_SYNTAX = true

type fight = {attack: array<string>, defense: array<string>, result: array<string>}

let parseCLI = command => {
  let attack = ref(list{})
  let defense = ref(list{})
  let isDefense = ref(false)
  let partialInt = ref("")

  let toArray = string => string->castToArrayLike->Js.Array.fromMap(s => s)

  let addDice = dice => {
    let times = switch Int.fromString(partialInt.contents) {
    | Some(times) => times
    | None => 1
    }
    partialInt := ""
    isDefense.contents
      ? defense := defense.contents->List.concat(roll(times, dice))
      : attack := attack.contents->List.concat(roll(times, dice))
  }

  // parse the command
  command->toArray->Array.forEach(c => {
    switch c->toUpperCase {
    | "N" => addDice(blackDice)
    | "R" => addDice(redDice)
    | "J" | "Y" => addDice(yellowDice)
    | "B" => addDice(_FRENCH_SYNTAX ? whiteDice : blackDice)
    | "W" => addDice(whiteDice)
    | "G" => addDice(giganticDice)
    | "D" => addDice(doomDice)
    | "-" => isDefense := true
    | "+" => isDefense := false
    | " " => ()
    | "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" =>
      partialInt := partialInt.contents ++ c
    | other => Js.log2(other, "is invalid, example: 3R W - 2Y")
    }
  })

  // compute and print the result of the fight
  {
    attack: attack.contents->toString,
    defense: defense.contents->toString,
    result: fight(attack.contents, defense.contents)->toString,
  }->Js.log
}

parseCLI("+1WG -BG")
