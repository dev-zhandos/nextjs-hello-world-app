FROM node:alpine
ENV NODE_ENV=production

RUN apk --no-cache add curl

WORKDIR /app

COPY ["package.json", "package-lock.json*", "./"]

RUN npm install --omit=dev

COPY . .

CMD [ "npm", "start" ]