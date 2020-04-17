#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Default region.
export AWS_REGION="eu-west-1"

# Make sure Pulumi state bucket exists within current AWS account.
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
STATE_BUCKET_NAME=pulumi-state-${AWS_ACCOUNT_ID}
aws s3 mb --region ${AWS_REGION} s3://${STATE_BUCKET_NAME} 2>/dev/null || true

PROJECT_NAME=$(basename ${PROJECT_DIR})

# Use empty passphrase for now. Try KMS?
export PULUMI_CONFIG_PASSPHRASE=""

# Scope Pulumi to project dir.
mkdir -p ${PROJECT_DIR}
cd ${PROJECT_DIR}

function do_new {
	# Create project scaffold.
	pulumi new aws-go \
		--generate-only \
		--non-interactive \
		--name="${PROJECT_NAME}" \
		--description="${PROJECT_NAME}"

	# Create configs for default environments.
	declare -a STACK_NAMES=(
		stage
		prod
	)
	for STACK_NAME in "${STACK_NAMES[@]}"; do
		pulumi login \
			s3://${STATE_BUCKET_NAME}/${PROJECT_NAME}/${STACK_NAME}
		pulumi stack init \
			--stack=${STACK_NAME}
		pulumi config \
			--stack=${STACK_NAME} \
			set aws:region ${AWS_REGION}
	done
}

function do_up {
	pulumi login \
		s3://${STATE_BUCKET_NAME}/${PROJECT_NAME}/${STACK_NAME}
	pulumi up \
		--stack="${STACK_NAME}"
}

function do_destroy {
	pulumi login \
		s3://${STATE_BUCKET_NAME}/${PROJECT_NAME}/${STACK_NAME}
	pulumi destroy \
		--stack="${STACK_NAME}"
}

if [[ "${ACTION}" == "new" ]]; then
	do_new
elif [[ "${ACTION}" == "up" ]]; then
	do_up
elif [[ "${ACTION}" == "destroy" ]]; then
	do_destroy
else
	echo "Unknown action: '${ACTION}'"
	exit 1
fi
