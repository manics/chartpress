FROM docker:stable

LABEL "com.github.actions.name"="Publish Helm Charts"
LABEL "com.github.actions.description"="Build images and publish Helm Charts"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="https://github.com/manics/chartpress"
LABEL "homepage"="https://github.com/manics/chartpress"

LABEL "maintainer"="http://github.com/manics"
LABEL "org.opencontainers.image.source"="https://github.com/manics/chartpress"

RUN apk add --no-cache \
        docker-py \
        git \
        python3 && \
    pip3 install ruamel.yaml
ADD chartpress.py /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/chartpress.py"]
