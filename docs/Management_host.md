
# Management Host

## Configuring DHCP Server

In our topology, the management-host is configured to serve as a dedicated DHCP server. It manages two network interfaces:

- `eth0`: Used for upstream connectivity, obtains its IP via DHCP from the host
- `eth1`: Used as a downstream interface to provide IP addresses to clients via DHCP, using subnet 10.10.10.0/24

The file "/etc/network/interfaces" inside the container defines how interfaces are brought up:

    # eth0 gets IP via DHCP
    auto eth0
    iface eth0 inet dhcp

    # eth1 has static IP
    auto eth1
    iface eth1 inet static
        address 10.10.10.1
        netmask 255.255.255.0

The "ISC DHCP server" is installed and configured to serve clients on the 10.10.10.0/24 subnet.

The content of file "/etc/dhcp/dhcpd.conf" is:

    default-lease-time 600;
    max-lease-time 7200;
    authoritative;

    subnet 10.10.10.0 netmask 255.255.255.0 {
        range 10.10.10.100 10.10.10.200;
        option routers 10.10.10.1;
        option subnet-mask 255.255.255.0;
        option domain-name-servers 8.8.8.8;
    }

Update "/etc/default/isc-dhcp-server" to instruct the ISC DHCP service to bind only to eth1 for IPv4 DHCP requests, and ignore IPv6.

    INTERFACESv4="eth1"
    INTERFACESv6=""

Restart the docker container for the changes to take effect. Verify interface configurations:

    ifconfig

    eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 192.168.122.213  netmask 255.255.255.0  broadcast 192.168.122.255
            ether 02:42:ab:be:02:00  txqueuelen 1000  (Ethernet)
            RX packets 21  bytes 1922 (1.9 KB)
            RX errors 0  dropped 1  overruns 0  frame 0
            TX packets 6  bytes 1248 (1.2 KB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 10.10.10.1  netmask 255.255.255.0  broadcast 0.0.0.0
            inet6 fe80::42:abff:febe:201  prefixlen 64  scopeid 0x20<link>
            ether 02:42:ab:be:02:01  txqueuelen 1000  (Ethernet)
            RX packets 0  bytes 0 (0.0 B)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 8  bytes 656 (656.0 B)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

The service is started using:

    /etc/init.d/isc-dhcp-server start

Check the logs to ensure the server is running and listening:

    tail -n 50 /var/log/syslog | grep dhcp

Access the console of the "Cisco 8102" router. Enter global configuration mode and configure the management interface (MgmtEth0/RP0/CPU0/0) to obtain an IP address via DHCP:

    conf t
    interface mgmtEth 0/RP0/CPU0/0
    no shut
    ipv4 address dhcp
    commit
    end

Verify that the management interface has obtained an IP address:

    show ip interface brief MgmtEth 0/RP0/CPU0/0

    Interface                      IP-Address      Status                Protocol
    MgmtEth0/RP0/CPU0/0            10.10.10.100    Up                    Up

The management interface (eth0) in SONiC is already configured to use DHCP. To verify the assigned IP address:

    admin@sonic:~$ ip add show eth0

    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
        link/ether 0c:93:0d:27:00:00 brd ff:ff:ff:ff:ff:ff
        inet 10.10.10.102/24 brd 10.10.10.255 scope global dynamic eth0
        valid_lft 569sec preferred_lft 569sec
        inet6 fe80::e93:dff:fe27:0/64 scope link
        valid_lft forever preferred_lft forever

## Configuring IP Forwarding and NAT

Check that the management host has a valid route to both internal and external networks:

    ip route

    default via 192.168.122.1 dev eth0 metric 231
    10.10.10.0/24 dev eth1 proto kernel scope link src 10.10.10.1
    192.168.122.0/24 dev eth0 proto kernel scope link src 192.168.122.50

Open the system configuration file:

    nano /etc/sysctl.conf

Uncomment or add the following line:

    net.ipv4.ip_forward=1

Apply the changes immediately:

    sysctl -p

Add a NAT rule to masquerade outbound traffic on eth0:

    iptables -t nat -A POSTROUTING -o eth0 -s 10.10.10.0/24 -j MASQUERADE

This allows return traffic from the internet to be routed back correctly to hosts on the 10.10.10.0/24 subnet.

From the SONiC host, confirm external connectivity by pinging a public IP address:

    admin@sonic:~$ ping 8.8.8.8

    PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
    64 bytes from 8.8.8.8: icmp_seq=1 ttl=114 time=19.9 ms
    64 bytes from 8.8.8.8: icmp_seq=2 ttl=114 time=21.3 ms
    64 bytes from 8.8.8.8: icmp_seq=3 ttl=114 time=22.8 ms

## Persistent Startup Configuration

To ensure that specific commands are executed automatically each time the Docker container starts, you can use a persistent shell script.

Open the `onboot.sh` script for editing:

    nano /etc/onboot.sh

Append the following lines to the file:

    /etc/init.d/isc-dhcp-server start
    iptables -t nat -A POSTROUTING -o eth0 -s 10.10.10.0/24 -j MASQUERADE
