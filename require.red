Red []

MODULE-NAMES: system/script/args
MODULE-DIRECTORY: %mods/
MODS-PATH: %github.com/nabinno/mods/mods.red

do/args rejoin [MODULE-DIRECTORY MODS-PATH] system/options/path
__get-modules: :mods/__get-modules
__series: :mods/__series
__keyword: :mods/__keyword
__error: :mods/__error

require: func [module-names [word! block! none!]][
    modules: __get-modules
    module-names: either module-names [append [] module-names][__keyword/keys modules]
    __series/each module-names mn [__do-require modules mn]
]

__do-require: func [modules [series!] name][
    package: __keyword/get modules name ; @type #(name [string!] init [path!] git [path!] require [series!])
    unless package [__error/raise rejoin ["Package " name " does not exist."]]

    path-series: split package/git "/" domain: third path-series name: fourth path-series repo: fifth path-series
    init-file: to-red-file rejoin [MODULE-DIRECTORY domain "/" name "/" repo "/" package/init]
    unless exists? init-file [__error/raise rejoin ["Initial file " init-file " does not exist."]]

    if package/require [foreach rp package/require [do-call rp]]

    do init-file
]

;
; Main
;
require MODULE-NAMES
