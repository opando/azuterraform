FROM hashicorp/terraform:0.12.6

ARG CLIENT_ID
ARG CLIENT_SECRET
ARG TENANT_ID
ARG SUBSCRIPTION_ID
ARG HELM_VERSION=2.12.0
#ARG KUBECTL_VERSION=2.12.0

ENV ARM_CLIENT_ID=$CLIENT_ID
ENV ARM_CLIENT_SECRET=$CLIENT_SECRET
ENV ARM_TENANT_ID=$TENANT_ID
ENV ARM_SUBSCRIPTION_ID=$SUBSCRIPTION_ID
ENV TF_VAR_client_id=$ARM_CLIENT_ID
ENV TF_VAR_client_secret=$ARM_CLIENT_SECRET

#instalacion az-cli
RUN \
  apk update && \
  apk add bash py-pip && \
  apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python-dev make && \
  pip --no-cache-dir install -U pip && \
  pip --no-cache-dir install azure-cli && \
  apk del --purge build


#instalacion helm
ENV BASE_URL="https://get.helm.sh"
ENV TAR_FILE="helm-v${HELM_VERSION}-linux-amd64.tar.gz"

RUN apk add --update --no-cache curl ca-certificates && \
    curl -L ${BASE_URL}/${TAR_FILE} |tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-amd64 && \
    apk del curl && \
    rm -f /var/cache/apk/*


CMD ["/bin/sh"]
