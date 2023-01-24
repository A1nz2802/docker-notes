# FROM --platform=arm64 node:19.2-alpine3.16
# FROM node:19.2-alpine3.16
# FROM --platform=$BUILDPLATFORM node:19.2-alpine3.16
FROM node:19.2-alpine3.16

WORKDIR /app

COPY package.json ./

RUN npm i

COPY . .

RUN npm run test

# Eliminar archivos no necesarios para prod
RUN rm -rf tests/ && rm -rf node_modules/ 

# Instalar dependencias de prod
RUN npm i --omit=dev

CMD ["npm","run","start"]