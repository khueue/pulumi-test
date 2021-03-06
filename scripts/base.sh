#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Scope Pulumi to project dir.
mkdir -p ${PROJECT_DIR}
cd ${PROJECT_DIR}

# Region for Pulumi housekeeping and default for new stack configs.
export AWS_REGION=${MAIN_AWS_REGION}

# Use pre-created bucket for state.
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
STATE_BUCKET_NAME="pulumi-state-${AWS_ACCOUNT_ID}"

# Use pre-created KMS key for secrets encryption.
SECRETS_PROVIDER="awskms://alias/pulumi-secrets?region=${AWS_REGION}"

# Silence Pulumi with empty passphrase (actually using KMS).
export PULUMI_CONFIG_PASSPHRASE=""

PROJECT_NAME=$(basename ${PROJECT_DIR})

declare -a DEFAULT_STACK_NAMES=(
	dev
	stage
	prod
)

function base_do_stack_inits {
	for STACK_NAME in "${DEFAULT_STACK_NAMES[@]}"; do
		echo
		echo "--- Creating config for '${STACK_NAME}' ..."

		# No need for remote state when just scaffolding.
		LOCAL_STATE_FILE=/tmp/${PROJECT_NAME}/${STACK_NAME}
		mkdir -p ${LOCAL_STATE_FILE}
		pulumi login \
			file://${LOCAL_STATE_FILE}

		pulumi stack init \
			--secrets-provider="${SECRETS_PROVIDER}" \
			--stack="${STACK_NAME}"

		pulumi config \
			--stack="${STACK_NAME}" \
			set aws:region ${AWS_REGION}
	done
}

function base_do_up {
	base_use_remote_state

	echo
	echo "--- Provisioning stack '${STACK_NAME}' ..."
	pulumi up \
		--refresh \
		--diff \
		--secrets-provider="${SECRETS_PROVIDER}" \
		--stack="${STACK_NAME}"
}

function base_do_destroy {
	base_use_remote_state

	echo
	echo "--- Destroying stack '${STACK_NAME}' ..."
	pulumi destroy \
		--stack="${STACK_NAME}"
}

function base_do_shell {
	base_use_remote_state

	echo
	echo "--- Starting shell for stack '${STACK_NAME}' ..."
	echo "--- Placing you in the project folder, with direct access to pulumi."
	bash
}

function base_use_remote_state {
	echo
	echo "--- Connecting to remote state ..."
	pulumi login \
		s3://${STATE_BUCKET_NAME}/${PROJECT_NAME}/${STACK_NAME}
}

function base_error_unknown_action {
	echo "Unknown stack action: '${ACTION}'"
	exit 1
}
