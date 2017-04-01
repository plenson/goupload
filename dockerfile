FROM ubuntu:16.04
MAINTAINER Jefferson Otoni <jeff.otoni@gmail.com>

RUN apt-get update 

RUN apt-get upgrade -f -y --force-yes

RUN apt-get install nmap -f -y --force-yes

RUN apt-get install curl -f -y --force-yes

RUN apt-get install vim -f -y --force-yes

RUN apt-get install --no-install-recommends -y \
    ca-certificates \
    curl \
    mercurial \
    git-core

RUN curl -s https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz | tar -v -C /usr/local -xz

ENV GOPATH /go
ENV GOROOT /usr/local/go
ENV PATH /usr/local/go/bin:/go/bin:/usr/local/bin:$PATH

# Copy the local package files to the container's workspace.
#ADD . /go/src/github.com/jeffotoni/goupload

RUN mkdir -p /go/src/github.com/jeffotoni && cd /go/src/github.com/jeffotoni && git clone https://github.com/jeffotoni/goupload

RUN go get -u github.com/boltdb/bolt && go get -u github.com/gorilla/mux && go get -u github.com/jeffotoni/goupload

RUN cd /go/src/github.com/jeffotoni/goupload && go install

WORKDIR /go/src/github.com/jeffotoni

# Build the jeffotoni command inside the container.
# (You may fetch or manage dependencies here,
# either manually or with a tool like "godep".)
#RUN go install github.com/jeffotoni/goupload

# Run the outyet command by default when the container starts.

ENTRYPOINT /go/bin/goupload start

# Document that the service listens on port 8080.
EXPOSE 8080

CMD ["bash"]
#CMD ["go", "run", "/go/src/github.com/jeffotoni/goupload/goupload.go"] 
#docker run --publish 4001:8080 --name goupload --rm ubuntu16.4/gouload:version1.0
#docker run -p 4001:8080 --name goupload --rm ubuntu16.4/gouload:version1.0