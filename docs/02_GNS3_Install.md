# GNS3 Install

GNS3 can be installed on [Windows](https://docs.gns3.com/docs/getting-started/installation/windows), [macOS](https://docs.gns3.com/docs/getting-started/installation/mac), or [Linux](https://docs.gns3.com/docs/getting-started/installation/linux) either as a standalone application or in conjunction with the [GNS3 VM](https://docs.gns3.com/docs/getting-started/installation/download-gns3-vm) for enhanced performance and emulator support. GNS3 VM acts as a compute backend running emulators like QEMU, Dynamips, or Docker. For best results, especially when working with resource-intensive images, it's recommended to install the GNS3 VM. GNS3 VM is available for popular virtualization platforms such as:

- VMware Workstation/Player
- Oracle VirtualBox
- Microsoft Hyper-V
- KVM/QEMU

## GNS3 VM on a Type 1 Hypervisor

GNS3 can be deployed on a Type 1 (bare-metal) hypervisor such as VMware ESXi or Proxmox VE (for background on Type 1 hypervisors, KVM, and Proxmox, see the [Virtualization Primer — Type 1 Hypervisors](https://github.com/ManiAm/primer-virtualization/blob/master/docs/03_type1_hypervisors.md)). In this architecture, the GNS3 VM runs on the hypervisor while the GNS3 GUI runs on a separate management workstation. This separation offloads resource-intensive emulation to the server, supports larger topologies, and improves overall performance.

## Proxmox VE — Home Lab Setup

In my home lab, I run Proxmox VE on the **MINISFORUM UM890 Pro**, a compact mini PC with:

- **CPU** — AMD Ryzen 9 8945HS (8 cores / 16 threads, Zen 4) with Radeon 780M iGPU
- **RAM** — 64 GB DDR5
- **Storage** — 1 TB PCIe 4.0 NVMe SSD

<img src="../pics/proxmox.jpg" alt="Proxmox VE home lab" width="700">

Follow these [video instructions](https://youtu.be/qmSizZUbCOA) to set up Proxmox VE.

## Setting up GNS3 VM on Proxmox VE

Follow these [video instructions](https://youtu.be/UfqjqigS-OM) or refer to the detailed steps below to deploy the GNS3 VM on Proxmox VE.

Open your browser and navigate to the Proxmox VE web UI:

    https://192.168.2.136:8006

Open the Proxmox shell (via web UI or SSH) and check if nested virtualization is enabled:

For AMD-based systems:

```bash
cat /sys/module/kvm_amd/parameters/nested
```

For Intel-based systems:

```bash
cat /sys/module/kvm_intel/parameters/nested
```

If the result is `1`, nested virtualization is enabled. If not, you'll need to enable it and reboot the host.

Visit the [GNS3 release page](https://github.com/GNS3/gns3-gui/releases/tag/v2.2.54).

Download `GNS3.VM.VMware.ESXI.<version>.zip` file.

Extract the zip archive to obtain the OVA file.

In the Proxmox Web UI, navigate to:

    Datacenter → Node → local (or your target storage) → Import → Upload

Upload the OVA file.

Go back to the Proxmox shell and navigate to the upload directory:

```bash
cd /var/lib/vz/import
```

Extract the OVA file:

```bash
tar xvf GNS3_VM.ova
```

Import the VM using a unique VM ID:

```bash
qm importovf 102 "GNS3 VM.ovf" local
```

Replace `102` with your preferred available VM ID, and `local` with your Proxmox storage name. You can list valid storage options using:

```bash
pvesm status
```

Locate the new VM (named something like `Clone-of-gns3`) in the Proxmox Web UI.

Go to the Hardware tab:

- Add a Network Device. Select your bridge (e.g., vmbr0) connected to your LAN
- Increase Memory (e.g., 4–8 GB)
- Assign at least 2 vCPUs and set CPU type to `host`

Open the Console tab, click Start and wait for the VM to boot.

It should display the GNS3 splash screen along with its IP address and API port.

<img src="../pics/gns3_vm.jpg" alt="segment" width="450">

You can now access the GNS3 VM using Web UI by going to:

    http://ip.address.shown.above

Alternatively, you can connect GNS3 GUI to GNS3 VM (I prefer this approach).

Install GNS3 on your Windows, macOS, or Linux system.

When prompted, choose: "Run appliances on a remote server".

Enter the IP address and port of the GNS3 VM.

If you have an existing GNS3 installation, then open GNS3 and go to:

    Edit | Preferences | Server | Remote servers

Click on Add and enter the IP address and port of the GNS3 VM.

Once added, the GNS3 GUI will connect to the Proxmox-hosted GNS3 VM, offloading processing and allowing full use of the GNS3 environment.
