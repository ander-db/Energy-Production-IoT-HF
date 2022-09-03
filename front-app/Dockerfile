FROM node:current-alpine3.16

WORKDIR /app

COPY package*.json ./

COPY . .

RUN npm install

RUN npm i react-router-dom --save

EXPOSE 3000

CMD ["npm", "start"]
