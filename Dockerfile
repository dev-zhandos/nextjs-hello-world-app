FROM node:carbon
ENV NODE_ENV=production

RUN apk add curl

WORKDIR /app

COPY ["package.json", "package-lock.json*", "./"]

RUN npm install --omit=dev

COPY . .

CMD [ "npm", "start" ]