#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

# Default region.
export AWS_REGION="eu-west-1"

aws cloudformation deploy \
	--region ${AWS_REGION} \
	--stack-name PulumiState \
	--template-file ./pulumi-state.yaml
