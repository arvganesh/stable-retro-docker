# stable-retro-docker

Dockerfile for an Ubuntu 22.04 image with [stable-retro](https://github.com/MatPoliquin/stable-retro), a fork of OpenAI retro. I had a lot of problems getting this to work on my M1 Macbook Pro (running OS X 12.5), so hopefully this repo is useful.

## Usage

### Building
`docker build -t Your-Image-Name -f Dockerfile .`

### Running
```
docker run --detach \
           --env DISPLAY=host.docker.internal:0 \
           --interactive \
           --rm \
           --volume $(pwd):/code \
           --platform linux/amd64 \
           --name Your-Container-Name \
           Your-Image-Name
```

#### Notes:

I had to add the argument `--platform linux/amd64` so the container would work on M1. See [this](https://stackoverflow.com/questions/65612411/forcing-docker-to-use-linux-amd64-platform-by-default-on-macos) for more details.

I also had to add the argument `--env DISPLAY=host.docker.internal:0` to get display support on macOS (see the display support section).

For this argument: `--volume $(pwd):/code`, `/code` is specified in the Dockerfile as the `WORKDIR`. This argument will mount the current working directory to `/code` in the Docker container. Change `$(pwd)` to another path to modify this behavior.

### Execution
`docker exec -it Your-Container-Name bash`

## Display Support (from within the container) on macOS

To get GUIs from containerized applications to display on your Mac, follow the steps in this guide: https://gist.github.com/paul-krohn/e45f96181b1cf5e536325d1bdee6c949. 

In summary, you need to install [XQuartz](https://github.com/XQuartz/) and configure a few things.

Since [gymnasium](https://gymnasium.farama.org/) needs to use (indirect) GLX from within the container to display GUIs, I had to run this command on my Mac terminal `defaults write org.xquartz.X11 enable_iglx -bool true` to get things to finally work. If the steps don't work, restart XQuartz and / or your Mac before trying again.
