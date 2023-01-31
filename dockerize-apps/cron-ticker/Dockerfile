# FROM --platform=arm64 node:19.2-alpine3.16
# FROM node:19.2-alpine3.16
# FROM --platform=$BUILDPLATFORM node:19.2-alpine3.16
# dev dependencies
FROM node:19.2-alpine3.16 as deps

WORKDIR /app

COPY package.json ./

RUN npm i

# build & test
FROM node:19.2-alpine3.16 as builder

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules

COPY . .

RUN npm run test
# RUN npm run build

# run app
FROM node:19.2-alpine3.16 as runner

WORKDIR /app

COPY app.js ./
COPY tasks/ ./tasks
COPY package.json ./

# Instalar dependencias de prod
RUN npm i --omit=dev

CMD ["npm","run","start"]