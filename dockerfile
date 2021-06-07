FROM alpine:latest

RUN apk add bash curl coreutils

WORKDIR /app

COPY freenom-script/freenom.sh .

ARG FREENOM_EMAIL
ARG FREENOM_PASSWORD
RUN echo -e "freenom_email=\"$FREENOM_EMAIL\"\n\
freenom_passwd=\"$FREENOM_PASSWORD\"\n\
" > freenom.conf

ENTRYPOINT [ "./freenom.sh" ]
