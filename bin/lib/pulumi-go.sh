#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

source ./bin/lib/base.sh

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
	base_require_stack_name
	base_do_up
elif [[ "${ACTION}" == "destroy" ]]; then
	base_require_stack_name
	base_do_destroy
elif [[ "${ACTION}" == "shell" ]]; then
	base_require_stack_name
	base_do_shell
else
	echo "Unknown action: '${ACTION}'"
	exit 1
fi
