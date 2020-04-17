# NOTE: v2 complains with error: no resource plugin 'aws' found in the workspace or on your $PATH:
# FROM pulumi/pulumi:v2.0.0-beta.2

FROM pulumi/pulumi:v1.14.1

RUN \
	wget https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz \
	&& tar -C /usr/local -xzf ./go1.14.2.linux-amd64.tar.gz \
	&& rm ./go1.14.2.linux-amd64.tar.gz

ENV \
	PATH="${PATH}:/usr/local/go/bin" \
	GOPATH="/go"

WORKDIR /go/repo

ENTRYPOINT [ "bash" ]
