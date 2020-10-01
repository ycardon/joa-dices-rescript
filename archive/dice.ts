// Yann CARDON 2019
// Times of Legend, Joan of Arc dice rolls

/** base class for dices */
export abstract class Dice {

    /** the dice roll result */
    readonly result: Map<Face, number> = new Map

    /** the different faces of the dice */
    abstract faces: Face[]

    /** roll the dice once (or n times), if called multiple times then the results stack */
    roll(times = 1): Dice {
        for (let i=0; i<times; i++) {
            let roll = this.faces[Math.floor(Math.random() * this.faces.length)]
            if (roll) // if the dice has faces
                this.result.set(roll, (this.result.get(roll) || 0) + 1)
                console.debug(this.constructor.name, 'rolled a', this.result)
            }
        return this
    }

    /** reset the dice results */
    reset(): Dice {
        this.result.clear()
        return this
    }

    /** add an other dice result (does not change the faces of the dice) */
    add(other: Dice): Dice {
        Faces.map(f => {
            let sum = (this.result.get(f) || 0) + (other.result.get(f) || 0)
            if (sum != 0) this.result.set(f, sum)
        })
        console.debug(this.constructor.name, 'sum is', this.result)
        return this
    }

    /** convert the dice to an object, useful for logging */
    toObject() {
        let dice = {type: this.constructor.name, result: {} as any}
        Array.from(this.result, ([face, number]) => {
            dice.result[face] = number
        })
        return dice
    }

    /** remove faces (blank, shields... for instance) from the dice result */
    filter(face: Face): Dice {
        this.result.delete(face)
        return this
    }

    /** apply a defense roll on a attack roll (shields faces are canceling the hit faces) */
    applyDefense(defence: Dice): Dice {
        this.lower(Face.Push, 
            this.lower(Face.Disrupt, 
                this.lower(Face.Kill, 
                    defence.result.get(Face.Shield) || 0)))
        return this
    }

    /** lower the result @face value by the number of @shields then @return the remaining shields */
    private lower(face: Face, shields: number): number {
        let n = this.result.get(face)
        if (n)
            if (n-shields > 0) {
                this.result.set(face, n-shields)
                return 0
            }
            else {
                this.result.delete(face)
                return shields-n
            }
        return shields
    }
}

/** the different dice faces */
export enum Face {
    Kill =          'kill',             // Tué
    Disrupt =       'disrupt',          // Hors combat
    Push =          'push',             // Recul
    Shield =        'shield',           // Bouclier
    Blank =         'blank',            // Vide
    Trample =       'trample',          // Piétinement
    Death =         'death',            // Mort
    Rally =         'rally',            // Ralliement
    DelayedRally =  'delayed rally',    // Ralliement différé
}

/** an array of all the dice faces */
const Faces = Object.keys(Face).map(k => Face[k as any] as Face)

/** common attack vs defence rolls */
export function attack(attackDice: Map<Dice, number>, defenceDice: Map<Dice, number> = new Map): object {
    let attack = new EmptyDice
    let defence = new EmptyDice

    Array.from(attackDice, ([dice, times]) => attack.add(dice.roll(times)))
    Array.from(defenceDice, ([dice, times]) => defence.add(dice.roll(times)))

    if (defence.result.size == 0)
        return {
            attack: attack.toObject().result
        }
    else
        return {
            attack: attack.toObject().result,
            defence: defence.toObject().result,
            final: new EmptyDice()
                .add(attack)
                .applyDefense(defence)
                .filter(Face.Blank).filter(Face.Shield)
                .toObject().result
        }
}

/** an dice without faces, used for dice calculations */
export class EmptyDice extends Dice {
    faces = []
}

/** a black combat dice */
export class BlackDice extends Dice {
    faces = [
        Face.Kill,
        Face.Disrupt,
        Face.Shield,
        Face.Disrupt,
        Face.Shield,
        Face.Shield,
    ]
}

/** a red combat dice */
export class RedDice extends Dice {
    faces = [
        Face.Kill,
        Face.Disrupt,
        Face.Push,
        Face.Disrupt,
        Face.Kill,
        Face.Shield,
    ]
}

/** a yellow combat dice */
export class YellowDice extends Dice {
    faces = [
        Face.Blank,
        Face.Disrupt,
        Face.Push,
        Face.Blank,
        Face.Push,
        Face.Shield,
    ]
}

/** a white combat dice */
export class WhiteDice extends Dice {
    faces = [
        Face.Shield,
        Face.Blank,
        Face.Disrupt,
        Face.Push,
        Face.Disrupt,
        Face.Shield,
    ]
}

/** a purple gigantic combat dice */
export class GiganticDice extends Dice {
    faces = [
        Face.Kill,
        Face.Disrupt,
        Face.Disrupt,
        Face.Trample,
        Face.Trample,
        Face.Push,
    ]
}

/** a doom dice */
export class DoomDice extends Dice {
    faces = [
        Face.Disrupt,
        Face.Rally,
        Face.DelayedRally,
        Face.Rally,
        Face.Death,
        Face.Death,
    ]
}
