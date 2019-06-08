FROM docker:stable

LABEL maintainer="https://github.com/manics"
LABEL org.opencontainers.image.source="https://github.com/manics/chartpress"

RUN apk add --no-cache \
        docker-py \
        git \
        python3 && \
    pip3 install ruamel.yaml
ADD chartpress.py /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/chartpress.py"]
