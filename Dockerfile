FROM debian:11-slim AS deb_extractor

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        # install only deps
        curl \
        ca-certificates \
        openssl \
        && \
    apt-get install -y -d -o=dir::cache=/tmp \
            # Image manipulation dependencies
            imagemagick \
            optipng \
            gifsicle \
            python3-pil \
            webp \
            && \
    mkdir -p /dpkg/var/lib/dpkg/status.d/ && \
    cd /tmp/archives && \
    for deb in *.deb; do \
            package_name=$(dpkg-deb -I ${deb} | awk '/^ Package: .*$/ {print $2}'); \
            echo "Process: ${package_name}"; \
            dpkg --ctrl-tarfile $deb | tar -Oxvf - ./control > /dpkg/var/lib/dpkg/status.d/${package_name}; \
            dpkg --extract $deb /dpkg || exit 10; \
    done


FROM debian:11-slim AS builder

ARG MOZJPEG_VERSION=3.3.1


WORKDIR /tmp

RUN apt-get update && apt-get install -y \
	autoconf \
	automake \
	build-essential \
	libtool \
	nasm \
	pkgconf \
	tar

ADD https://github.com/mozilla/mozjpeg/archive/v${MOZJPEG_VERSION}.tar.gz ./
RUN tar -xzf v${MOZJPEG_VERSION}.tar.gz && \
    cd /tmp/mozjpeg-${MOZJPEG_VERSION} && \
	autoreconf -fiv && \
	./configure --with-jpeg8 && \
	make && \
	make install


FROM debian:11-slim AS venv-builder

ARG POETRY_VERSION=1.6.1

ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONUNBUFFERED=1 \
    PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
                        python3-venv \
                        gcc \
                        libpython3-dev && \
    apt-get clean && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/cache/apt/* && \
    rm -rf /tmp/* && \
    rm -rf /var/lib/apt/lists/* && \
    python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip setuptools wheel && \
    /venv/bin/pip install "poetry==$POETRY_VERSION"


COPY pyproject.toml poetry.lock ./

RUN /venv/bin/poetry config virtualenvs.create false && \
    /venv/bin/poetry config virtualenvs.path /venv && \
    /venv/bin/poetry install --no-root --no-dev && \
    rm -rf /root/.cache/pypoetry /root/.cache/pip
#RUN poetry
#    rm -rf /root/.cache/pypoetry /root/.cache/pip

# A distroless container image with Python and some basics like SSL certificates
# https://github.com/GoogleContainerTools/distroless
FROM gcr.io/distroless/python3-debian11
#ENV VIRTUAL_ENV="/venv"

COPY --from=venv-builder /venv /venv
COPY --from=builder /opt/mozjpeg /opt/mozjpeg
COPY --from=deb_extractor /dpkg /
# Configure dot plugins
#RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"
WORKDIR /app
COPY ./app /app
#:ENV PYTHONPATH="/venv"
ENTRYPOINT ["/venv/bin/python3"]
CMD ["/app/main.py"]
