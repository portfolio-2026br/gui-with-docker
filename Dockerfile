# ################################################################################
#  Copyright (c) 2026  Claudio André <portfolio-2026br at claudioandre.slmail.me>
#              ___                _      ___       _
#             (  _`\             ( )_  /'___)     (_ )  _
#             | |_) )  _    _ __ | ,_)| (__   _    | | (_)   _
#             | ,__/'/'_`\ ( '__)| |  | ,__)/'_`\  | | | | /'_`\
#             | |   ( (_) )| |   | |_ | |  ( (_) ) | | | |( (_) )
#             (_)   `\___/'(_)   `\__)(_)  `\___/'(___)(_)`\___/'
#
# This program comes with ABSOLUTELY NO WARRANTY; express or implied.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, as expressed in version 2, seen at
# https://www.gnu.org/licenses/gpl-2.0.html
# ################################################################################
# Dockerfile to run GUI applications
# More info at https://github.com/portfolio-2026br/docker-for-gui

FROM ubuntu:25.04

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Prepare the environment
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
        ca-certificates=* \
        language-pack-en=* \
        locales=* \
        software-properties-common=* \
        wget=* \
        xz-utils=*

# Install Wine
RUN dpkg --add-architecture i386 \
    && mkdir -p /etc/apt/keyrings \
    && chmod 0755 /etc/apt/keyrings \
    && wget -q -O - https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key - \
    && wget -nc -P /etc/apt/sources.list.d/ "https://dl.winehq.org/wine-builds/ubuntu/dists/$(lsb_release -sc)/winehq-$(lsb_release -sc).sources" \
    && apt-get update -y \
    && apt-get install -y --install-recommends winehq-stable=*

# Install MESA
RUN apt-get install -y --no-install-recommends libgl1-mesa-dri=*

# Clean up
RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# ==================================================================
# Setup
# ------------------------------------------------------------------
ARG GID=1000
ARG UID=1000
ARG USERNAME=portfolio
RUN groupadd -g ${GID} -o "${USERNAME}" \
    && useradd -m -u ${UID} -g ${GID} -o -s /bin/bash -l "${USERNAME}"
USER $USERNAME

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV DISPLAY=:0

HEALTHCHECK NONE
