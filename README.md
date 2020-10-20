# Experiment: React Native

Simple React Native application for testing dockerized work environment. The project has several branches which all have different flavour of the same project:

* expo - React Native with Full Featured Expo
* ejected - React Native with Ejected Expo

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