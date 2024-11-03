# rk-core-builder

A Docker version of both [rk3326_core_builds](https://github.com/christianhaitian/rk3326_core_builds) and [rk3566_core_builds](https://github.com/christianhaitian/rk3566_core_builds).

For building various cores and emulators.

All credit goes to [christianhaitian](https://github.com/christianhaitian).

## Prerequisites

### Install Docker Desktop

#### Mac

```zsh
brew install --cask docker || brew upgrade --cask docker
```

#### Windows

```pwsh
wsl --install; `
winget install -e --id Docker.DockerDesktop
```

## Usage

### Checkout repository and enter it

```zsh
git clone https://github.com/cscribn/rk-core-builder.git; \
cd rk-core-builder
```

### Pick the service you want to use.

Services are of the form `rk-core-builder-<chip>-<architecture>`.

Possible values for `<chip>` are `3326` and `3566` (for the rk3326 and rk3566 respectively).

Possible values for `<architecture>` are `32` and `64` (for 32-bit and 64-bit respectively).

### Build the Docker container

The following example uses 3566 for the chip and 64 for the architecture.

```zsh
docker-compose build rk-core-builder-3566-64
```

Or if updates have been made to the OS or christianhaitian's projects since your last use, you can do a fresh build.

```zsh
docker-compose build --no-cache --pull rk-core-builder-3566-64
```

### Choose a core

A list of all possible cores can be found starting [here](https://github.com/christianhaitian/rk3326_core_builds?tab=readme-ov-file#to-build-all-libretro-core-scripts-except-for-mame-and-mess-ones) for rk3326 or starting [here](https://github.com/christianhaitian/rk3566_core_builds?tab=readme-ov-file#to-build-all-libretro-core-scripts-except-for-mame-and-mess-ones) for rk3566.

### Run the Docker container

The following example uses 3566 for the chip, 64 for the architecture, and `px68k` for the `core`.

```zsh
docker-compose run --rm rk-core-builder-3566-64 px68k
```

The build output will be copied to the current directory.
