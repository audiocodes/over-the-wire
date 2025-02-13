FROM node:22.13.1-alpine3.21 AS build
RUN sed -i 's/https/http/' /etc/apk/repositories
RUN apk add --no-cache \
  cmake \
  g++ \
  jq \
  less \
  libpcap-dev \
  make \
  tshark
WORKDIR /app
COPY package*.json ./
RUN npm ci --ignore-scripts
COPY . .
RUN CMAKE_BUILD_PARALLEL_LEVEL=$(nproc) npm run precompile
RUN npm test

FROM scratch
COPY --from=build /app/prebuilds/ .
