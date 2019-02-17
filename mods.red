Red []

CURRENT-PATH: system/script/args

mods: context [
    MODULE-DIRECTORY: rejoin [CURRENT-PATH %mods/]
    GITMODULES-PATH: rejoin [CURRENT-PATH %.gitmodules]
    REQUIRE-PATH: %github.com/nabinno/mods/require.red
    MODS-KEYWORD: [mods #(init: mods.red git: https://github.com/nabinno/mods)]
    unless exists? MODULE-DIRECTORY [make-dir MODULE-DIRECTORY]
    unless exists? GITMODULES-PATH [write GITMODULES-PATH ""]

    get: does [
        modules: __get-modules
        package-maps: __keyword/values modules
        __series/each package-maps pm [mods/__do-git-submodule pm/git]
        call/wait "git submodule foreach git pull origin master"
        __set-require
    ]

    clean: does [
        if exists? GITMODULES-PATH [delete GITMODULES-PATH]
        if exists? MODULE-DIRECTORY [call rejoin ["rm -fr " MODULE-DIRECTORY]]
    ]

    __do-git-submodule: func [git-path [url!]][
        path-series: split git-path "/" domain: third path-series name: fourth path-series repo: fifth path-series
        local-path: to-string rejoin [MODULE-DIRECTORY domain "/" name "/" repo]

        call rejoin ["git submodule add --force" " --name " local-path " -- " git-path space local-path]
        call/wait rejoin ["git submodule absorbgitdirs " local-path]
    ]

    __set-require: does [
        write rejoin [CURRENT-PATH %require] read rejoin [MODULE-DIRECTORY REQUIRE-PATH]
    ]

    ; @return series!.<key [word!] #(name [string!] init [path!] git [url!] require [series!])>
    __get-modules: does [
        do rejoin [CURRENT-PATH %hots.red]
        either empty? hots/mods [
            __error/raise rejoin ["Does not setup hots/mods."]
        ][
            append hots/mods MODS-KEYWORD
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
