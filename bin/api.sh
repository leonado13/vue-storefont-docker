#!/usr/bin/env bash

function usage() {
  echo -n "

${tan}Usage:${reset}
    console api [command] [arguments]

${tan}Commands:${reset}
    install             Runs the necessary steps to get the project installed locally
    exec                Runs ${blue}docker-compose exec${reset} against the booking service
    npm                 Compile frontend assets

"
}

case "$1" in
    install)
        if [ -d "${apiRootDir}" ]; then
            echo "API already installed"
        else
            git clone --recursive git@gitlab.production.smartbox.com:web/booking.git "${apiRootDir}"
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

    npm | grunt)
        shift 1
        NPM_IMAGE="node:9.3.0"

        docker pull ${NPM_IMAGE}

        docker run -it --rm \
            -w /usr/src/app \
            -v ${configurationRootDir}/ssh/known_hosts:/root/.ssh/known_hosts \
            -v ~/.ssh/id_rsa:/root/.ssh/id_rsa \
            -v ~/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub \
            -v ${jarvisBookingRootDir}:/usr/src/app \
            ${NPM_IMAGE} npm "${@}"
    ;;

    *)
        usage
    ;;
esac
