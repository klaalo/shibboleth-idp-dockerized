FROM alpine:latest as temp

ENV jetty_version=9.4.29.v20200521 \
    jetty_hash=71b572d99fe2c1342231ac3bd2e14327f523e532dd01ff203f331d52f2cf2747 \
    idp_version=4.1.0 \
    idp_hash=46fe154859f9f1557acd1ae26ee9ac82ded938af52a7dec0b18adbf5bb4510e9 \
    idp_oidcext_version=2.0.0 \
    idp_oidcext_hash=304eb4e58eadc3377fae02209f8eef6549fd17ac5fd9356ad1216869b75bb23a \
    slf4j_version=1.7.29 \
    slf4j_hash=47b624903c712f9118330ad2fb91d0780f7f666c3f22919d0fc14522c5cad9ea \
    logback_version=1.2.3 \
    logback_classic_hash=fb53f8539e7fcb8f093a56e138112056ec1dc809ebb020b59d8a36a5ebac37e0 \
    logback_core_hash=5946d837fe6f960c02a53eda7a6926ecc3c758bbdd69aa453ee429f858217f22 \
    logback_access_hash=0a4fc8753abe266ea7245e6d9653d6275dc1137cad6ecd1b2612204033d89687 \
    mariadb_version=2.5.4 \
    mariadb_hash=5fafee1aad82be39143b4bfb8915d6c2d73d860938e667db8371183ff3c8500a

ENV JETTY_HOME=/opt/jetty-home \
    JETTY_BASE=/opt/shibboleth-idp/jetty-base \
    JETTY_KEYSTORE_PASSWORD=jkstorepwd \
    IDP_HOME=/opt/shibboleth-idp \
    JAVA_HOME=/usr/lib/jvm/default-jvm \
    IDP_SRC=/opt/shibboleth-identity-provider-$idp_version \
    IDP_SCOPE=example.org \
    IDP_HOST_NAME=idp.example.org \
    IDP_ENTITYID=https://idp.example.org/idp/shibboleth \
    IDP_KEYSTORE_PASSWORD=idpkstorepwd \
    IDP_SEALER_PASSWORD=idpsealerpwd \
    PATH=$PATH:$JAVA_HOME/bin

LABEL maintainer="CSCfi"\
      idp.java.version="Alpine - openjdk11-jre-headless" \
      idp.jetty.version=$jetty_version \
      idp.version=$idp_version

RUN apk --no-cache add wget tar openjdk11-jre-headless bash gawk gnupg curl

# JETTY - Download, verify and install with base
RUN wget -q https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/$jetty_version/jetty-distribution-$jetty_version.tar.gz \
    && echo "$jetty_hash  jetty-distribution-$jetty_version.tar.gz" | sha256sum -c - \
    && tar -zxvf jetty-distribution-$jetty_version.tar.gz -C /opt \
    && ln -s /opt/jetty-distribution-$jetty_version/ /opt/jetty-home \
    && rm jetty-distribution-$jetty_version.tar.gz

# JETTY Configure
RUN mkdir -p $JETTY_BASE/modules $JETTY_BASE/lib/ext $JETTY_BASE/lib/logging $JETTY_BASE/resources \
    && cd $JETTY_BASE \
    && touch start.ini \
    && $JAVA_HOME/bin/java -jar $JETTY_HOME/start.jar --create-startd --add-to-start=http2,http2c,deploy,ext,annotations,jstl,rewrite,setuid

# Shibboleth IdP - Download, verify hash and install
RUN wget -q https://shibboleth.net/downloads/identity-provider/$idp_version/shibboleth-identity-provider-$idp_version.tar.gz \
    && echo "$idp_hash  shibboleth-identity-provider-$idp_version.tar.gz" | sha256sum -c - \
    && tar -zxvf  shibboleth-identity-provider-$idp_version.tar.gz -C /opt \
    && $IDP_SRC/bin/install.sh \
    -Didp.scope=$IDP_SCOPE \
    -Didp.target.dir=$IDP_HOME \
    -Didp.src.dir=$IDP_SRC \
    -Didp.scope=$IDP_SCOPE \
    -Didp.host.name=$IDP_HOST_NAME \
    -Didp.noprompt=true \
    -Didp.sealer.password=$IDP_SEALER_PASSWORD \
    -Didp.keystore.password=$IDP_KEYSTORE_PASSWORD \
    -Didp.entityID=$IDP_ENTITYID \
    && rm shibboleth-identity-provider-$idp_version.tar.gz \
    && rm -rf shibboleth-identity-provider-$idp_version

# slf4j - Download, verify and install
RUN wget -q https://repo1.maven.org/maven2/org/slf4j/slf4j-api/$slf4j_version/slf4j-api-$slf4j_version.jar \
    && echo "$slf4j_hash  slf4j-api-$slf4j_version.jar" | sha256sum -c - \
    && mv slf4j-api-$slf4j_version.jar $JETTY_BASE/lib/logging/

# logback_classic - Download verify and install
RUN wget -q https://repo1.maven.org/maven2/ch/qos/logback/logback-classic/$logback_version/logback-classic-$logback_version.jar \
    && echo "$logback_classic_hash  logback-classic-$logback_version.jar" | sha256sum -c - \
    && mv logback-classic-$logback_version.jar $JETTY_BASE/lib/logging/

# logback-core - Download, verify and install
RUN wget -q https://repo1.maven.org/maven2/ch/qos/logback/logback-core/$logback_version/logback-core-$logback_version.jar \
    && echo "$logback_core_hash  logback-core-$logback_version.jar" | sha256sum -c - \
    && mv logback-core-$logback_version.jar $JETTY_BASE/lib/logging/

# logback-access - Download, verify and install
RUN wget -q https://repo1.maven.org/maven2/ch/qos/logback/logback-access/$logback_version/logback-access-$logback_version.jar \
    && echo "$logback_access_hash  logback-access-$logback_version.jar" | sha256sum -c - \
    && mv logback-access-$logback_version.jar $JETTY_BASE/lib/logging/

# mariadb-java-client - Donwload, verify and install
RUN wget -q https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/$mariadb_version/mariadb-java-client-$mariadb_version.jar \
    && echo "$mariadb_hash  mariadb-java-client-$mariadb_version.jar" | sha256sum -c - \
    && mv mariadb-java-client-$mariadb_version.jar $IDP_HOME/edit-webapp/WEB-INF/lib/

# Run Jetty with suid
RUN INI=jetty.setuid.groupName;VALUE=root; sed -i 's/.*'$INI'=.*/'$INI'='$VALUE'/' $JETTY_BASE/start.d/setuid.ini

# Install plugins
# See: https://stackoverflow.com/questions/34212230/using-bouncycastle-with-gnupg-2-1s-pubring-kbx-file
RUN curl -s https://shibboleth.net/downloads/PGP_KEYS | gpg --import && \ 
    gpg --export > /root/.gnupg/pubring.gpg && \
    ${IDP_HOME}/bin/plugin.sh -i https://shibboleth.net/downloads/identity-provider/plugins/oidc-common/1.0.0/oidc-common-dist-1.0.0.tar.gz --truststore /root/.gnupg/pubring.gpg --noPrompt && \
    ${IDP_HOME}/bin/plugin.sh -i https://shibboleth.net/downloads/identity-provider/plugins/oidc-op/3.0.0/idp-plugin-oidc-op-distribution-3.0.0.tar.gz --truststore /root/.gnupg/pubring.gpg --noPrompt

COPY opt/shibboleth-idp/ /opt/shibboleth-idp/

# Create new user to run jetty with
# RUN addgroup -g 1000 -S jetty && \
RUN adduser -u 1000 -S jetty -G root -s /bin/false

# Set ownerships
RUN mkdir $JETTY_BASE/logs \
    && chown -R root:root $IDP_HOME \
    && chmod -R 550 $IDP_HOME \
    && chmod -R 775 $IDP_HOME/metadata

FROM alpine:latest

RUN apk --no-cache add openjdk11-jre-headless bash curl

LABEL maintainer="CSCfi"\
    idp.java.version="Alpine - openjdk11-jre-headless" \
    idp.jetty.version=$jetty_version \
    idp.version=$idp_version

COPY bin/ /usr/local/bin/

#RUN addgroup -g 1000 -S jetty \
#    && adduser -u 1000 -S jetty -G jetty -s /bin/false \
#    && chmod 750 /usr/local/bin/run-jetty.sh /usr/local/bin/init-idp.sh

RUN adduser -u 1000 -S jetty -G root -s /bin/false \
    && chmod 750 /usr/local/bin/run-jetty.sh /usr/local/bin/init-idp.sh

COPY --from=temp /opt/ /opt/

RUN chmod +x /opt/jetty-home/bin/jetty.sh

# Opening 8080
EXPOSE 8080 8443
ENV JETTY_HOME=/opt/jetty-home \
    JETTY_BASE=/opt/shibboleth-idp/jetty-base \
    JETTY_KEYSTORE_PASSWORD=storepwd \
    JETTY_KEYSTORE_PATH=etc/keystore \
    JAVA_HOME=/usr/lib/jvm/default-jvm \
    PATH=$PATH:$JAVA_HOME/bin

#establish a healthcheck command so that docker might know the container's true state
HEALTHCHECK --interval=1m --timeout=30s \
    CMD curl -k -f http://127.0.0.1:8080/idp/status || exit 1
  
CMD $JAVA_HOME/bin/java -jar $JETTY_HOME/start.jar \
    jetty.home=$JETTY_HOME jetty.base=$JETTY_BASE \
    -Djetty.sslContext.keyStorePassword=$JETTY_KEYSTORE_PASSWORD \
    -Djetty.sslContext.keyStorePath=$JETTY_KEYSTORE_PATH \
