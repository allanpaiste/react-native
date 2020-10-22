# Experiment: React Native (Expo)

Simple React Native application for testing dockerized work environment.

Uses full-featured Expo with all it's possibilities.

## Requirements

Additional software required on the HOST machine.

### For Development

- [Docker](https://docs.docker.com/install)
- [Docker Compose](https://docs.docker.com/compose/install)
- [Homebrew](https://www.brew.sh)
- [Mutagen](https://www.mutagen.io)

### For Simulators & AdHoc Testing on Device

- Install XCode (Apple App Store)
- Install XCode CLI Tools: `xcode-select --install`
- [Android Studio](https://developer.android.com/studio)

### Required Services

Note that the things listed above are something that should/will be shared by the team and do not require each developer to sign up for the full service.

* Active Expo Account (https://expo.io/settings/access-tokens)
* Apple Developer Account

Ask for the access credentials and access tokens from your team and use them in `.env` after project has been bootstrapped.

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

```shell
npx expo start --web
```

Wait the application to be built and open [http://localhost:19006](http://localhost:19006).

### Simultaor

The following setup is needed once to get the Expo app on the booted up simulator.

```shell
dl_url=$(curl -sS https://exp.host/--/api/v2/versions/latest|python -c 'import json,sys;obj=json.load(sys.stdin);print obj["data"]["iosUrl"];')
mkdir -p tmp/Expo.app 2>/dev/null
curl -L ${dl_url} -o tmp/artifact.tar.gz
(cd tmp && tar -C Expo.app -xvzf artifact.tar.gz)
xcrun simctl install booted tmp/Expo.app
```

* Copy the `exp://...` URL to clipboard. 
* Open the Simulator.
* Open the Expo app within the simulator.
* CMD+V the URL from clipboard to the simulator.

### Device

* Make sure you have [Expo](https://apps.apple.com/us/app/expo-client/id982107779) installed on your device.

```shell
npx expo start --tunnel
```

* use the camera of your device to capture the provided QR code 
* open Expo through the presented notification that opens afterwards.

Note that if you see a warning 'Tunnel URL not found (it might not be ready yet), falling back to LAN URL', then you have to run the expo command again.

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
