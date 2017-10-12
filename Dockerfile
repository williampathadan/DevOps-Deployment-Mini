# Add the contents of your Dockerfile here

FROM node:8.7

WORKDIR /usr/src/app

COPY package.json package-lock.json ./

RUN npm install

COPY . .

EXPOSE 8080
CMD ["npm", "start"]