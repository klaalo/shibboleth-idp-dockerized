[![Build Status](https://travis-ci.com/klaalo/shibboleth-idp-dockerized.svg?branch=master)](https://travis-ci.com/klaalo/shibboleth-idp-dockerized)

## Overview

This is heavy handedly slimmed down image from Shibboleth Identity Provider software previously built based on [CSC fork](https://github.com/CSCfi/shibboleth-idp-dockerized) of original [Unicon image](https://github.com/Unicon/shibboleth-idp-dockerized) that has not been updated since.

Refer to [Dockerfile](https://github.com/klaalo/shibboleth-idp-dockerized/blob/master/latest/Dockerfile) for details of current version. We do not promise active maintenance unless otherwise specifically agree. If you find images lagging behind, please do update: 

<a href="https://github.com/login?return_to=%2Fklaalo%2Fshibboleth-idp-dockerized"><svg fill="#000000" xmlns="http://www.w3.org/2000/svg"  viewBox="0 0 32 32" width="64px" height="64px"><path d="M 16 2 C 15.496094 2 15.003906 2.183594 14.625 2.5625 L 11.8125 5.40625 C 11.660156 5.488281 11.53125 5.605469 11.4375 5.75 L 2.5625 14.625 C 1.804688 15.378906 1.804688 16.617188 2.5625 17.375 L 14.625 29.4375 C 15.382813 30.191406 16.617188 30.191406 17.375 29.4375 L 29.4375 17.375 C 30.195313 16.621094 30.195313 15.382813 29.4375 14.625 L 17.375 2.5625 C 16.996094 2.183594 16.503906 2 16 2 Z M 16 4.03125 L 27.96875 16 L 16 27.96875 L 4.03125 16 L 12.3125 7.71875 L 14.0625 9.46875 C 14.015625 9.636719 14 9.816406 14 10 C 14 10.738281 14.402344 11.371094 15 11.71875 L 15 20.28125 C 14.402344 20.628906 14 21.261719 14 22 C 14 23.105469 14.894531 24 16 24 C 17.105469 24 18 23.105469 18 22 C 18 21.261719 17.597656 20.628906 17 20.28125 L 17 12.4375 L 20.0625 15.5 C 20.019531 15.660156 20 15.828125 20 16 C 20 17.105469 20.894531 18 22 18 C 23.105469 18 24 17.105469 24 16 C 24 14.894531 23.105469 14 22 14 C 21.828125 14 21.660156 14.019531 21.5 14.0625 L 17.9375 10.5 C 17.980469 10.339844 18 10.171875 18 10 C 18 8.894531 17.105469 8 16 8 C 15.816406 8 15.636719 8.015625 15.46875 8.0625 L 13.71875 6.3125 Z"/></svg></a>

Currently the purpose of this repository is to provide an image in [Dockerhub](https://hub.docker.com/r/klaalo/shibboleth-idp/tags) that is somewhat automatically updated using [Travis](https://travis-ci.org). I use it to develop Shibboleth IdP based services further.

You may find some other purpose. If you do, please [tell us](https://www.weare.fi/en/contact-us/) about it in some imaginative way!

## Creating a Shibboleth IdP Configuration

The old mechanism of creating an IdP configuration has been removed from this image. Shibboleth Project doesn't yet maintain or support an official Docker Deployment method for the product, so you will need expertiese in the product to implement working installation using Docker anyhow. So basically what I'm saying is that don't rely on this image if you are not familiar with the Shibboleth product.

## Using the Image

On top of this image you will need something else, some other layer to make this runnable in your environment.

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

Social preview image in Github [Photo by FLY:D](https://unsplash.com/@flyd2069?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/cyber-security?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText).
  

## LICENSE

This has come quite far from original Unicon implementation, so I dared to alter this section. [See LICENSE file](LICENSE) for further details.