#!/usr/bin/env bash

set -o errexit
set -o pipefail
# set -o nounset
# set -o xtrace

function usage_and_exit {
	if [[ "${PROJECT_DIR}" == "" ]]; then
		PROJECT_DIR=projects/my-project
	fi
	if [[ "${STACK_NAME}" == "" ]]; then
		STACK_NAME=stage
	fi
	echo "Usage:"
	echo "bin/pulumi-${RUNTIME} ${PROJECT_DIR} new"
	echo "bin/pulumi-${RUNTIME} ${PROJECT_DIR} ${STACK_NAME} up"
	echo "bin/pulumi-${RUNTIME} ${PROJECT_DIR} ${STACK_NAME} destroy"
	echo "bin/pulumi-${RUNTIME} ${PROJECT_DIR} ${STACK_NAME} shell"
	exit 1
}

PROJECT_DIR=$1
STACK_NAME=$2
ACTION=$3

if [[ "$2" == "new" ]]; then
	ACTION=$2
	STACK_NAME="<unused>"
fi

if [[ "${PROJECT_DIR}" == "" || "${STACK_NAME}" == "" || "${ACTION}" == "" ]]; then
	usage_and_exit
fi

export PROJECT_DIR
export STACK_NAME
export ACTION

echo "--- Running Pulumi (${RUNTIME}) in Docker ..."
make pulumi runner_script=./scripts/pulumi-${RUNTIME}.sh
