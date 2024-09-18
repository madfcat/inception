FROM alpine:3.19

RUN apk add --no-cache redis

CMD ["redis-server", "--protected-mode no"]
# CMD ["redis-server", "/etc/redis.conf"]