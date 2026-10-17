# Case Study 01: Deploying a Web App to Kubernetes with Terraform

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=white)

> Practice scenario based on a [KodeKloud](https://kodekloud.com) Terraform challenge. The requirements came from the lab; this write-up and the planned improvements are my own.

## 📌 Scenario
Deploy a containerized web app to Kubernetes using Terraform instead of applying YAML by hand, so the setup is repeatable, reviewable, and easy to tear down and recreate.

**Requirements**
- A Deployment named `frontend` with 4 replicas
- Pods labeled `name: webapp`, running a container on port 8080
- A NodePort Service exposing the app on port 30080

## 🏗️ Architecture
```
User → NodePort Service "webapp-service" (30080)
              ↓ selector: name=webapp
        4 × Pods (container "simple-webapp", port 8080)
              ↑
        Deployment "frontend"
```

## 🧩 Key Decisions
| Decision | Why |
|---|---|
| Terraform instead of raw YAML | `plan` previews changes and state tracks what exists |
| Pinned Kubernetes provider (2.11.0) | Same behavior on every machine |
| 4 replicas | Traffic is spread across pods and the app survives a pod failure |
| NodePort service | Simple external access for a lab or local cluster |
| Service selector matches pod labels | The Service routes traffic only to pods it finds by label |

## ✅ Prerequisites
- Linux environment
- A running Kubernetes cluster and a kubeconfig file
- Terraform installed

Installing Terraform (version used in the lab):
```bash
sudo apt update
sudo apt install -y unzip curl
curl -L -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.1.5/terraform_1.1.5_linux_amd64.zip
sudo unzip /tmp/terraform.zip -d /usr/local/bin
terraform --version
```

## 🛠️ Implementation

### `provider.tf`
Configures the Kubernetes provider and points to the kubeconfig.

### `main.tf`
Defines the Deployment and the Service.

## ▶️ Run It
```bash
terraform init
terraform plan
terraform apply
kubectl get pods,svc
```
Then open `http://<node-ip>:30080`.

To remove everything:
```bash
terraform destroy
```

## ✅ Result
- 4 pods running behind one service
- App reachable on port 30080
- Whole setup can be destroyed and recreated with `terraform destroy` and `terraform apply`


## 🧠 What I Learned
- How Terraform maps to Kubernetes objects (Deployment, Service, labels, selectors)
- Why a Service selector must match the pod labels exactly
- The difference between `port`, `target_port`, and `node_port`
- Reading `terraform plan` before applying
- Finding the arguments for each resource (required vs optional, nested blocks) in the Terraform Registry documentation for the provider, and matching the doc version to the pinned provider version

## 🔜 Next Improvements
- [ ] Move values into `variables.tf` and add `outputs.tf`
- [ ] Add a dedicated namespace, resource limits, and a readiness probe
- [ ] Use a kubeconfig variable instead of a hardcoded path
