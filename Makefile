default:
	@ cat ./Makefile

IMAGE_TAG=pulumi-shell

build-pulumi-image:
	@ docker build \
		--file ./Dockerfile ./ \
		--tag $(IMAGE_TAG) \
		&>/dev/null

pulumi: build-pulumi-image
	@ mkdir -p ./_tmp/cache
	@ mkdir -p ./_tmp/pkg
	@ mkdir -p ./_tmp/pulumi

	@ docker run --interactive --tty --rm \
		--mount type="bind",source="$(PWD)",target="/go/repo",consistency="delegated" \
		--mount type="bind",source="$(PWD)/lib",target="/usr/local/go/src/lib",consistency="delegated",readonly \
		--mount type="bind",source="$(PWD)/scripts",target="/_scripts",consistency="delegated",readonly \
		--mount type="bind",source="$(PWD)/_tmp/cache",target="/go/cache",consistency="delegated" \
		--mount type="bind",source="$(PWD)/_tmp/pkg",target="/go/pkg",consistency="delegated" \
		--mount type="bind",source="$(PWD)/_tmp/pulumi",target="/root/.pulumi",consistency="delegated" \
		--env GOCACHE="/go/cache" \
		--env PROJECT_DIR="$(PROJECT_DIR)" \
		--env STACK_NAME="$(STACK_NAME)" \
		--env ACTION="$(ACTION)" \
		$(IMAGE_TAG) \
		/_scripts/pulumi-run.sh

provision-pulumi-state-stack: build-pulumi-image
	@ docker run --interactive --tty --rm \
		--mount type="bind",source="$(PWD)/cloudformation",target="/workdir",consistency="delegated",readonly \
		--workdir /workdir \
		$(IMAGE_TAG) \
		provision.sh
