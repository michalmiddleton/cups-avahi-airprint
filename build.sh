CR_IMAGE_NAME=$1

docker build . \
    --file Dockerfile \
    --tag ${CR_IMAGE_NAME}:latest

docker tag ${CR_IMAGE_NAME}:latest ${CR_IMAGE_NAME}:$(date +%Y%m%d)
