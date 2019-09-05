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
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY --from=builder /workspace/goInception /workspace/goInception

WORKDIR /workspace

EXPOSE 3306

