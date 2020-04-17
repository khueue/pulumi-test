#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Default region.
export AWS_REGION="eu-west-1"

# Use precreated bucket for state.
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
STATE_BUCKET_NAME=pulumi-state-${AWS_ACCOUNT_ID}

# USe precreated KMS key for secrets encryption.
SECRETS_PROVIDER="awskms://alias/pulumi-secrets?region=${AWS_REGION}"

# Silence Pulumi with empty passphrase (actually using KMS).
export PULUMI_CONFIG_PASSPHRASE=""

PROJECT_NAME=$(basename ${PROJECT_DIR})

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
	declare -a DEFAULT_STACK_NAMES=(
		dev
		stage
		prod
	)
	for STACK_NAME in "${DEFAULT_STACK_NAMES[@]}"; do
		LOCAL_STATE_FILE=/tmp/${PROJECT_NAME}/${STACK_NAME}
		mkdir -p ${LOCAL_STATE_FILE}
		pulumi login \
			file://${LOCAL_STATE_FILE}

		pulumi stack init \
			--secrets-provider="${SECRETS_PROVIDER}" \
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
		--diff \
		--secrets-provider="${SECRETS_PROVIDER}" \
		--stack="${STACK_NAME}"
}

function do_destroy {
	pulumi login \
		s3://${STATE_BUCKET_NAME}/${PROJECT_NAME}/${STACK_NAME}
	pulumi destroy \
		--stack="${STACK_NAME}"
}

function do_shell {
	pulumi login \
		s3://${STATE_BUCKET_NAME}/${PROJECT_NAME}/${STACK_NAME}
	bash
}

function require_stack_name {
	if [[ "${STACK_NAME}" == "" ]]; then
		echo "STACK_NAME is required"
		exit 1
	fi
}

if [[ "${ACTION}" == "new" ]]; then
	do_new
elif [[ "${ACTION}" == "up" ]]; then
	require_stack_name
	do_up
elif [[ "${ACTION}" == "destroy" ]]; then
	require_stack_name
	do_destroy
elif [[ "${ACTION}" == "shell" ]]; then
	require_stack_name
	do_shell
else
	echo "Unknown action: '${ACTION}'"
	exit 1
fi
