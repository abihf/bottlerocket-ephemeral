FROM alpine
RUN apk add e2fsprogs
ADD setup.sh ./
ENTRYPOINT ["sh", "/setup.sh"]