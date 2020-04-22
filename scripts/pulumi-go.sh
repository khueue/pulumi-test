#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

source ./scripts/base.sh

function do_new {
	echo
	echo "--- Creating Go project scaffold ..."
	pulumi new aws-go \
		--generate-only \
		--non-interactive \
		--name="${PROJECT_NAME}" \
		--description="${PROJECT_NAME}"
}

if [[ "${ACTION}" == "new" ]]; then
	do_new
	base_do_stack_inits
elif [[ "${ACTION}" == "up" ]]; then
	base_do_up
elif [[ "${ACTION}" == "destroy" ]]; then
	base_do_destroy
elif [[ "${ACTION}" == "shell" ]]; then
	base_do_shell
else
	base_error_unknown_action
fi
