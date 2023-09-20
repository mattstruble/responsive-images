#############################
### DEB PACKAGE EXTRACTOR ###
#############################
FROM debian:11-slim AS deb-extractor

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        # install only deps
        curl \
        ca-certificates \
        openssl \
        && \
    apt-get install --no-install-recommends -y -d -o=dir::cache=/tmp \
            # Image manipulation dependencies
            imagemagick \
            optipng \
            gifsicle \
            python3-pil \
            libjpeg-progs \
            webp \
            && \
    mkdir -p /dpkg/var/lib/dpkg/status.d/ && \
    cd /tmp/archives && \
    for deb in *.deb; do \
            package_name=$(dpkg-deb -I ${deb} | awk "/^ Package: .*$/ {print $2}"); \
            echo "Process: ${package_name}"; \
            dpkg --ctrl-tarfile $deb | tar -Oxvf - ./control > /dpkg/var/lib/dpkg/status.d/${package_name}; \
            dpkg --extract $deb /dpkg || exit 10; \
    done && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*


#######################
### MOZJPEG BUILDER ###
#######################
FROM debian:11-slim AS mozjpeg-builder

ARG MOZJPEG_VERSION=3.3.1

WORKDIR /tmp

RUN apt-get update && apt-get install --no-install-recommends -y \
        autoconf \
        automake \
        build-essential \
        libtool \
        nasm \
        pkgconf \
        tar \
        && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/*


ADD https://github.com/mozilla/mozjpeg/archive/v${MOZJPEG_VERSION}.tar.gz ./
RUN tar -xzf v${MOZJPEG_VERSION}.tar.gz && \
    cd /tmp/mozjpeg-${MOZJPEG_VERSION} && \
	autoreconf -fiv && \
	./configure --with-jpeg8 && \
	make && \
	make install && \
    rm -rf /tmp/*


###########################
### POETRY VENV BUILDER ###
###########################
FROM debian:11-slim AS venv-builder

ARG POETRY_VERSION=1.6.1

ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONUNBUFFERED=1 \
    PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
            python3-venv \
            python3-pip \
            gcc \
            libpython3-dev && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/cache/apt/* && \
    rm -rf /tmp/* && \
    rm -rf /var/lib/apt/lists/* && \
    python3 -m venv /venv && \
    # python3 -m pip install --upgrade pip setuptools wheel && \
    python3 -m pip install "poetry==$POETRY_VERSION"

WORKDIR /tmp

COPY pyproject.toml poetry.lock ./

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN python3 -m poetry export -f requirements.txt --with-credentials \
    | /venv/bin/pip install -r /dev/stdin && \
    rm -rf /tmp/*


#############################
### DISTROLESS PY RUNTIME ###
#############################
# hadolint ignore=DL3006
FROM gcr.io/distroless/python3-debian11 as runtime
# A distroless container image with Python and some basics like SSL certificates
# https://github.com/GoogleContainerTools/distroless

COPY --from=venv-builder /venv /venv
COPY --from=mozjpeg-builder /opt/mozjpeg /opt/mozjpeg
COPY --from=deb-extractor /dpkg /

ENV PATH="/venv/bin:$PATH" \
    VIRTUAL_ENV="/venv" \
    PYTHONPATH="/venv:/app:$PYTHONPATH"

COPY ./app /app

ENTRYPOINT ["/venv/bin/python3"]
CMD ["/app/main.py"]

##################
### TEST IMAGE ###
##################
FROM runtime as test

COPY --from=busybox:1.36.1-uclibc /bin/sh /bin/sh

COPY ./tests/files/images ./test

WORKDIR /test

ENTRYPOINT ["/bin/sh"]
