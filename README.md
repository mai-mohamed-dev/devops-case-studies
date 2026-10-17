
# 📚 DevOps Case Studies

Mini case studies from my DevOps learning journey. Each one covers a small, realistic scenario: the problem, the decisions I made, how I built it, the issues I hit, and what I learned.

> Some case studies are based on hands-on labs (for example, **KodeKloud** challenges). I credit the source in each one and write up the approach in my own words. Original projects are marked 🛠️.

## 🗂️ Case Studies

| # | Case Study | Tools | Type | Status |
|---|------------|-------|------|--------|
| 01 | [Deploying a web app to Kubernetes with Terraform](./01-terraform-k8s-deployment) | Terraform, Kubernetes | 🧪 Lab-based | ✅ Done |

## 📁 Repository Structure
```
devops-case-studies/
├── README.md                      
├── LICENSE
├── .gitignore
└── 01-terraform-k8s-deployment/
    ├── README.md                 
    ├── provider.tf
    ├── main.tf
    └── images/                   
```

New case studies are added as numbered folders, each with its own README and code.
## 🧭 How Each Case Study Is Structured
Every folder has its own README with:
- **Scenario:** what problem it addresses
- **Architecture:** a simple diagram or flow
- **Key decisions:** what I chose and why
- **Implementation and how to run it**
- **Issues I hit:** problem → cause → fix
- **What I learned** and **next improvements**


## 🛠️ Tools I'm Working With
![Git](https://img.shields.io/badge/Git-F05032?logo=git&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=white)

## 🎯 Goals
- Build one small, working case study at a time
- Document decisions and mistakes, not just final results
- Revisit each case study and improve it through pull requests

## 📄 License
Code in this repository is released under the [MIT License](./LICENSE). Lab-based case studies credit their original source.
