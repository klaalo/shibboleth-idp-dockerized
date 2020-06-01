#!/bin/bash

# export JAVA_HOME=/usr/lib/jvm/default-jvm \
# export PATH=$PATH:$JAVA_HOME/bin \
# export IDP_HOME=/opt/shibboleth-idp

# cd $IDP_HOME/bin

# echo "Please complete the following for your IdP environment:"
# ./ant.sh -Didp.target.dir=/opt/shibboleth-idp-tmp -Didp.src.dir=/opt/shibboleth-idp/ install

# find /opt/shibboleth-idp-tmp/ -type d -exec chmod 750 {} \;

mkdir -p /ext-mount/customized-shibboleth-idp/conf/{c14n,authn}
chmod -R 755 /ext-mount/customized-shibboleth-idp/

# Copy the essential and routinely customized config to out Docker mount.
cd /opt/shibboleth-idp
cp -r credentials/ /ext-mount/customized-shibboleth-idp/
cp -r metadata/ /ext-mount/customized-shibboleth-idp/
cp conf/{attribute-resolver*.xml,attribute-filter.xml,cas-protocol.xml,idp.properties,ldap.properties,metadata-providers.xml,relying-party.xml,global.xml,services.xml,credentials.xml,saml-nameid.*} /ext-mount/customized-shibboleth-idp/conf/
cp conf/authn/{general-authn.xml,saml-authn-config.xml} /ext-mount/customized-shibboleth-idp/conf/authn/
cp conf/c14n/{attribute-sourced-subject-c14n-config.xml,subject-c14n.xml} /ext-mount/customized-shibboleth-idp/conf/c14n/

# Copy the basic UI components, which are routinely customized
cp -r views/ /ext-mount/customized-shibboleth-idp/
mkdir /ext-mount/customized-shibboleth-idp/webapp/
cp -r edit-webapp/css/ /ext-mount/customized-shibboleth-idp/webapp/
cp -r edit-webapp/images/ /ext-mount/customized-shibboleth-idp/webapp/
rm -r /ext-mount/customized-shibboleth-idp/views/user-prefs.js

# Copy Jetty configuration files
mkdir -p /ext-mount/customized-shibboleth-idp/jetty-base/{etc,webapps,start.d}
cp jetty-base/etc/tweak-ssl.xml /ext-mount/customized-shibboleth-idp/jetty-base/etc/tweak-ssl.xml
cp jetty-base/webapps/idp.xml /ext-mount/customized-shibboleth-idp/jetty-base/webapps/idp.xml
cp jetty-base/start.d/ssl.ini /ext-mount/customized-shibboleth-idp/jetty-base/start.d/ssl.ini

chmod -R 755 /ext-mount/customized-shibboleth-idp/

echo "A basic Shibboleth IdP config and UI has been copied to ./customized-shibboleth-idp/ (assuming the default volume mapping was used)."
echo "Most files, if not being customized can be removed from what was exported/the local Docker image and baseline files will be used."
