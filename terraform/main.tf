provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = true
  pm_parallel         = 10
}

resource "proxmox_vm_qemu" "vm" {
  count       = length(var.vm_names)
  name        = var.vm_names[count.index]
  vmid        = "20${count.index + 1}"
  target_node = var.target_node
  clone       = var.template_name
  full_clone  = true
  agent       = 1
  onboot      = true

  cores  = var.cpu_cores
  memory = var.memory

  scsihw = "virtio-scsi-pci"

  network {
    id     = 0
    model  = "virtio"
    bridge = var.network_bridge
  }

  disks {
    ide {
      ide3 {
        cloudinit {
          storage = var.storage
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = var.disk_size
          storage = var.storage
        }
      }
    }
  }

  ciuser    = var.ciuser
  ipconfig0 = "ip=${var.vm_ips[count.index]}/24,gw=${var.gateway}"

  sshkeys = var.ssh_public_key

  lifecycle {
    ignore_changes = [network]
  }
}

output "vm_names" {
  description = "Names of the provisioned VMs"
  value       = proxmox_vm_qemu.vm[*].name
}

output "vm_ips" {
  description = "IP addresses of the provisioned VMs"
  value       = var.vm_ips
}
