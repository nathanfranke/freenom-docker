FROM node:16-alpine

RUN apk add bash curl coreutils

WORKDIR /app

COPY package.json ./

RUN npm install

COPY app.js freenom-script/freenom.sh ./

ARG FREENOM_EMAIL
ARG FREENOM_PASSWORD
RUN printf "freenom_email=\"$FREENOM_EMAIL\"\n\
freenom_passwd=\"$FREENOM_PASSWORD\"\n\
" > freenom.conf

ENTRYPOINT [ "npm", "start" ]
