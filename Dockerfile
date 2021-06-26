#
# EH FORWARDER BOT
#

# python docker version
ARG DOCKER_IMG="python:3.9.5-slim-buster"

# Product
FROM ${DOCKER_IMG} as product

## environment variables
### do not creat python bytecode
ENV PYTHONDONTWRITEBYTECODE="1"
### do not buffer python stdout
ENV PYTHONUNBUFFERED="1"
### do not save pip cache
### at least pip 19.0
ENV PIP_NO_CACHE_DIR="1"
ENV EFB_DATA_PATH="/usr/src/app/ehforwarderbot"
ENV PROFILE="default"

WORKDIR /usr/src/app

CCOPY requirement/ /tmp/efb/
# trsverse later
# pip cache at least pip 20.1
RUN apt-get update \
	&&apt-get install -y --no-install-recommends git \
	&&apt-get install -y --no-install-recommends ffmpeg libmagic1 libwebp6 libwebpdemux2 libwebpmux3 \
	&&pip install -r /tmp/efb/efb_package.txt \
	&&apt-get purge -y git \
	&&apt-get autoremove -y \
	&&apt-get clean -y \
	&&rm -rf /var/lib/apt/lists/*

COPY config/ /usr/src/app/ehforwarderbot/profiles/
ENTRYPOINT ehforwarderbot -p $PROFILE
