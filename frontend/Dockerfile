# Use official node image as builder
FROM node:18-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json* ./

RUN npm install

COPY . .

RUN npm run build

# Use nginx to serve the build folder
FROM nginx:stable-alpine

COPY --from=builder /app/build /usr/share/nginx/html

# Copy custom nginx config if you have one, else default works fine

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
