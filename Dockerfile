FROM node:latest

WORKDIR /app

COPY package*.json ./

RUN npm install --only=production

COPY . .

EXPOSE 8000

CMD ["node", "index.js"]