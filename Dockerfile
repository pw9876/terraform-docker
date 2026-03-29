ARG TERRAFORM_VERSION=1.14.8
ARG ALPINE_VERSION=3.21

FROM alpine:${ALPINE_VERSION} AS base

ARG TERRAFORM_VERSION
ARG TARGETARCH

RUN apk add --no-cache \
    curl \
    unzip \
    git \
    openssh-client \
    bash \
    ca-certificates \
    && update-ca-certificates

RUN ARCH=$([ "${TARGETARCH}" = "arm64" ] && echo "arm64" || echo "amd64") \
    && curl -fsSL --proto '=https' --tlsv1.2 "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip" \
       -o /tmp/terraform.zip \
    && unzip /tmp/terraform.zip -d /usr/local/bin/ \
    && rm /tmp/terraform.zip \
    && terraform version \
    && adduser -D terraform

WORKDIR /workspace

USER terraform

ENTRYPOINT ["terraform"]
CMD ["--help"]
