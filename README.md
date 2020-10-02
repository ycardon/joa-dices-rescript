Partial rewrite of the TypeScript project [JoA Dice](https://github.com/ycardon/joa-dices) in [ReScript](https://rescript-lang.org)

to be fair in term of language comparison, I have to note that the internal model used in this project is simpler than the previous one:
- from `roll: map<face, count>` in typescript
- to `roll: list<face>` in rescript

build with `npm run build`, build+watch with `npm run start`

