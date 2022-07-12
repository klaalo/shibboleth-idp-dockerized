#/bin/bash

##### Build function definition
###
#

build () {
    TAG=$1
    echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
    docker build -t ${DOCKER_USERNAME}/shibboleth-idp .
    docker push ${DOCKER_USERNAME}/shibboleth-idp
    # Push tagged version
    echo "Info: ----> Pushing with version tag: ${TAG}"
    docker build -t ${DOCKER_USERNAME}/shibboleth-idp:${TAG} $2
    docker push ${DOCKER_USERNAME}/shibboleth-idp:${TAG}
}


#####
### Build latest
#
IDP_VERSION=$(sed -rn 's/.*idp_version=([0-9]\.[0-9]\.[0-9]).*/\1/p' Dockerfile)
build ${IDP_VERSION} Dockerfile

#####
### Build old Jetty v9 version
#
IDP_VERSION=$(sed -rn 's/.*idp_version=([0-9]\.[0-9]\.[0-9]).*/\1/p' Dockerfile-jetty9-jdk11)
TAG_VERSION=${IDP_VERSION}-jetty9-jdk11
build ${TAG_VERSION} Dockerfile-jetty9-jdk11