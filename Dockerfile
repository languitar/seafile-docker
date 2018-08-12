FROM debian:jessie-slim

ENV LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        bash \
        curl \
        supervisor \
        nginx \
        python2.7 \
        libpython2.7 \
        python-setuptools \
        python-imaging \
        python-pillow \
        python-ldap \
        python-pylibmc \
        python-requests \
        python-urllib3 && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/*

ARG version=6.3.2
ENV SEAFILE_VERSION $version
ENV SEAFILE_PATH "/opt/seafile/$SEAFILE_VERSION"

RUN mkdir -p /seafile "${SEAFILE_PATH}" && \
    curl -o /tmp/seafile-server.tar.gz \
        "https://download.seadrive.org/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz" && \
    tar -xzf /tmp/seafile-server.tar.gz --strip-components=1 -C "${SEAFILE_PATH}" && \
    sed -ie '/^daemon/d' "${SEAFILE_PATH}/runtime/seahub.conf" && \
    sed -i "s#'NAME': '%s/seahub/seahub.db' % PROJECT_ROOT#'NAME': '/seafile/seahub.db'#" "${SEAFILE_PATH}/seahub/seahub/settings.py" && \
    rm /tmp/seafile-server.tar.gz

COPY etc/ /etc/
COPY scripts/ /scripts/

RUN \
    chmod +x /scripts/*.sh && \
    mkdir -p /run/seafile && \
    ln -s /run/seafile /opt/seafile/pids && \
    ln -s "${SEAFILE_PATH}" /opt/seafile/latest && \
    mkdir -p /seafile && \
    # seafile user
    groupadd -g 2480 seafile && \
    useradd -g seafile -u 2480 -s /bin/false seafile && \
    chown -R seafile:seafile /run/seafile

WORKDIR "/seafile"

VOLUME "/seafile"

EXPOSE 80

CMD ["/scripts/startup.sh"]
