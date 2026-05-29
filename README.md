# Iseseisev töö — Andri Kotter

  Selles töös kasutasin Terraformi, Ansiblet, Dockerit ja Proxmoxi, et automaatselt paigaldada Flask veebirakendus PostgreSQL andmebaasiga.

  ---

  ## Mis see teeb

  Flask rakendus kuvab veebilehe, kus kasutajad saavad sõnumeid jätta. Sõnumid salvestatakse PostgreSQL andmebaasi. Kõik jookseb Dockeris.

  ---

  ## Virtuaalmasinad

  | VM | IP | Otstarve |
  |---|---|---|
  | web-01 | 10.0.1.10 | Flask rakendus + Docker |
  | db-01 | 10.0.1.11 | PostgreSQL andmebaas |
  | monitor-01 | 10.0.1.12 | Monitooring |

  ---

  ## Struktuur

  ```
  studentapp/     - Flask rakendus (app.py, Dockerfile, docker-compose.yml)
  ansible/        - Ansible playbook ja rollid (docker, postgresql, monitoring)
  terraform/      - Terraform kood VM-ide loomiseks Proxmoxis
  ```

  ---

  ## Käivitamine

  ### 1. Infrastruktuur (Terraform)

  ```bash
  cd terraform
  cp terraform.tfvars.example terraform.tfvars
  # Täida oma Proxmox andmed terraform.tfvars failis
  terraform init
  terraform apply
  ```

  ### 2. Seadistamine (Ansible)

  ```bash
  cd ansible
  # Muuda inventory failis IP-aadressid oma omadeks
  ansible-playbook -i inventory deploy.yml
  ```

  ### 3. Rakendus lokaalselt (Docker)

  ```bash
  cd studentapp
  docker compose up -d
  # Ava brauser: http://localhost:5000
  ```

  ---

  ## Valideerimise nimekiri

  | Nõue | Staatus |
  |---|---|
  | Terraform loob VM-id | ☐ |
  | Ansible seadistab süsteemid | ☐ |
  | Docker konteinerid ehitatakse edukalt | ☐ |
  | Flask rakendus on brauseris nähtav | ☐ |
  | PostgreSQL salvestab sõnumeid | ☐ |
  | Rakendus töötab pärast taaskäivitust | ☐ |
  | Infrastruktuur on reprodutseeritav | ☐ |
  