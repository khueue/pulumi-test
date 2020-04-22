#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

aws cloudformation deploy \
	--region ${AWS_REGION} \
	--stack-name ${CFN_STACK_NAME} \
	--template-file ./pulumi-state.yaml
