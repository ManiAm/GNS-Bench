# GNS3

## Introduction

GNS3 (Graphical Network Simulator 3) is a network simulation and emulation platform that enables users to design, test, and troubleshoot complex network topologies virtually. It is widely adopted by network engineers, IT professionals, and students for building lab environments without the need for physical hardware. GNS3 supports integration with multiple emulation engines, enabling realistic behavior for a wide range of network devices. Official GNS3 repositories are available [here](https://github.com/orgs/GNS3/repositories?type=all).

## GNS3 Architecture Overview

The diagram below illustrates the high-level architecture of GNS3:

```text
+---------------+                  +----------+     +------+
|               |                  | COMPUTE  +-----> QEMU |
|  GNS3 GUI     |              +---> SERVER 1 |     +------+
|  QT interface +-----+        |   +----------+
|               |     |        |                      +----+
+---------------+    +v--------++                +---> IOU |
                     |CONTROLLER|                |    +----+
    +----------+     +^--------++  +----------+  |
    | GNS3 WEB +-----+        |    | COMPUTE  +--+
    +----------+              +----> SERVER 2 +--+
                                   +----------+  |
                                                 |   +----------+
                                                 +---> DYNAMIPS |
                                                     +----------+
```

### User Interface (UI)

- **Desktop GUI** ([gns3-gui](https://github.com/GNS3/gns3-gui))

    A Qt-based graphical application used for creating and managing network topologies. Users can drag and drop devices, establish links, configure nodes, and access device consoles through this interface.

- **Web UI** ([gns3-web-ui](https://github.com/GNS3/gns3-web-ui))

    A modern, browser-based interface that provides similar functionality to the desktop GUI. The web UI is ideal for remote access and collaborative environments, removing the need for local installations.

### Controller

The controller acts as the central coordinator for all GNS3 operations. It handles API requests from the GUI and web interface, translating these into actions that affect the network simulation. It manages project lifecycle (creation, modification, deletion), and synchronizes state across components. It ensures consistency between the user interface and compute servers. Controller implementation is available in the [gns3-server](https://github.com/GNS3/gns3-server) repository.

### Compute Servers

Compute servers, also part of the [gns3-server](https://github.com/GNS3/gns3-server) project, are responsible for executing the virtual devices. These servers host emulator instances such as QEMU, Dynamips, or IOU, and can be deployed on the same host as the controller or across distributed machines. This modular design enables scaling, resource separation, and hardware-specific deployments. Each device in a topology is instantiated by the appropriate compute node.

### Emulators

GNS3 integrates with several emulators to simulate various networking environments:

- **Dynamips**

    Dynamips is a legacy emulator that simulates Cisco IOS for older routers, such as the 7200 series. It emulates real Cisco hardware and runs genuine IOS images extracted from physical devices. It was one of the earliest emulators used in GNS3 and provided a foundation for network simulation when access to real hardware was limited. While it was widely used for CCNA/CCNP-level labs, it only supports outdated IOS versions and has limited scalability, performance, and feature support compared to modern alternatives. Dynamips remains useful for basic routing practice and foundational networking concepts but is no longer recommended for production-like labs.

    | Device              | Type   | Emulator  | Vendor |
    |---------------------|--------|-----------|--------|
    | Cisco 1700          | Router | Dynamips  | Cisco  |
    | Cisco 2600          | Router | Dynamips  | Cisco  |
    | Cisco 2691          | Router | Dynamips  | Cisco  |
    | Cisco 3620          | Router | Dynamips  | Cisco  |
    | Cisco 3640          | Router | Dynamips  | Cisco  |
    | Cisco 3660          | Router | Dynamips  | Cisco  |
    | Cisco 3725          | Router | Dynamips  | Cisco  |
    | Cisco 3745          | Router | Dynamips  | Cisco  |
    | Cisco 7200          | Router | Dynamips  | Cisco  |
    | Cisco 7200 (custom) | Router | Dynamips  | Cisco  |

- **IOU (IOS-on-Unix)**

    IOU (IOS-on-Unix) is a lightweight emulator developed by Cisco that runs IOS natively on Unix/Linux platforms without the need for hardware-level emulation. It supports both Layer 2 and Layer 3 IOS images and is more resource-efficient than Dynamips. Although highly effective for switch labs and CCIE practice, IOU is an internal Cisco tool and not officially released for public use, making its distribution and usage a legal gray area. It’s popular in private labs where high-density Cisco topologies are needed with minimal system overhead.

    | Device         | Type   | Emulator  | Vendor |
    |----------------|--------|-----------|--------|
    | Cisco IOU L3   | Router | IOU       | Cisco  |
    | Cisco IOU L2   | Switch | IOU       | Cisco  |

    The `Cisco IOU L3` emulates Layer 3 routing functionality in an efficient, lightweight environment. It supports a broad range of Cisco IOS routing features such as OSPF, EIGRP, BGP, and policy-based routing. The `Cisco IOU L2` offers full Layer 2 switching capabilities, including VLANs, trunking, STP, EtherChannel, and basic L3 awareness. It is especially useful for simulating enterprise switching environments and studying complex spanning-tree or VLAN topologies.

- **VirtualBox**

    VirtualBox is a general-purpose virtualization platform that was commonly used in early versions of GNS3 for running full operating systems like Linux and Windows. While it provided a simple way to integrate end-user systems or tools into network topologies, it has largely been deprecated in favor of QEMU due to limitations in performance, networking flexibility, and integration with GNS3's modern architecture. VirtualBox is still usable but no longer actively recommended within the GNS3 ecosystem.

- **QEMU**

    QEMU is a powerful, open-source hardware virtualization and emulation platform used by GNS3 to run modern network operating systems and appliances. It supports a wide range of platforms (x86, ARM, etc.) and, when paired with KVM, offers near-native performance. QEMU is the recommended backend in GNS3 for deploying devices such as Cisco vIOS, CSR1000v, Juniper vMX, Arista vEOS, Palo Alto firewalls, and general-purpose Linux or Windows VMs. Its flexibility, snapshot support, and compatibility with nested virtualization make it ideal for advanced and scalable network lab environments.

- **Docker**

    Docker provides container-based virtualization and is integrated into GNS3 to allow the deployment of lightweight services such as DNS, DHCP, web servers, penetration testing tools, and other Linux-based utilities. Unlike full VMs, Docker containers start quickly, use fewer resources, and can be easily versioned and maintained. GNS3 allows users to run Docker containers as network nodes, enabling dynamic and modular lab environments. Docker is especially useful for microservice simulations, service chaining, and adding real-world utility servers into a topology.

- **VPCS (Virtual PC Simulator)**

    VPCS is a lightweight tool that simulates simple virtual PCs capable of basic IP connectivity tasks such as ping, traceroute, and testing default gateways. It consumes very little system resources and is extremely useful in GNS3 topologies where full-featured virtual machines are unnecessary. While VPCS cannot run applications or services, it's ideal for testing connectivity, routing configurations, and simulating multiple end hosts in large labs without a performance hit.

## GNS3 Workflow

Here’s how GNS3 components interact:

- A user adds a device to the canvas using the GUI or web interface.
- The request is sent to the controller via REST API.
- The controller determines the appropriate compute server and instructs it to launch the specified device using the relevant emulator.
- The compute server runs the emulator instance and manages its lifecycle.
- Device console access and network connectivity are handled transparently to reflect the topology as designed.

This architecture enables simulation of both simple and complex networks, supports distributed computing environments, and scales efficiently for multi-user deployments. It’s well-suited for labs, certification training (e.g., CCNA, CCNP), testing configurations, and validating network designs. You can get more information on GNS3 design from:

- [GNS3 Architecture](https://www.youtube.com/watch?v=N7xlwUhvX7o)
- [GNS3 API](https://www.youtube.com/watch?v=tKIu42nOtPw)
- [GNS3 Emulators - Part 1](https://www.youtube.com/watch?v=SWCZWqCNB5k)
- [GNS3 Emulators - Part 2](https://www.youtube.com/watch?v=CtuhArLfStc)

## GNS3 Virtual Machine

The GNS3 Virtual Machine (GNS3 VM) is a pre-packaged virtual appliance. It is a compute server with built-in emulators (QEMU, Dynamips, IOU) running on a Linux virtual machine. The controller typically runs on your host machine (e.g., Windows or macOS) and connects to the GNS3 VM over TCP. GNS3 VM is designed to offload the heavy lifting of emulation from your host machine to a dedicated VM environment. This is especially useful when running resource-intensive devices like Cisco vIOS, NX-OS, or images that require KVM acceleration (which is better supported in Linux than Windows/macOS).

The [gns3-vm](https://github.com/GNS3/gns3-vm) repository contains the source files and configuration used to build and maintain the official GNS3 VM image. While the repository enables advanced users to customize or rebuild the VM from source, most users do not build the VM themselves. Instead, GNS3 provides a pre-built and fully configured VM image that can be downloaded directly. These official builds are made available as release assets, and are intended to be imported into virtualization platforms like:

- VMware Workstation/Player
- Oracle VirtualBox
- Microsoft Hyper-V
- KVM/QEMU
- VMware ESXi

## ubridge

GNS3 uses various backends (QEMU, Docker, Dynamips, etc.), each managing its own network stack. These emulators don't natively talk to each other at Layer 2. [ubridge](https://github.com/GNS3/ubridge) is a lightweight user-land bridging utility developed by the GNS3 team. It acts as a virtual Layer 2 switch, allowing GNS3 to interconnect emulated nodes and also bridge them with the host network interfaces. It also allows packet capture using tools like Wireshark on inter-device links.

Without ubridge, devices in your topology would only be able to communicate within their emulator's domain. ubridge is installed and executed on compute servers. When you start a topology, the GNS3 controller instructs the compute server to run ubridge to create the necessary virtual bridges between nodes.
