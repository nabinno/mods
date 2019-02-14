Red []

CURRENT-PATH: system/script/args

redmodule: context [
    MODULE-DIRECTORY: rejoin [CURRENT-PATH %red_modules/]
    MODULES: [] ; @type series!.<key [word!] #(name [string!] init [path!] git [url!] require [series!])>
    unless exists? MODULE-DIRECTORY [make-dir MODULE-DIRECTORY]

    get: func [packages [series!]][
        if empty? packages [__error/raise rejoin ["Packages does not exist."]]

        self/MODULES: packages
        package-maps: __keyword/values MODULES
        __series/each package-maps pm [redmodule/__do-git-submodule pm/git]
        call "git submodule foreach git pull origin master"
    ]

    clean: does [call rejoin ["rm -fr " MODULE-DIRECTORY]]

    require: func [module-names [word! block! none!]][
        if empty? MODULES [__error/raise rejoin ["Does not setup MODULES."]]

        module-names: either module-names [append [] module-names][__keyword/keys MODULES]
        __series/each module-names mn [redmodule/__do-require mn]
    ]

    __do-git-submodule: func [git-path [url!]][
        path-series: split git-path "/" domain: third path-series name: fourth path-series repo: fifth path-series
        local-path: to-string rejoin [MODULE-DIRECTORY domain "/" name "/" repo]

        call rejoin ["git submodule add --force" " --name " local-path " -- " git-path space local-path]
        call/wait rejoin ["git submodule absorbgitdirs " local-path]
    ]

    __do-require: func [name][
        package: __keyword/get MODULES name ; @type #(name [string!] init [path!] git [path!] require [series!])
        unless package [__error/raise rejoin ["Package " name " does not exist."]]

        path-series: split package/git "/" domain: third path-series name: fourth path-series repo: fifth path-series
        init-file: to-red-file rejoin [MODULE-DIRECTORY domain "/" name "/" repo "/" package/init]
        unless exists? init-file [__error/raise rejoin ["Initial file " init-file " does not exist."]]

        if package/require [foreach rp package/require [do-call rp]]

        do init-file
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

do-redmodule: :redmodule/require
