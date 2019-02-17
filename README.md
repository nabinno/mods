# Mods --- Hot plugin
Package manager with Git Submodules in Red.

## Installation
```sh
> hot cmd/install https://raw.githubusercontent.com/nabinno/mods/master/mods.red
```

## Configuration
```red
> cat hots.red
Red []

hots: context [
    mods: [
        do-mods #(init: %mods.red git: https://github.com/nabinno/mods)
        red-elixir #(init: %init.red git: https://github.com/nabinno/red-elixir)
        json #(init: %json.red git: https://github.com/rebolek/red-tools)
        http-tools #(init: %http-tools.red git: https://github.com/rebolek/red-tools)
        regex #(init: %regex.red git: https://github.com/toomasv/regex)
    ]
]

> hot mods/get
```

## Getting Started
```red:init.red
Red []

do %mods/github.com/nabinno/mods/mods.red
do-mods [red-elixir]
```

## Functions
- `mods/get` - Add submodules in Git and set modules into Red.
- `mods/clean` - Remove all submodules.
- `do-mods` - Explicitly do modules.

---

## Contributing
1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## EPILOGUE
>     A whale!
>     Down it goes, and more, and more
>     Up goes its tail!
>
>     -Buson Yosa
