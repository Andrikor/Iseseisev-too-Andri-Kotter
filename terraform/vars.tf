variable "pm_api_url" {
  description = "Proxmox API URL (e.g. https://192.168.1.100:8006/api2/json)"
  type        = string
  default     = "https://PROXMOX_IP:8006/api2/json"
}

variable "pm_api_token_id" {
  description = "Proxmox API Token ID (e.g. terraform@pam!mytoken)"
  type        = string
  default     = "terraform@pam!mytoken"
}

variable "pm_api_token_secret" {
  description = "Proxmox API Token Secret"
  type        = string
  sensitive   = true
}

variable "target_node" {
  description = "Proxmox node name where VMs will be deployed"
  type        = string
  default     = "pve"
}

variable "template_name" {
  description = "Name of the Ubuntu 24.04 cloud-init template"
  type        = string
  default     = "ubuntu-2404-cloudinit-template"
}

variable "vm_names" {
  description = "List of VM names to provision"
  type        = list(string)
  default     = ["web-01", "db-01", "monitor-01"]
}

variable "vm_ips" {
  description = "List of static IP addresses for each VM (must match vm_names order)"
  type        = list(string)
  default     = ["10.0.1.10", "10.0.1.11", "10.0.1.12"]
}

variable "gateway" {
  description = "Default gateway for all VMs"
  type        = string
  default     = "10.0.1.1"
}

variable "cpu_cores" {
  description = "Number of CPU cores per VM"
  type        = number
  default     = 4
}

variable "memory" {
  description = "RAM per VM in MB"
  type        = number
  default     = 4096
}

variable "disk_size" {
  description = "Disk size per VM"
  type        = string
  default     = "40G"
}

variable "storage" {
  description = "Proxmox storage pool name"
  type        = string
  default     = "local-lvm"
}

variable "network_bridge" {
  description = "Proxmox network bridge"
  type        = string
  default     = "vmbr0"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "ciuser" {
  description = "Cloud-init username"
  type        = string
  default     = "ubuntu"
}
