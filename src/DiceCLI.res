open Dices
let forEach = Belt.Array.forEach
let concat = Belt.List.concat
let toInt = Belt.Int.fromString
let toLowerCase = Js.String.toLowerCase
let toArray = string => string->Js.String.castToArrayLike->Js.Array.fromMap(s => s)

let _FRENCH_SYNTAX = true

type fight = {attack: array<string>, defense: array<string>, result: array<string>}

let parseCLI = command => {
  let attack = ref(list{})
  let defense = ref(list{})
  let isDefense = ref(false)
  let intPart = ref("")

  let add = dice => {
    let times = switch intPart.contents->toInt {
    | Some(times) => times
    | None => 1
    }
    intPart := ""
    isDefense.contents
      ? defense := defense.contents->concat(roll(times, dice))
      : attack := attack.contents->concat(roll(times, dice))
  }

  // parse the command
  command->toArray->forEach(c => {
    switch c->toLowerCase {
    | "n" => add(blackDice) // noir
    | "w" => add(whiteDice)
    | "b" => add(_FRENCH_SYNTAX ? whiteDice : blackDice) // blanc
    | "r" => add(redDice)
    | "j" | "y" => add(yellowDice) // jaune
    | "g" => add(giganticDice)
    | "d" => add(doomDice)
    | "-" => isDefense := true
    | "+" => isDefense := false
    | " " => ()
    | "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" => intPart := intPart.contents ++ c
    | other => Js.log2(other, "is invalid, example: 3r w - 2yD")
    }
  })

  // compute and print the result of the fight
  {
    attack: attack.contents->toString,
    defense: defense.contents->toString,
    result: fight(attack.contents, defense.contents)->toString,
  }->Js.log
}

parseCLI("3B+10G -J-8N")
