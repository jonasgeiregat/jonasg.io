FROM alpine:latest as build

ARG HUGO_VERSION=0.88.0

ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz /hugo.tar.gz
RUN tar -zxvf hugo.tar.gz
RUN /hugo version

RUN apk add --no-cache git

COPY . /jonasg.io
WORKDIR /jonasg.io

RUN /hugo --minify --enableGitInfo

FROM nginx:1.15-alpine

WORKDIR /usr/share/nginx/html/

# Clean the default public folder
RUN rm -fr * .??*

COPY --from=build /jonasg.io/public /usr/share/nginx/html
