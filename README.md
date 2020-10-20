# Experiment: React Native

Simple React Native application for testing dockerized work environment.

## Requirements

Additional software required on the HOST machine.

### For Development

- [Docker](https://docs.docker.com/install)
- [Docker Compose](https://docs.docker.com/compose/install)
- [Homebrew](https://www.brew.sh)
- [Mutagen](https://www.mutagen.io)

### Required Services

Note that the things listed above are something that should/will be shared by the team and do not require each developer to sign up for the full service.

* Active Expo Account
* Apple Developer Account

Ask for the access credentials and access tokens from your team and use them in `.env` after project has been bootstrapped.

### For Simulators & AdHoc Testing on Device

- Install XCode (Apple App Store)
- Install XCode CLI Tools: `xcode-select --install`
- [Android Studio](https://developer.android.com/studio)

## Setup

```shell
make bootstrap
```

After this, make sure all the varaibles in .env that have description that states 'Required:' properly filled.

## Install

```shell
# Build the image, instantiate a container
make src

# Trigger project setup for development
make develop

# Enter the development environment
make enter

# Run command inside the development environment
docker-compose exec app <command>
```

## Develop

Notes on how to work with the app in development mode.

### Web Browser

TBD

### Simultaor

TBD 

### Device

TBD

## Build

Notes on how to create a production build for the app (and run it).

### Building for Simulator (iOS)

```shell
docker-compose exec app yarn build:ios:simulator
build_url=$(cat expo.log|grep https|tail -n1|sed 's/.*\(https:\/\/\)/\1/g')
curl -L ${build_url} -o tmp/artifact.tar.gz
(cd tmp && tar -xvzf artifact.tar.gz)
xcrun simctl install booted Experiment.app
```

### Building for Device (iOS)

```shell
docker-compose exec app yarn build:ios:simulator
build_url=$(cat expo.log|grep https|tail -n1|sed 's/.*\(https:\/\/\)/\1/g')
curl -L ${build_url} -o tmp/artifact.tar.gz
(cd tmp && tar -xvzf artifact.tar.gz)
xcrun simctl install booted Experiment.app
```
