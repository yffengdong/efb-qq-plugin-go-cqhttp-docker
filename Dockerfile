#
# EH FORWARDER BOT
#

# python docker version
ARG DOCKER_IMG="python:3.9.5-alpine"


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
COPY requirement/ /tmp/efb/

# trsverse later
# pip cache at least pip 20.1
RUN apk add --no-cache --virtual .needed git \
	&&apk add --no-cache libjpeg zlib openjpeg \
	&&apk add --no-cache ffmpeg libmagic libwebp \
	&&apk add --no-cache --virtual .build tiff-dev \
	jpeg-dev \
	openjpeg-dev \
	zlib-dev \
	freetype-dev \
	lcms2-dev \
	libwebp-dev \
	tcl-dev \
	tk-dev \
	harfbuzz-dev \
	fribidi-dev \
	libimagequant-dev \
	libxcb-dev \
	libpng-dev \
	gcc \
	musl-dev \
	&&pip install -r /tmp/efb/pip_package.txt \
	&&apk del .needed .build

COPY config/ /usr/src/app/ehforwarderbot/profiles/
ENTRYPOINT ehforwarderbot -p $PROFILE
