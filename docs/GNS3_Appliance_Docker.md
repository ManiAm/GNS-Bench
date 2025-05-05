
## GNS3 Docker-based Appliances

- General-Purpose Endpoints

    | Appliance name      | Vendor          | Description                                              |
    |---------------------|-----------------|----------------------------------------------------------|
    | Ubuntu Docker Guest | Canonical       | Lightweight Ubuntu container for general Linux testing.  |
    | Kali Linux CLI      | Kali Linux      | CLI-only Kali Linux for lightweight security testing.    |
    | Alpine Linux        | Alpine Linux    | Minimalist Linux image ideal for small network tests.    |
    | endhost             | endhost         | General purpose alpine-based endhost.                    |
    | ipterm              | ipterm          | Debian based networking toolbox.                         |

- Network Services

    | Appliance name | Vendor  | Description                                                        |
    |----------------|---------|--------------------------------------------------------------------|
    | AAA            | Ubuntu  | Provides RADIUS and TACACS+ services.                              |
    | DNS            | Ubuntu  | Lightweight DNS server using dnsmasq.                              |
    | haproxy        | haproxy | High-performance TCP/HTTP load balancer.                           |
    | Toolbox        | Ubuntu  | server side software (nginx, vsftpd, tftpd, rsyslog, dhcpd, snmpd) |

- Traffic Tools

    | Appliance name      | Vendor             | Description                                        |
    |---------------------|--------------------|----------------------------------------------------|
    | ntopng              | ntop               | Network traffic monitor and analysis tool.         |
    | Ostinato Wireshark  | Ostinato/Wireshark | Traffic generator bundled with Wireshark capture.  |
    | mcjoin              | Joachim Nilsson    | Tool for IPv4 and IPv6 multicast testing.          |

- Automation & DevOps

    | Appliance name         | Vendor    | Description                                                                    |
    |------------------------|-----------|--------------------------------------------------------------------------------|
    | PyATS                  | Cisco     | Cisco’s network test automation platform.                                      |
    | Network Automation     | GNS3      | GNS3 appliance for running automation scripts and tools.                       |
    | Python, Go, Perl, PHP  | GNS3 Team | Container with multiple scripting environments for dev and automation testing. |

- Python Notebook

    | Appliance name | Vendor           | Description                                       |
    |----------------|------------------|---------------------------------------------------|
    | Jupyter        | Project Jupyter  | Interactive notebook for Python and data science. |
    | Jupyter 2.7    | Project Jupyter  | Jupyter notebook using Python 2.7 environment.    |

- Web Utilities

    | Appliance name | Vendor          | Description                                                |
    |----------------|-----------------|------------------------------------------------------------|
    | Chromium       | Chromium        | Lightweight web browser in a container.                    |
    | webterm        | webterm         | Web-based terminal emulator for remote access via browser. |
    | WordPress      | Turnkey Linux   | Containerized WordPress CMS for testing or demonstration.  |
