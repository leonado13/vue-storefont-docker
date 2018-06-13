#!/usr/bin/env bash

function usage() {
  echo -n "

${tan}Usage:${reset}
    console app [command] [arguments]

${tan}Commands:${reset}
    install             Runs the necessary steps to get the project installed locally
    exec                Runs ${blue}docker-compose exec${reset} against the booking service
    npm                 Compile frontend assets

"
}

case "$1" in
    install)
        if [ -d "${appRootDir}" ]; then
            echo "APP already cloned"
        else
        echo ${appGitDir}
        echo ${appRootDir}
            git clone --recursive "${appGitDir}" "${appRootDir}"
        fi
    ;;

    exec)
        shift 1
        if [ "${EXEC}" == "yes" ]; then
            ${COMPOSE} exec -u crafter booking "$@"
        else
            ${COMPOSE} run --rm booking "$@"
        fi
    ;;

    *)
        usage
    ;;
esac
