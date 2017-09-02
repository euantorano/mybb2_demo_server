# MyBB 2.0 Demo Server

This repository contains everything required to easily set up a MyBB 2.0 demo server.

It includes a [`cloud-init`](https://cloud-init.io) config file to configure a server that should work with most VPS providers (including [DigitalOcean](https://m.do.co/c/b7464e9e7f12) (referral link)).

The `cloud-init` file and Makefile is written to work with Ubuntu 16.04 (the current LTS release) but shouldn't be too hard to adapt for other Linux based operating systems.

The `cloud-init` script checks out this repository and uses the [`Docker Compose`](https://docs.docker.com/compose/) configuration to create Docker containers to run the required MySQL database, Nginx, PHP and Composer.

## Server Details

- SSH root access is disabled
- SSH is listening on a nonstandard port (`32732`)
- SSH password access is disabled - you should edit the `cloud-init` file to include your SSH key with the `mybb` user definition
- Standard user has name `mybb`
- `mybb` user is a member of the `docker` and `wheel` groups and can use sudo without a password for ease of use
- This repository is checked out to `/home/mybb/docker` and is running by default exposing ports 80 and 443
- UFW is used to block access to all inbound ports except TCP 80, 443 and 32732
- The DigitalOcean monitoring daemon is installed and running