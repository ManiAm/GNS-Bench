## GNS3 Appliance

A GNS3 appliance is a pre-configured virtual device definition that simplifies the deployment of network operating systems and tools within the GNS3 environment. Packaged as a `.gns3a` file, each appliance includes metadata such as the device name, supported emulators (e.g., QEMU, Docker), minimum hardware requirements, recommended images, and startup configurations. Appliances streamline the process of importing and launching complex systems like Cisco vIOS, Juniper vMX, or open-source firewalls by automatically linking the correct image formats and settings. By using appliances, users can significantly reduce setup time, ensure consistency across environments, and gain access to a library of trusted and ready-to-deploy network components.

## GNS3 Marketplace

The GNS3 [Marketplace](https://gns3.com/marketplace/appliances) is an official online platform where users can browse, download, and share GNS3 appliances. It hosts a wide range of vendor-supported and community-contributed appliances, including routers, switches, firewalls, Linux utilities, and containerized services. Each appliance in the marketplace includes a `.gns3a` file.

GNS3 has a built-in appliance manager that connects directly to the GNS3 online appliance repository. Go to "File > New Template" in the GNS3 GUI and choose "Install an appliance from the GNS3 server". GNS3 fetches a list of all available official appliances. You can browse, search, and select appliances to install without visiting the website manually. This method simplifies the appliance setup process and keeps everything integrated within the GUI. No need to download .gns3a files manually.

<img src="../pics/appliances.jpg" alt="segment" width="500">

## Installing Cisco 7200 Appliance

The Cisco 7200 series router, emulated via Dynamips in GNS3, is a legacy platform that allows users to run actual Cisco IOS images. Despite being retired by Cisco, it remains valuable for foundational routing practice and understanding traditional Cisco network configurations.

You can either use the built-in GNS3 appliance manager, and find "Cisco 7200" under "Routers". You can also download the "Cisco 7200" appliance for GNS3 from the [marketplace](https://gns3.com/marketplace/appliances/cisco-7200). To import the appliance, open the GNS3 GUI and navigate to:

    File → Import Appliance

When prompted to choose the server type, select "Install the appliance on a remote server" if your GNS3 VM is running remotely for example, on Proxmox VE. GNS3 will display the available appliance version(s) and the list of required image files. Click on a missing image, then choose "Import" to upload your [local image](https://github.com/hegdepavankumar/Cisco-Images-for-GNS3-and-EVE-NG) file. GNS3 automatically verifies the image using its checksum and uploads it to the remote GNS3 VM. Once the import is complete, you can drag the "Cisco 7200" icon onto your workspace. Right-click on the node, select "Configure", and under the Slots tab, you can add or remove hardware modules as needed to match your lab requirements.

## GNS3 QEMU-based Appliances

GNS3 QEMU-based appliances are full virtual machine images that run inside the GNS3 environment using the QEMU emulator. These appliances simulate real operating systems and platforms, providing users with access to full-featured Linux distributions, security tools, network management systems, storage OSes, and more. Unlike lightweight containers or emulators like Dynamips, QEMU appliances operate as complete virtualized systems and are often used in advanced network labs, security testing, or infrastructure simulation. GNS3 allows you to deploy these VMs alongside routers, switches, and traffic generators, enabling rich, multi-platform network topologies that closely mimic real-world environments.

QEMU-based appliances require kernel-level virtualization support, and GNS3 leverages QEMU to run these VMs. While it's technically possible to run QEMU appliances locally without the GNS3 VM, this setup has several limitations and drawbacks, which the GNS3 VM solves. QEMU is already installed and configured inside the GNS3 VM. Open the GNS3 VM window and use the interactive console. Run the version check command:

```bash
gns3@gns3vm:~$ qemu-system-x86_64 --version

QEMU emulator version 8.0.4 (Debian 1:8.0.4+dfsg-1ubuntu3.23.10.5)
Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
```

You can find a list of QEMU-based appliances in [here](GNS3_Appliance_QEMU.md).

## GNS3 Docker-based Appliances

GNS3 Docker-based appliances are lightweight, containerized tools that integrate seamlessly into GNS3 topologies. Instead of emulating full operating systems like QEMU-based appliances, Docker containers provide fast, resource-efficient environments ideal for testing, automation, and development workflows. These appliances are pre-configured for specific functions such as network traffic generation, scripting, terminal access, or protocol simulation making them especially valuable for rapid prototyping, DevOps labs, and CI/CD test environments.

Unlike traditional virtual machines, Docker appliances start instantly and consume fewer system resources, which allows users to deploy multiple nodes without overwhelming the host. GNS3 supports Docker integration natively, enabling containers to be used just like routers or hosts: they can be added to a topology, configured through terminal access, and interconnected with virtual switches and routers.

Docker-based appliances are commonly used for:

- Simulating Linux endpoints and network services (HTTP, DNS, DHCP, AAA)
- Deploying network tools like `ntopng` or `Ostinato` for traffic analysis
- Running automation scripts (e.g., with Python, Go, or Cisco PyATS)
- Building custom DevOps pipelines and network testing platforms
- Launching browsers inside the lab environment

While it is technically possible to use Docker-based appliances locally (if Docker is installed on your host), doing so may cause compatibility issues, resource contention, and unreliable networking. The GNS3 VM solves these problems by providing a consistent, Linux-based environment where both Docker and QEMU run in an integrated and optimized way. Docker is preinstalled and enabled inside the GNS3 VM. GNS3 uses the Docker API on the GNS3 VM to pull images, run containers, and connect them to your virtual network topology. You can access the Docker environment directly from the GNS3 VM console:

```bash
gns3@gns3vm:~$ docker --version

Client: Docker Engine - Community
 Version:           28.1.1
 API version:       1.49
 Go version:        go1.23.8
 Git commit:        4eba377
 Built:             Fri Apr 18 09:52:18 2025
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          28.1.1
  API version:      1.49 (minimum version 1.24)
  Go version:       go1.23.8
  Git commit:       01f442b
  Built:            Fri Apr 18 09:52:18 2025
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.7.27
  GitCommit:        05044ec0a9a75232cad458027ca83437aae3f4da
 runc:
  Version:          1.2.5
  GitCommit:        v1.2.5-0-g59923ef
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```

```bash
gns3@gns3vm:~$ docker ps

CONTAINER ID   IMAGE         COMMAND                  CREATED        STATUS        PORTS   NAMES
6aba73df1362   nginx:latest  "/gns3/init.sh /dock…"   3 hours ago    Up 3 hours            eloquent_albattani
```

You can find a list of Docker-based appliances in [here](GNS3_Appliance_Docker.md).
