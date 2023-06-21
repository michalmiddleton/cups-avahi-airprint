CR_IMAGE_NAME=$1

docker build . \
    --file Dockerfile \
    --tag ${CR_IMAGE_NAME}:latest

CUPS_VER=$(docker run --entrypoint apk --rm ${CR_IMAGE_NAME}:latest list --installed cups 2> /dev/null | cut -d'-' -f2)
ALPINE_VER=$(grep ' alpine:' Dockerfile| cut -d':' -f2)
CR_IMAGE_TAG="${CUPS_VER}-$(date +%Y%m%d)-alpine${ALPINE_VER}"

docker tag ${CR_IMAGE_NAME}:latest ${CR_IMAGE_NAME}:${CR_IMAGE_TAG}
