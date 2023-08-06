FROM node:14-alpine

COPY . /app

WORKDIR /app

RUN npm install --production
RUN npm cache clean --force

EXPOSE 3000

CMD ["node", "index.js"]