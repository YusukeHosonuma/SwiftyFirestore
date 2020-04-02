FROM node:alpine

RUN apk add --no-cache openjdk8-jre

RUN npm i -g firebase-tools && firebase setup:emulators:firestore

EXPOSE 8080

ENTRYPOINT [ "firebase", "emulators:start", "--only", "firestore" ]
