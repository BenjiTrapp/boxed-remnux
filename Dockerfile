FROM remnux/remnux-distro:noble

LABEL org.opencontainers.image.title="Boxed REMnux"
LABEL org.opencontainers.image.description="REMnux malware analysis toolkit with browser-based desktop access via noVNC"
LABEL org.opencontainers.image.source="https://github.com/REMnux/docker"

ENV VNCEXPOSE=1
ENV VNCPORT=5900
ENV VNCPWD=remnux
ENV VNCDISPLAY=1920x1080
ENV VNCDEPTH=16
ENV NOVNCPORT=8080
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        xfce4 \
        xfce4-terminal \
        tigervnc-standalone-server \
        tigervnc-tools \
        novnc \
        dbus \
        dbus-x11 \
        xfonts-base \
        xauth \
        policykit-1 \
        sudo \
        net-tools \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY containerfiles/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080
EXPOSE 5900

ENTRYPOINT ["/entrypoint.sh"]
