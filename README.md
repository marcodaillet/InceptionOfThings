# Project Overview:

This university project is divided into three parts, each focusing on deploying and managing Kubernetes clusters and applications using tools like Vagrant, K3s, K3d, and Argo CD. The project aims to enhance understanding and practical experience with container orchestration and continuous deployment practices.

## Part 1: K3s and Vagrant

Objective: Set up two virtual machines using Vagrant, with specific configurations and IPs. Install K3s in controller mode on the first machine and agent mode on the second. Configure SSH access with no password.

Key Points:

- Vagrantfile configurations following modern practices.
- Installation of K3s on separate machines with distinct roles.
- Utilization of kubectl for Kubernetes cluster management.

## Part 2: K3s and Three Simple Applications

Objective: Set up a single virtual machine with K3s in server mode and deploy three web applications accessible via different hosts. Configure replicas for one application.

Key Points:

- Deployment of three web applications on a K3s instance.
- Custom configuration to display specific apps based on the requested host.
- Introduction of application replicas for one of the applications.

## Part 3: K3d and Argo CD

Objective: Install K3d without Vagrant, create namespaces for Argo CD and development, and set up a continuous integration infrastructure. Deploy an application using Argo CD, which is synchronized with a public GitHub repository.

Key Points:

- Understanding the differences between K3S and K3D.
- Setup of namespaces for Argo CD and development.
- Integration with GitHub for continuous deployment.
- Version control of applications with easy updates through GitHub.
