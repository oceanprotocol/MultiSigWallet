FROM ubuntu:focal
LABEL maintainer="Ocean Protocol <devops@oceanprotocol.com>"

# Declare constants
ENV NVM_VERSION v0.29.0
ENV NODE_VERSION v6.17.1

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install pre-reqs
RUN apt-get update
RUN apt-get -y install curl build-essential
RUN apt-get install -y libudev-dev libusb-dev git python make g++

# Install NVM
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash

# Install NODE
RUN source ~/.nvm/nvm.sh; \
    nvm install $NODE_VERSION; \
    nvm use --delete-prefix $NODE_VERSION; \
    nvm alias default "$NODE_VERSION" && \
    nvm use default && \
    DEFAULT_NODE_VERSION=$(nvm version default) && \
    ln -sf /root/.nvm/versions/node/$DEFAULT_NODE_VERSION/bin/node /usr/bin/nodejs && \
    ln -sf /root/.nvm/versions/node/$DEFAULT_NODE_VERSION/bin/node /usr/bin/node && \
    ln -sf /root/.nvm/versions/node/$DEFAULT_NODE_VERSION/bin/npm /usr/bin/npm && \
    ln -sf /usr/bin/python3.7 /usr/bin/python

COPY . /multisigwallet
WORKDIR /multisigwallet
RUN npm install node-gyp
RUN npm install -g grunt-cli
RUN npm install
EXPOSE 5000

ENTRYPOINT ["/multisigwallet/docker-entrypoint.sh"]