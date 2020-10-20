# Copyright © Allan Paiste. All rights reserved.
# See LICENSE.txt for license details.
FROM node:12 as base

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends ruby \
       ruby-dev make gcc curl unzip libc6-dev git locales locales-all \
       cmake libfuse-dev automake autogen libtool \
       openjdk-8-jdk android-sdk
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && gem install cocoapods
ENV ANDROID_SDK_ROOT /usr/lib/android-sdk

RUN wget -nv https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip \
    && unzip commandlinetools-linux-6609375_latest.zip -d /usr/lib/android-sdk/cmdline-tools
    
RUN yes | /usr/lib/android-sdk/cmdline-tools/tools/bin/sdkmanager --licenses
RUN chown -R node:node /usr/lib/android-sdk

RUN wget -nv https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
RUN unzip ngrok-stable-linux-amd64.zip -d /usr/local/bin

RUN echo 'export PATH=/usr/lib/android-sdk/cmdline-tools/tools/bin:${PATH}' >> /home/node/.bashrc \
    && echo 'export PATH=/home/node/.yarn/bin:${PATH}' >> /home/node/.bashrc \
    && echo 'export LANG=en_US.UTF-8' >> /home/node/.bashrc

ARG app_home
ARG npm_token
ARG ngrok_token

RUN mkdir -p /home/node/.ngrok2 && \
    chown -R node:node /home/node/.ngrok2
RUN echo "authtoken: ${ngrok_token}" > /home/node/.ngrok2/ngrok.yml

RUN mkdir -p ${app_home} && \
    chown -R node:node ${app_home}
WORKDIR ${app_home}
COPY --chown=node:node ./package.json ./yarn.lock ./
RUN echo "//registry.npmjs.org/:_authToken=${npm_token}" > .npmrc

USER node

FROM base as builder
RUN yarn
COPY --chown=node:node . .
RUN yarn build

