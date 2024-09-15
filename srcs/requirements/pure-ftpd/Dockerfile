FROM alpine:3.19

RUN apk update && apk add --no-cache pure-ftpd

RUN mkdir -p /var/lib/ftp
RUN chmod 755 /var/lib/ftp
RUN chown ftp:ftp /var/lib/ftp

CMD ["pure-ftpd", "-j", "-p", "30000:30009", "-P", "localhost", "-d", "-d"]
