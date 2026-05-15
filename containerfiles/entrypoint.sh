#!/bin/bash

set_vnc_password() {
    mkdir -p /root/.vnc
    echo "$VNCPWD" | vncpasswd -f > /root/.vnc/passwd
    chmod 600 /root/.vnc/passwd

    if id "remnux" &>/dev/null; then
        mkdir -p /home/remnux/.vnc
        echo "$VNCPWD" | vncpasswd -f > /home/remnux/.vnc/passwd
        chmod 600 /home/remnux/.vnc/passwd
        chown -R remnux:remnux /home/remnux/.vnc
    fi
}

create_xstartup() {
    cat > /root/.vnc/xstartup << 'EOF'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
startxfce4
EOF
    chmod +x /root/.vnc/xstartup

    if id "remnux" &>/dev/null; then
        cp /root/.vnc/xstartup /home/remnux/.vnc/xstartup
        chown -R remnux:remnux /home/remnux/.vnc
    fi
}

start_vnc() {
    service dbus start > /dev/null 2>&1 || true

    if [ "$VNCEXPOSE" = "1" ]; then
        vncserver :0 -rfbport ${VNCPORT} -geometry ${VNCDISPLAY} -depth ${VNCDEPTH} \
            > /var/log/vncserver.log 2>&1
    else
        vncserver :0 -rfbport ${VNCPORT} -geometry ${VNCDISPLAY} -depth ${VNCDEPTH} -localhost \
            > /var/log/vncserver.log 2>&1
    fi

    /usr/share/novnc/utils/novnc_proxy --listen ${NOVNCPORT} --vnc localhost:${VNCPORT} \
        > /var/log/novnc.log 2>&1 &

    echo "-------------------------------------------------------"
    echo "  Boxed REMnux ready!"
    echo "  Open http://localhost:${NOVNCPORT}/vnc.html in your browser"
    echo "  VNC password: ${VNCPWD}"
    echo "-------------------------------------------------------"
}

main() {
    set_vnc_password
    create_xstartup
    start_vnc

    tail -f /dev/null
}

main
