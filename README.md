# Student DevOps Assignment — Flask + Docker + Ansible + Terraform + Proxmox

A complete automated deployment of a Flask web application using infrastructure-as-code tools.

---

## Project Structure

```
.
├── studentapp/                  # Flask web application
│   ├── app.py                   # Main application
│   ├── requirements.txt         # Python dependencies
│   ├── Dockerfile               # Container image definition
│   ├── docker-compose.yml       # Multi-container setup (Flask + PostgreSQL)
│   ├── .dockerignore
│   └── templates/
│       └── index.html           # Web UI
│
├── ansible/                     # Configuration management
│   ├── deploy.yml               # Main playbook
│   ├── inventory                # VM host definitions
│   ├── vars/
│   │   └── variables.yml        # Shared variables
│   ├── templates/
│   │   ├── hostname.j2          # Hostname template
│   │   └── netplan.yml.j2       # Network config template
│   └── roles/
│       ├── update/              # OS package updates + reboot
│       ├── hostname/            # Set system hostname
│       ├── netplan/             # Configure static IP networking
│       ├── docker/              # Install Docker + deploy app containers
│       ├── postgresql/          # PostgreSQL setup + firewall
│       └── monitoring/          # Monitoring tools + Node Exporter
│
└── terraform/                   # Infrastructure provisioning
    ├── versions.tf              # Provider version locks
    ├── main.tf                  # VM resource definitions
    ├── vars.tf                  # Input variable declarations
    └── terraform.tfvars.example # Example values (copy → terraform.tfvars)
```

---

## Infrastructure

| VM Name    | IP Address  | Purpose                       |
|------------|-------------|-------------------------------|
| web-01     | 10.0.1.10   | Flask application + Docker    |
| db-01      | 10.0.1.11   | PostgreSQL database           |
| monitor-01 | 10.0.1.12   | Monitoring (Node Exporter)    |

All VMs run **Ubuntu Server 24.04** cloud images on Proxmox VE.

---

## Quick Start

### 1. Prepare the Proxmox Template

Run on your Proxmox host to create the Ubuntu 24.04 cloud-init template:

```bash
bash terraform/24.04_img.sh
```

### 2. Provision VMs with Terraform

```bash
cd terraform

# Copy and fill in your values
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars

terraform init
terraform plan
terraform apply
```

### 3. Configure VMs with Ansible

Update `ansible/inventory` with your actual IP addresses, then:

```bash
cd ansible

# Run the full deployment playbook
ansible-playbook -i inventory deploy.yml
```

### 4. Verify the Application

```bash
# Test the web app is running
curl http://10.0.1.10:5000

# Check running containers on web-01
ssh ubuntu@10.0.1.10 "docker ps"
```

---

## Part 1 — Flask Application

The Flask app lets users submit and view messages, stored in PostgreSQL.

### Run Locally with Docker Compose

```bash
cd studentapp

docker compose build
docker compose up -d
docker ps

# Test it
curl http://localhost:5000
```

### Environment Variables

| Variable  | Default      | Description              |
|-----------|-------------|--------------------------|
| DB_HOST   | db          | PostgreSQL hostname       |
| DB_NAME   | studentapp  | Database name             |
| DB_USER   | studentadmin| Database user             |
| DB_PASS   | studentpass | Database password         |

---

## Ansible Roles

| Role        | Target     | What it does                                    |
|-------------|------------|-------------------------------------------------|
| update      | all        | apt-get dist-upgrade + conditional reboot       |
| netplan     | all        | Writes static IP config via template            |
| hostname    | all        | Sets system hostname via template               |
| docker      | web-01     | Installs Docker, copies app files, starts containers |
| postgresql  | db-01      | Installs PostgreSQL, creates DB/user, UFW rules |
| monitoring  | monitor-01 | Installs htop/iotop/sysstat + Node Exporter     |

---

## Terraform Variables

| Variable            | Default                        | Description                     |
|---------------------|--------------------------------|---------------------------------|
| pm_api_url          | https://PROXMOX_IP:8006/...    | Proxmox API endpoint            |
| pm_api_token_id     | terraform@pam!mytoken          | API token identifier            |
| pm_api_token_secret | —                              | API token secret (sensitive)    |
| target_node         | pve                            | Proxmox node name               |
| template_name       | ubuntu-2404-cloudinit-template | VM template to clone from       |
| vm_names            | [web-01, db-01, monitor-01]    | Names for each VM               |
| vm_ips              | [10.0.1.10–.12]                | Static IPs for each VM          |
| ssh_public_key      | —                              | Your SSH public key             |
| cpu_cores           | 4                              | vCPUs per VM                    |
| memory              | 4096                           | RAM per VM (MB)                 |
| disk_size           | 40G                            | Disk per VM                     |

---

## Validation Checklist

| Requirement                          | Status |
|--------------------------------------|--------|
| Terraform provisions VMs             | ☐      |
| Ansible configures systems           | ☐      |
| Docker containers build successfully | ☐      |
| Flask app accessible in browser      | ☐      |
| PostgreSQL stores messages           | ☐      |
| Application survives container restart | ☐    |
| Infrastructure reproducible          | ☐      |

---

## Bonus Features Implemented

- Docker healthcheck on PostgreSQL before Flask starts
- UFW firewall on db-01 (only allows web-01 to reach PostgreSQL)
- UFW firewall on monitor-01
- Prometheus Node Exporter on monitor-01 (port 9100)
- sysstat enabled for historical performance data
- `terraform.tfvars` excluded from git for security
