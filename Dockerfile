FROM pulumi/pulumi:v2.0.0

RUN \
	wget https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz \
	&& tar -C /usr/local -xzf ./go1.14.2.linux-amd64.tar.gz \
	&& rm ./go1.14.2.linux-amd64.tar.gz

ENV \
	PATH="${PATH}:/usr/local/go/bin" \
	GOPATH="/go"

WORKDIR /go/repo

ENTRYPOINT [ "bash" ]
