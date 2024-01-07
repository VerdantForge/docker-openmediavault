FROM debian:bullseye

MAINTAINER Ilya Kogan <ikogan@flarecode.com>


# Fix resolvconf issues with Docker
# RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections

# Install OpenMediaVault packages and dependencies
RUN apt-get update -y
RUN apt-get install --yes gnupg wget
RUN wget --quiet --output-document=- https://packages.openmediavault.org/public/archive.key \
    | gpg --dearmor --yes --output "/usr/share/keyrings/openmediavault-archive-keyring.gpg"

# Add the OpenMediaVault repository
COPY openmediavault.list /etc/apt/sources.list.d/openmediavault.list

ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV APT_LISTCHANGES_FRONTEND=none
RUN apt-get update -y