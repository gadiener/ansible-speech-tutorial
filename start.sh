#!/bin/bash

set -u
set -o pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

NOF_HOSTS=3
NETWORK_NAME="ansible.speech"
WORKSPACE="${BASEDIR}/workspace"
ANSIBLE_CONF="${BASEDIR}/ansible"

HOSTPORT_BASE=${HOSTPORT_BASE:-40000}
EXTRA_PORTS=( "443" "443" "443" )

DOCKER_IMAGETAG=${DOCKER_IMAGETAG:-1.1}
DOCKER_HOST_IMAGE="gdiener/ansible-speech-host"
TUTORIAL_IMAGE="gdiener/ansible-speech-control"
DOMAIN='caffeina.com'

MODE='init'

function help_message {
	title "Usage: start.sh [OPTIONS]"
	echo
	message "Run example docker containers for testing Ansible."
	echo
	echo 'Options:'
    echo '   --remove    Remove all containers'
    echo '   --restart   Restart all containers'
	exit 2
}

function error_message {
	echo "[!] ${1}, use '--help' flag for more information"
	exit 1
}

function title {
    echo
	echo "${1}"
}

function message {
	echo ">> ${1}"
}

function doesNetworkExist() {
    return $(docker network inspect $1 >/dev/null 2>&1)
}

function removeNetworkIfExists() {
    doesNetworkExist $1 && message "Removing network $1" && docker network rm $1 >/dev/null
}

function doesContainerExist() {
    return $(docker inspect $1 >/dev/null 2>&1)
}

function isContainerRunning() {
    [[ "$(docker inspect -f "{{.State.Running}}" $1 2>/dev/null)" == "true" ]]
}

function killContainerIfExists() {
    doesContainerExist $1 && \
    message "killing/removing container $1" && { docker kill $1 >/dev/null 2>&1; docker rm $1 >/dev/null 2>&1; };
}

function runHostContainer() {
    local name=$1
    local image=$2
    local port1=$(($HOSTPORT_BASE + $3))
    local port2=$(($HOSTPORT_BASE + $3 + $NOF_HOSTS))

    title "Starting container ${name}:"
    message "mapping hostport $port1 -> container port 80"
    message "hostport $port2 -> container port ${EXTRA_PORTS[$3]}"

    if doesContainerExist ${name}; then
        docker start "${name}" > /dev/null
    else
        docker run -d -p $port1:80 -p $port2:${EXTRA_PORTS[$3]} --net ${NETWORK_NAME} --name="${name}" "${image}" >/dev/null
    fi
    if [ $? -ne 0 ]; then
        error_message "Could not start host container. Exiting!"
    fi
}

function runControllerContainer() {
    killContainerIfExists ansible.speech > /dev/null
    title "Starting container ansible.speech"
    docker run -it \
        -v "${WORKSPACE}":/workspace \
        -v "${ANSIBLE_CONF}":/etc/ansible \
        --net ${NETWORK_NAME} \
        -e "HOSTPORT_BASE=${HOSTPORT_BASE}" \
        --name="ansible.speech" \
        ${TUTORIAL_IMAGE}
    return $?
}

function remove () {
    title "Removing containers"
    for ((i = 0; i < $NOF_HOSTS; i++)); do
       killContainerIfExists host$i.$DOMAIN
    done

    killContainerIfExists ansible.speech

    removeNetworkIfExists ${NETWORK_NAME}
}

function setupHostsFile() {
    local hosts_file="${BASEDIR}/ansible/hosts"
    rm -f "${hosts_file}"

    for ((i = 0; i < $NOF_HOSTS; i++)); do
        ip=$(docker network inspect --format="{{range \$id, \$container := .Containers}}{{if eq \$container.Name \"host$i.$DOMAIN\"}}{{\$container.IPv4Address}} {{end}}{{end}}" ${NETWORK_NAME} | cut -d/ -f1)
        echo "host$i.$DOMAIN ansible_host=$ip ansible_user=root" >> "${hosts_file}"
    done
}

function init () {
    mkdir -p "${WORKSPACE}"
    doesNetworkExist "${NETWORK_NAME}" || {
        title "Creating network ${NETWORK_NAME}" && \
        docker network create "${NETWORK_NAME}" >/dev/null;
    }

    for ((i = 0; i < $NOF_HOSTS; i++)); do
       isContainerRunning host$i.$DOMAIN || runHostContainer host$i.$DOMAIN ${DOCKER_HOST_IMAGE} $i
    done

    setupHostsFile
    runControllerContainer

    exit $?
}

while [[ $# -gt 0 ]];do
	key="${1}"

	case ${key} in
        -h|--help)
			help_message
		;;
        --remove)
            MODE='remove'
            shift
        ;;
        --restart)
            MODE='restart'
            shift
        ;;
        *)
        error_message "Unrecognized option ${key}"
    esac
done

if [ "${MODE}" == 'remove' ]; then
    remove
    exit 0
elif [ "${MODE}" == "restart" ]; then
    remove
fi

init
