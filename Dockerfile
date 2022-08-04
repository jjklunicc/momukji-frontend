FROM node:18-alpine as builder

COPY package.json package-lock.json ./

RUN npm install && mkdir /momukji-frontend && mv ./node_modules ./momukji-frontend

WORKDIR /momukji-frontend

COPY . .

RUN npm run build


FROM nginx:alpine

COPY ./.nginx/nginx.conf /etc/nginx/nginx.conf

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /momukji-frontend/out /usr/share/nginx/html

EXPOSE 3000 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]