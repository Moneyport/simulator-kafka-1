FROM node:10.15.3-alpine as builder
WORKDIR /opt/app

RUN apk add --no-cache -t build-dependencies git make gcc g++ python libtool autoconf automake \
    && cd $(npm root -g)/npm \
    && npm config set unsafe-perm true \
    && npm install -g node-gyp

# Main central-services-stream project
COPY package.json package-lock.json /opt/app/
COPY src /opt/app/src
COPY config /opt/app/config
# RUN npm install

WORKDIR /opt/app

RUN npm install

FROM node:10.15.3-alpine
WORKDIR /opt/app

COPY --from=builder /opt/app .

# RUN npm prune --production


# Create empty log file & link stdout to the application log file
# RUN mkdir ./logs && touch ./logs/combined.log
# RUN ln -sf /dev/stdout ./logs/combined.log
WORKDIR /opt/app
EXPOSE 6868
# CMD ["node", "index.js" "produce", "--maxMessages", "10", "--payloadSize", "180", "--topic", "test1", "--api"]
