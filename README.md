Partial rewrite of the TypeScript project [JoA Dice](https://github.com/ycardon/joa-dices) in [ReScript](https://rescript-lang.org)

This is the 2nd edition of my language exploration project
- [Typescript](https://github.com/ycardon/joa-dices) (original)
- [Rescript](https://github.com/ycardon/joa-dices-rescript) (this one)
- [Haskell](https://github.com/ycardon/joa-dices-haskell)
- [Rust](https://github.com/ycardon/joa-dices-rust)

to be fair in term of language comparison, I have to note that the internal model used in this project is simpler than the previous one:
- from `roll: map<face, count>` in typescript
- to `roll: list<face>` in rescript

firsts impressions:
- automatic [prettier](https://prettier.io) in the vscode plugin is fine, but sometimes you'd prefer to format yourself to make the code more explicit (for instance keep function signature separated from the implementation)
- Belt module miss some important functions (for instance no `Belt.List.toArray`, you have to get it in another (undocumented) module `Array.of_list`)
- more generally, juggling with Belt and Js module is a pain
- documentation is improvable, I got most of the info I needed on the language itself (I'm a noob in FP) from an other source ([Exploring ReasonML](http://reasonmlhub.com/exploring-reasonml/toc.html))
- otherwise, the language is really promising :)

build with `npm run build`, build+watch with `npm run start`
