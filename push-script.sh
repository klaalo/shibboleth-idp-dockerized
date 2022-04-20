#/bin/bash
IDP_VERSION=$(sed -rn 's/.*idp_version=([0-9]\.[0-9]\.[0-9]).*/\1/p' Dockerfile)
echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
#docker build -t ${DOCKER_USERNAME}/shibboleth-idp .
#docker push ${DOCKER_USERNAME}/shibboleth-idp
# Push tagged version
echo "Info: Pushing with version tag: ${IDP_VERSION}-test"
docker build -t ${DOCKER_USERNAME}/shibboleth-idp:${IDP_VERSION}-test .
docker push ${DOCKER_USERNAME}/shibboleth-idp:${IDP_VERSION}-test
