#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

source ./scripts/base.sh

function do_new {
	echo
	echo "--- Creating TypeScript project scaffold ..."
	pulumi new aws-typescript \
		--generate-only \
		--non-interactive \
		--name="${PROJECT_NAME}" \
		--description="${PROJECT_NAME}"
}

function do_dependencies {
	echo
	echo "--- Installing dependencies ..."
	npm install
}

if [[ "${ACTION}" == "new" ]]; then
	do_new
	base_do_stack_inits
elif [[ "${ACTION}" == "up" ]]; then
	do_dependencies
	base_do_up
elif [[ "${ACTION}" == "destroy" ]]; then
	base_do_destroy
elif [[ "${ACTION}" == "shell" ]]; then
	base_do_shell
else
	echo "Unknown action: '${ACTION}'"
	exit 1
fi
