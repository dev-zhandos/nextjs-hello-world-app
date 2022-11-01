FROM node:16-alpine
ENV NODE_ENV=production

RUN apk --no-cache add curl

WORKDIR /app

COPY ["package.json", "package-lock.json*", "./"]

RUN npm install --omit=dev

COPY . .

EXPOSE 3000

CMD [ "npm", "start" ]