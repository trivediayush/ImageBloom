FROM node

WORKDIR /myapp


COPY . .

RUN npm install

EXPOSE 5173

CMD [ "npm", "run", "dev" ]