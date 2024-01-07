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
RUN apt-get --yes --auto-remove --show-upgraded \
    --allow-downgrades --allow-change-held-packages \
    --no-install-recommends \
    --option DPkg::Options::="--force-confdef" \
    --option DPkg::Options::="--force-confold" \
    install openmediavault

RUN omv-confdbadm populate

RUN omv-salt deploy run systemd-networkd

# We need to make sure rrdcached uses /data for it's data
# COPY defaults/rrdcached /etc/default

# Add our startup script last because we don't want changes
# to it to require a full container rebuild
# COPY omv-startup /usr/sbin/omv-startup
# RUN chmod +x /usr/sbin/omv-startup

# EXPOSE 80 443

# VOLUME /data

# ENTRYPOINT /usr/sbin/omv-startup
