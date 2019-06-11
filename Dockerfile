FROM docker:stable

LABEL "com.github.actions.name"="Publish Helm Charts"
LABEL "com.github.actions.description"="Build images and publish Helm Charts"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="https://github.com/manics/chartpress"
LABEL "homepage"="https://github.com/manics/chartpress"

LABEL "maintainer"="http://github.com/manics"
LABEL "org.opencontainers.image.source"="https://github.com/manics/chartpress"

ARG KUBE_VERSION=1.14.2
ARG HELM_VERSION=2.14.1

RUN apk add --no-cache \
        curl \
        docker-py \
        git \
        python3 && \
    pip3 install ruamel.yaml && \
    curl -sL https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    curl -sL https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -zxf - linux-amd64/helm && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rmdir linux-amd64 && \
    chmod +x /usr/local/bin/kubectl /usr/local/bin/helm && \
    helm init --client-only
ADD chartpress.py /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/chartpress.py"]
