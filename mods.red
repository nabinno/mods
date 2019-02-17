Red []

CURRENT-PATH: system/script/args

mods: context [
    MODULE-DIRECTORY: rejoin [CURRENT-PATH %mods/]
    unless exists? MODULE-DIRECTORY [make-dir MODULE-DIRECTORY]

    get: does [
        modules: __get-modules
        package-maps: __keyword/values modules
        __series/each package-maps pm [mods/__do-git-submodule pm/git]
        call "git submodule foreach git pull origin master"
    ]

    clean: does [call rejoin ["rm -fr " MODULE-DIRECTORY]]

    __do-git-submodule: func [git-path [url!]][
        path-series: split git-path "/" domain: third path-series name: fourth path-series repo: fifth path-series
        local-path: to-string rejoin [MODULE-DIRECTORY domain "/" name "/" repo]

        call rejoin ["git submodule add --force" " --name " local-path " -- " git-path space local-path]
        call/wait rejoin ["git submodule absorbgitdirs " local-path]
    ]

    __require: func [module-names [word! block! none!]][
        modules: __get-modules
        module-names: either module-names [append [] module-names][__keyword/keys modules]
        __series/each module-names mn [mods/__do-require modules mn]
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

    ; @return series!.<key [word!] #(name [string!] init [path!] git [url!] require [series!])>
    __get-modules: does [
        do rejoin [CURRENT-PATH %hots.red]
        either empty? hots/mods [
            __error/raise rejoin ["Does not setup hots/mods."]
        ][
            hots/mods
        ]
    ]

    __series: context [
        each: func [series 'word body][
            forall series [
                set word series/1
                do bind body word
            ]
            none
        ]
    ]

    __keyword: context [
        get: func [keywords [series!] key [word!]][
            select keywords key
        ]

        keys: func [keywords [series!]][
            collect [foreach [key _] keywords [keep key]]
        ]

        values: func [keywords [series!]][
            collect [foreach [_ value] keywords [keep value]]
        ]
    ]

    __error: context [raise: func [message][do make error! message]]
]

do-mods: :mods/__require
