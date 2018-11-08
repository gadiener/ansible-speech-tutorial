#!/bin/sh

set -eu

function help_message {
	title "Usage: use-step STEP"
	echo
	message "Use tutorial step."
	echo
	echo 'Steps:'
    echo '   1    Simple commands'
    echo '   2    Simple playbook'
    echo '   3    Advanced playbook'
    echo
    echo "Run 'use-step 1' to start"
    echo
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

function init {
    message "adding the step ${1}"
    cp -rpf /home/ansible/steps/${1}-*/* /workspace/
    mdv /workspace/README.md
}

function remove {
    message "emptying the workplace"
    rm -rf /workspace/*
}

if [[ $# -gt 0 ]]; then
    while [[ $# -gt 0 ]];do
        key="${1}"

        case ${key} in
            -h|--help)
                help_message
            ;;
            1|2|3)
                STEP=${key}
                shift
            ;;
            *)
                error_message "Unrecognized step ${key}"
            ;;
        esac
    done
else
    error_message "Missing step parameter"
fi

title "Installing tutorial step"
remove
init ${key}
