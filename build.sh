CUPS_VER=$(apk list cups | cut -d'-' -f2)
ALPINE_VER=$(grep ' alpine:' Dockerfile| cut -d':' -f2)
CR_IMAGE_NAME=$1
CR_IMAGE_TAG="${CUPS_VER}-$(date +%Y%m%d)-alpine${ALPINE_VER}"

docker build . \
    --file Dockerfile \
    --tag ${CR_IMAGE_NAME}:${CR_IMAGE_TAG} \
    --tag ${CR_IMAGE_NAME}:latest
