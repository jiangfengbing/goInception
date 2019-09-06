FROM golang:1.12 as builder
# MAINTAINER hanchuanchuan <chuanchuanhan@gmail.com>

ENV TZ=Asia/Shanghai
ENV LANG="en_US.UTF-8"

ADD ./ /workspace
WORKDIR /workspace
RUN rm -f go.sum && make parser && go build -o goInception tidb-server/main.go

# Executable image
FROM debian:stretch-slim

ENV LANG="en_US.UTF-8"
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
  && apt update && apt install --no-install-recommends wget perl libdbi-perl libdbd-mysql-perl libterm-readkey-perl libio-socket-ssl-perl -y \
  && wget https://www.percona.com/downloads/percona-toolkit/3.0.13/binary/debian/stretch/x86_64/percona-toolkit_3.0.13-1.stretch_amd64.deb \
  && dpkg -i percona-toolkit_3.0.13-1.stretch_amd64.deb \
  && rm percona-toolkit_3.0.13-1.stretch_amd64.deb && rm -rf /var/cache/apt

COPY --from=builder /workspace/goInception /workspace/goInception

WORKDIR /workspace

EXPOSE 3306

