#/bin/bash

##### Build function definition
###
#

build () {
    # Push tagged version
    TAG=$1
    echo "Info: ----> Pushing with version tag: ${TAG}"
    docker build -t ${DOCKER_USERNAME}/shibboleth-idp:${TAG} $2
    docker push ${DOCKER_USERNAME}/shibboleth-idp:${TAG}
}

build_multiarch() {
    # Push tagged version
    TAG=$1
    echo "Info: ----> Pushing multi-arch image with version tag: ${TAG}"
    docker buildx build \
    --push \
    --platform linux/arm64/v8,linux/amd64 \
    --tag ${TAG} $2
}


#####
### Build latest
#
echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
docker buildx create --use

build_multiarch ${DOCKER_USERNAME}/shibboleth-idp ./latest/

#docker build -t ${DOCKER_USERNAME}/shibboleth-idp ./latest/
#docker push ${DOCKER_USERNAME}/shibboleth-idp

#####
### Push Jetty v10 version
#
IDP_VERSION=$(sed -rn 's/.*idp_version=([0-9]\.[0-9]\.[0-9]).*/\1/p' ./latest/Dockerfile)
build ${IDP_VERSION} ./latest/

#####
### Build old Jetty v9 version
#
IDP_VERSION=$(sed -rn 's/.*idp_version=([0-9]\.[0-9]\.[0-9]).*/\1/p' ./jetty9-jdk11/Dockerfile)
TAG_VERSION=${IDP_VERSION}-jetty9-jdk11
build ${TAG_VERSION} ./jetty9-jdk11/