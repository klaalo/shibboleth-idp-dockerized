#/bin/bash
IDP_VERSION=$(sed -rn 's/.*idp_version=([0-9]\.[0-9]\.[0-9]).*/\1/p' Dockerfile)
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker build -t klaalo/shibboleth-idp .
docker push klaalo/shibboleth-idp
# Push tagged version
echo "Info: Pushing with version tag: ${IDP_VERSION}"
docker build -t klaalo/shibboleth-idp:${IDP_VERSION} .
docker push klaalo/shibboleth-idp:${IDP_VERSION}
