default:
	@ cat ./Makefile

IMAGE_TAG=pulumi-shell
MAIN_AWS_REGION=eu-west-1

setup:
	@ mkdir -p ./_tmp/cache
	@ mkdir -p ./_tmp/pkg
	@ mkdir -p ./_tmp/pulumi

	@ docker build \
		--file ./Dockerfile ./ \
		--tag $(IMAGE_TAG) \
		&>/dev/null

# NOTE: Shared container for everything, for now.
pulumi: setup
	@ docker run --interactive --tty --rm \
		--mount type="bind",source="$(PWD)",target="/go/repo",consistency="delegated" \
		--mount type="bind",source="$(PWD)/lib/go",target="/usr/local/go/src/lib",consistency="delegated",readonly \
		--mount type="bind",source="$(PWD)/_tmp/cache",target="/go/cache",consistency="delegated" \
		--mount type="bind",source="$(PWD)/_tmp/pkg",target="/go/pkg",consistency="delegated" \
		--mount type="bind",source="$(PWD)/_tmp/pulumi",target="/root/.pulumi",consistency="delegated" \
		--env GOCACHE="/go/cache" \
		--env MAIN_AWS_REGION="$(MAIN_AWS_REGION)" \
		--env PROJECT_DIR="$(PROJECT_DIR)" \
		--env STACK_NAME="$(STACK_NAME)" \
		--env ACTION="$(ACTION)" \
		$(IMAGE_TAG) \
		${runner_script}

provision-pulumi-state-stack: setup
	@ docker run --interactive --tty --rm \
		--mount type="bind",source="$(PWD)/cloudformation",target="/workdir",consistency="delegated",readonly \
		--workdir /workdir \
		--env AWS_REGION="$(MAIN_AWS_REGION)" \
		--env CFN_STACK_NAME="PulumiState" \
		$(IMAGE_TAG) \
		./provision.sh
