FROM alpine:latest

RUN apk update && apk --no-cache add php php-mysqli

WORKDIR /htdocs
COPY --chmod=755 entry.sh /

ENTRYPOINT ["/bin/sh"]
