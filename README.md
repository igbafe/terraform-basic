# 🌐 Terraform AWS VPC: Public & Private Networking

A hands-on Infrastructure as Code project where I built a multi-tier AWS network from scratch with **Terraform**: a custom VPC with public and private subnets across two Availability Zones, an Internet Gateway, a NAT Gateway, and route tables wired together.

Part of my learning-in-public journey from web development into **cloud engineering and DevOps**.

---

## 📌 What This Project Builds

- A custom **VPC** (`10.0.0.0/16`) in **us-east-2 (Ohio)**
- **Two public subnets** and **two private subnets**, spread across two Availability Zones
- An **Internet Gateway** for public internet access
- A **public route table** with a default route (`0.0.0.0/0`) to the Internet Gateway
- A **private route table** for the private subnets
- A **NAT Gateway** (with an **Elastic IP**) so private resources can reach the internet outbound only
- **Security groups** for public and private resources
- Route table **associations** connecting each subnet to the right route table

---

## 🏗️ Architecture

```
AWS Region: us-east-2 (Ohio)
│
└── VPC: 10.0.0.0/16
    │
    ├── Availability Zone 1
    │   ├── Public Subnet 01   (10.0.0.0/24)
    │   └── Private Subnet 01  (10.0.2.0/24)
    │
    ├── Availability Zone 2
    │   ├── Public Subnet 02
    │   └── Private Subnet 02  (10.0.3.0/24)
    │
    ├── Internet Gateway ──► Public Route Table   (0.0.0.0/0 → IGW)
    └── NAT Gateway (+ Elastic IP) ──► Private Route Table (outbound only)
```

| Subnet type | `map_public_ip_on_launch` | Route to Internet Gateway | Internet access |
|-------------|---------------------------|---------------------------|-----------------|
| Public | `true` | Yes | Direct, if security rules allow |
| Private | `false` | No | Outbound only, through the NAT Gateway |

---

## 🛠️ Tech Stack

| Area | Tools |
|------|-------|
| IaC | Terraform |
| Cloud | AWS (VPC, Subnets, Internet Gateway, NAT Gateway, Elastic IP, Route Tables, Security Groups) |
| Region | us-east-2 (Ohio) |

---

## 🚀 Key Terraform Snippets

### Public subnet with auto-assigned public IPs
```hcl
resource "aws_subnet" "public_subnet_01" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-01"
  }
}
```

### Spreading subnets across Availability Zones
```hcl
data "aws_availability_zones" "available" {
  state = "available"
}

# In each subnet:
availability_zone = data.aws_availability_zones.available.names[0]  # AZ 1
availability_zone = data.aws_availability_zones.available.names[1]  # AZ 2
```

### Route to the Internet Gateway
```hcl
resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.terraform_igw.id
}
```

### Attaching subnets to route tables
```hcl
resource "aws_route_table_association" "public_subnet_01_association" {
  subnet_id      = aws_subnet.public_subnet_01.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_01_association" {
  subnet_id      = aws_subnet.private_subnet_01.id
  route_table_id = aws_route_table.private_route_table.id
}
```

---

## ▶️ How to Run

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

**Verify:** AWS Console → VPC → Route Tables → select the public route table → Routes. You should see:

| Destination | Target |
|-------------|--------|
| `10.0.0.0/16` | `local` |
| `0.0.0.0/0` | `igw-xxxxxxxx` |

---

## 💸 Clean Up (Avoid Surprise AWS Bills)

NAT Gateways and Elastic IPs cost money while they exist, so I destroy the lab when I'm done:

```bash
terraform state list          # see what Terraform manages
terraform plan -destroy       # preview what will be deleted
terraform destroy             # type "yes" to confirm
```

After destroying, double-check the console (in the right region) for leftovers: NAT Gateways, Elastic IPs, EC2 instances, EBS volumes, and load balancers.

---

## 🧠 What I Learned

- An Internet Gateway isn't attached to a route table directly. You add a **route** that points to it.
- A subnet is **public** because of its **route table**, not because of `map_public_ip_on_launch`. A working public instance needs all three: a public IP, a route to the IGW, and permissive security group/NACL rules.
- A VPC lives in **one region**. For two regions (like us-east-1 and us-east-2), you need two providers (with aliases) and separate VPCs, optionally connected with VPC peering or Transit Gateway.
- **Availability Zones** give resilience inside a region. Multiple regions give disaster recovery.
- Always run `terraform plan -destroy` before `terraform destroy`.

---

## 🎯 Next Steps

- [ ] Launch EC2 instances in the public and private subnets
- [ ] Add a multi-region setup (us-east-1 + us-east-2) with provider aliases
- [ ] Inter-region VPC peering
- [ ] Move to reusable Terraform modules and remote state (S3 + DynamoDB locking)

---

## 🤝 Connect

**Peter Igbafe** · Junior Web Developer → Cloud/DevOps Engineer
🌐 [peterigbafe.vercel.app](https://igbafe-site.vercel.app/) · 💻 [@peter-igbafe](https://github.com/igbafe)

⭐ If this helped you, give the repo a star!
