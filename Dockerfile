FROM golang:1.20.5-alpine as builder

ARG GCSFUSE_REPO="/run/gcsfuse/"
ARG GCSFUSE_GIT_REPO="https://github.com/GoogleCloudPlatform/gcsfuse.git"
WORKDIR ${GCSFUSE_REPO}
RUN apk add git openssl
RUN git clone ${GCSFUSE_GIT_REPO} ${GCSFUSE_REPO}
RUN go install ./tools/build_gcsfuse
RUN build_gcsfuse . /tmp $(git log -1 --format=format:"%H")

FROM nginxinc/nginx-unprivileged:stable-alpine

USER root

ENV DEFAULT_WORKDIR=/opt/gcs

ENV BUCKET_NAME=

WORKDIR ${DEFAULT_WORKDIR}

ENV GOOGLE_APPLICATION_CREDENTIALS /credentials.json

COPY --from=builder /tmp/bin/gcsfuse /usr/local/bin/gcsfuse
COPY --from=builder /tmp/sbin/mount.gcsfuse /usr/sbin/mount.gcsfuse
COPY credentials.json /credentials.json
COPY --chown=nginx:nginx default.conf /etc/nginx/conf.d/default.conf
COPY --chown=nginx:nginx docker-entrypoint.sh /docker-entrypoint.sh

RUN apk add --update --no-cache fuse \
    && chown -R nginx:nginx ${DEFAULT_WORKDIR} \
    && rm -rf /docker-entrypoint.d \
    && chmod +x /docker-entrypoint.sh \
    && rm -f /sbin/apk \
    && rm -rf /etc/apk \
    && rm -rf /lib/apk \
    && rm -rf /usr/share/apk \
    && rm -rf /var/lib/apk

USER nginx

ENTRYPOINT [ "/docker-entrypoint.sh"]