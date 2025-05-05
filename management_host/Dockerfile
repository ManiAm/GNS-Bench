
FROM ubuntu:focal

RUN DEBIAN_FRONTEND=noninteractive ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        wget \
        telnet \
        iputils-ping \
        net-tools \
        dnsutils \
        traceroute \
        ethtool \
        htop \
        nano \
        vim-tiny \
        psmisc \
        watch \
        lsof \
        file \
        iptables \
        openssh-client \
        openssh-server \
        nginx \
        vsftpd \
        isc-dhcp-server \
        tftpd-hpa \
        snmpd \
        snmptrapd \
        rsyslog && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY config/default_snmptrapd /etc/default/snmptrapd
COPY config/default_tftpd-hpa /etc/default/tftpd-hpa
COPY config/pam_d-vsftpd /etc/pam.d/vsftpd
COPY config/rsyslog.conf /etc/rsyslog.conf
COPY config/snmpd.conf /etc/snmp/snmpd.conf
COPY config/snmptrapd.conf /etc/snmp/snmptrapd.conf
COPY config/vsftpd.conf /etc/vsftpd.conf

COPY starter.sh /sbin/starter.sh
COPY index.html /var/www/html/index.html
COPY gns3.png /var/www/html/gns3.png

RUN DEBIAN_FRONTEND=noninteractive \
    chmod 755 /sbin/starter.sh && \
    mkdir -p /tftpboot && \
    chmod 777 /tftpboot && \
    echo "root:gns3" | chpasswd && \
    chmod 644 /var/www/html/*

VOLUME [ "/root", "/tftpboot", "/var/log", "/var/www", "/etc" ]

CMD ["/sbin/starter.sh"]
