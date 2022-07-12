[![Build Status](https://travis-ci.com/klaalo/shibboleth-idp-dockerized.svg?branch=master)](https://travis-ci.com/klaalo/shibboleth-idp-dockerized)

## Overview

This is heavy handedly slimmed down image from Shibboleth Identity Provider software previously built based on [CSC fork](https://github.com/CSCfi/shibboleth-idp-dockerized) of original [Unicon image](https://github.com/Unicon/shibboleth-idp-dockerized) that has not been updated since.

Refer to [Dockerfile](https://github.com/klaalo/shibboleth-idp-dockerized/blob/master/latest/Dockerfile) for details of current version. We do not promise active maintenance unless otherwise specifically agree. If you find images lagging behind, please do update: 

<a href="https://github.com/klaalo/shibboleth-idp-dockerized/fork">
    <img src="https://misc.karilaalo.fi/pics/icons8-git.svg" />
</a>

Currently the purpose of this repository is to provide an image in [Dockerhub](https://hub.docker.com/r/klaalo/shibboleth-idp/tags) that is somewhat automatically updated using [Travis](https://travis-ci.org). I use it to develop Shibboleth IdP based services further.

You may find some other purpose. If you do, please [tell us](https://www.weare.fi/en/contact-us/) about it in some imaginative way!

## Supported tags

* [4.2.1](https://github.com/klaalo/shibboleth-idp-dockerized/blob/master/latest/Dockerfile)
* [4.2.1-jetty-9-jdk11](https://github.com/klaalo/shibboleth-idp-dockerized/blob/master/jetty9-jdk11/Dockerfile)

For additional older images not yet pruned, please see [Dockerhub tag listing](https://hub.docker.com/r/klaalo/shibboleth-idp/tags).

## Creating a Shibboleth IdP Configuration

The old mechanism of creating an IdP configuration has been removed from this image. Shibboleth Project doesn't yet maintain or support an official Docker Deployment method for the product, so you will need expertiese in the product to implement working installation using Docker anyhow. So basically what I'm saying is that don't rely on this image if you are not familiar with the Shibboleth product.

## Using the Image

On top of this image you will need something else, some other layer to configure it and make it runnable in your environment. If you only want to try or see it out, do:

    docker run --rm -p 8080:8080 --name shibboleth-idp -it klaalo/shibboleth-idp

Then, optionnally, access the container with:

    docker exec -it shibboleth-idp /bin/bash

## Two versions available

Build script makes two image versions available. There is currently default `Dockerfile` that uses Jetty v10 in Amazon Corretto jdk17 from [official Jetty Docker image](https://github.com/eclipse/jetty.docker/blob/c4346b6881f54541a36aeddaf77c71004cc0d32a/amazoncorretto/10.0/jdk17/Dockerfile). In addition the old image version is available that uses Jetty v9 in jdk11 also from [official Jetty Docker image](https://github.com/eclipse/jetty.docker/blob/c4346b6881f54541a36aeddaf77c71004cc0d32a/openjdk/9.4/jdk11-slim/Dockerfile).

See more info about System Requirements in [Shibboleth Wiki](https://shibboleth.atlassian.net/wiki/spaces/IDP4/pages/1265631833/SystemRequirements)

### Nashorn in new Java versions

Make note that Nashorn engine was removed starting from Java 15. As it is quite essential part in Shibboleth in many attribute-reslover implementations, it was decided to be added manually in this image. There is special task related to this in the [Dockerfile](https://github.com/klaalo/shibboleth-idp-dockerized/blob/master/latest/Dockerfile#L78). We are very interested in hearing your comments and receiving your pull requests regarding this decision. Read more in [this LinkedIn article](https://www.linkedin.com/pulse/nashorn-removed-kari-laalo/).

### TLS not included

Also, in Jetty 10 image version, TLS support was removed in Jetty. It is assumed that the container is not exposed in naked to the Internet, but instead the service is being run in load balancer offloading the TLS. To this end, `http2` module was removed in the builder script and respectively `http-forwarded` was added to facilitate necessities running behind a HTTP proxy.

If naked TLS should be necessary, one can still use the old Jetty 9 version.

## Authors/Contributors

This project was originally developed as part of Unicon's [Open Source Support program](https://unicon.net/support), which was funded by Unicon's program subscribers.

- John Gasper (<jgasper@unicon.net>)

Unicon discontinued to maintain this image. They were the first implementors on this.

- Sami Silén (<sami.silen@csc.fi>)

CSC guys have done quite a lot around this after Unicon.

- Juho Erkkilä (awesome devOps automation pipeline guru in Weare)

Juho has done lot of work in improving the [Dockerfile](https://github.com/klaalo/shibboleth-idp-dockerized/blob/master/latest/Dockerfile)

- Kari Laalo (you know how to reach me)

I just try to glue things together somehow

### Credits

* Social preview image in Github [Photo by FLY:D](https://unsplash.com/@flyd2069?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/cyber-security?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText).
* <a target="_blank" href="https://icons8.com/icon/16335/git">Git</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>  

## LICENSE

This has come quite far from original Unicon implementation, so I dared to alter this section. [See LICENSE file](https://github.com/klaalo/shibboleth-idp-dockerized/blob/master/LICENSE) for further details.