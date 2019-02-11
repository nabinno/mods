# Redmodule --- Package manager with Git Submodules
## Installation and configuration
```red:init.red
Red []

REDMODULE-PATH: to-red-file rejoin [get-env either system/platform == 'Windows ["USERPROFILE"]["HOME"] %/.red/redmodule.red]
unless exists? REDMODULE-PATH [write REDMODULE-PATH read https://raw.githubusercontent.com/nabinno/redmodule/master/redmodule.red]
do REDMODULE-PATH

;-- Example modules
modules: [
    red-elixir #(name: "Red Elixir" init: %init.red git: https://github.com/nabinno/red-elixir)
    json #(name: "JSON" init: %json.red git: https://github.com/rebolek/red-tools)
    http-tools #(name: "HTTP Tools" init: %http-tools.red git: https://github.com/rebolek/red-tools)
    regex #(name: "Regex" init: %regex.red git: https://github.com/toomasv/regex)
]
redmodule/get modules system/options/path
do-redmodule [red-elixir]
```

## Functions
- `redmodule/get` - Add submodules in Git and set modules into Red.
- `redmodule/clean` - Remove all submodules.
- `redmodule/require (do-redmodule)` - Explicitly do modules.

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
