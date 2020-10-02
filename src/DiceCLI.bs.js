// Generated by BUCKLESCRIPT, PLEASE EDIT WITH CARE
'use strict';

var Js_dict = require("bs-platform/lib/js/js_dict.js");
var Belt_Int = require("bs-platform/lib/js/belt_Int.js");
var Belt_List = require("bs-platform/lib/js/belt_List.js");
var Belt_Array = require("bs-platform/lib/js/belt_Array.js");
var Dices$JoaDicesRescript = require("./Dices.bs.js");

function toLowerCase(prim) {
  return prim.toLowerCase();
}

function toArray(string) {
  return Array.from(string, (function (s) {
                return s;
              }));
}

function parseCLI(command) {
  var attack = {
    contents: /* [] */0
  };
  var defense = {
    contents: /* [] */0
  };
  var isDefense = {
    contents: false
  };
  var intPart = {
    contents: ""
  };
  var add = function (dice) {
    var times = Belt_Int.fromString(intPart.contents);
    var times$1 = times !== undefined ? times : 1;
    intPart.contents = "";
    if (isDefense.contents) {
      defense.contents = Belt_List.concat(defense.contents, Dices$JoaDicesRescript.roll(times$1, dice));
    } else {
      attack.contents = Belt_List.concat(attack.contents, Dices$JoaDicesRescript.roll(times$1, dice));
    }
    
  };
  Belt_Array.forEach(Array.from(command, (function (s) {
              return s;
            })), (function (c) {
          var other = c.toLowerCase();
          switch (other) {
            case " " :
                return ;
            case "+" :
                isDefense.contents = false;
                return ;
            case "-" :
                isDefense.contents = true;
                return ;
            case "0" :
            case "1" :
            case "2" :
            case "3" :
            case "4" :
            case "5" :
            case "6" :
            case "7" :
            case "8" :
            case "9" :
                break;
            case "d" :
                return add(Dices$JoaDicesRescript.doomDice);
            case "g" :
                return add(Dices$JoaDicesRescript.giganticDice);
            case "n" :
                return add(Dices$JoaDicesRescript.blackDice);
            case "r" :
                return add(Dices$JoaDicesRescript.redDice);
            case "b" :
            case "w" :
                return add(Dices$JoaDicesRescript.whiteDice);
            case "j" :
            case "y" :
                return add(Dices$JoaDicesRescript.yellowDice);
            default:
              console.log(other, "is invalid, example: 3r w - 2yD");
              return ;
          }
          intPart.contents = intPart.contents + c;
          
        }));
  var pack = function (roll) {
    var result = Js_dict.fromArray([]);
    Belt_Array.forEach(roll, (function (face) {
            var $$int = Js_dict.get(result, face);
            result[face] = $$int !== undefined ? $$int + 1 | 0 : 1;
            
          }));
    return result;
  };
  console.log({
        attack: pack(Dices$JoaDicesRescript.toString(attack.contents)),
        defense: pack(Dices$JoaDicesRescript.toString(defense.contents)),
        result: pack(Dices$JoaDicesRescript.toString(Dices$JoaDicesRescript.fight(attack.contents, defense.contents)))
      });
  
}

parseCLI("3B+10G -J-8N");

var forEach = Belt_Array.forEach;

var concat = Belt_List.concat;

var toInt = Belt_Int.fromString;

var _FRENCH_SYNTAX = true;

exports.forEach = forEach;
exports.concat = concat;
exports.toInt = toInt;
exports.toLowerCase = toLowerCase;
exports.toArray = toArray;
exports._FRENCH_SYNTAX = _FRENCH_SYNTAX;
exports.parseCLI = parseCLI;
/*  Not a pure module */
