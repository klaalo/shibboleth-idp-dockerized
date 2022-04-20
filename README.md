[![Build Status](https://travis-ci.com/klaalo/shibboleth-idp-dockerized.svg?branch=master)](https://travis-ci.com/klaalo/shibboleth-idp-dockerized)

## Overview

This is heavy handedly slimmed down image from Shibboleth Identity Provider software previously built based on [CSC fork](https://github.com/CSCfi/shibboleth-idp-dockerized) of original [Unicon image](https://github.com/Unicon/shibboleth-idp-dockerized) that has not been updated since.

Refer to [Dockerfile](Dockerfile) for details of current version. Image is not actively maintained. If you find it lagging behind, please do your [pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests).

Currently the purpose of this repository is to provide an image in [Dockerhub](https://hub.docker.com/repository/docker/klaalo/shibboleth-idp) that is somewhat automatically updated using [Travis](https://travis-ci.org). I use it to develop Shibboleth IdP based services further.

You may find some other purpose. If you do, please [tell us](https://www.linkedin.com/company/weare-solutions-oy/mycompany/) about it in some imaginative way!

## Creating a Shibboleth IdP Configuration

The old mechanism of creating an IdP configuration has been removed from this image. Shibboleth Project doesn't yet maintain or support an official Docker Deployment method for the product, so you will need expertiese in the product to implement working installation using Docker anyhow. So basically what I'm saying is that don't rely on this image if you are not familiar with the Shibboleth product.

## Using the Image

On top of this image you will need something else, some other layer to make this runnable in your environment.

## Authors/Contributors

This project was originally developed as part of Unicon's [Open Source Support program](https://unicon.net/support), which was funded by Unicon's program subscribers.

- John Gasper (<jgasper@unicon.net>)

Unicon discontinued to maintain this image, I desided to fork this repository and modify it accordingly by our current needs and changes.

- Sami Silén (<sami.silen@csc.fi>)

I needed latest versions so another fork has emerged. I try to follow CSC guys as much as I can as they do awesome work over there. But I can't quarantine that this gets updated, so you should follow CSC's version.

- Kari Laalo (you know how to reach me)

## LICENSE

This has come quite far from original Unicon implementation, so I dared to alter this section. [See LICENSE file](LICENSE) for further details.