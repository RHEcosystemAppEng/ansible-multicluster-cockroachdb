# Automated cockraochdb multicluster deployment
**Currently under construction**

## Synopsis
This provides an easy automated way to deploy the cockroachdb multicluster setup on Red Hat Advanced cluster management utilizing the submariner add-on.

The automation will do the following:
- Install Advanced cluster management (ACM)
- Import multiple openshift clusters into an ACM multi cluster Hub
- Create the clusterSet on the ACM HUB cluster
- Create the submariner add-on for the clusterSet
- Deploy the cockroachdb multicluster setup

## Prerequistes
- A minimum of 3 kubernetes clusters
  
  - **Currently only supported on AWS**
  - 1 cluster must meet the [requirements](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.3/html/install/installing#sizing-your-cluster "ACM install") needed for Advanced Cluster Management
  - 2 or more clusters will be imported as managed clusters and connected via the submariner-addon
  - Managed clusters Pod and Service Classless Inter-Domain Routing (CIDR) between the clusters that do not overlap
  - Your kubeconfig contexts must have the necessary permissions sets to create the kuberenetes objects needed for the automation
## Automation Requirements

[Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html "Ansible installation requirements") >= 2.11 - This includes all requirements needed for ansible and modules

-  Modules
   
   - [k8s](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_module.html#ansible-collections-kubernetes-core-k8s-module "k8s module") - To install it, use: ansible-galaxy collection install kubernetes.core
   - [k8_info](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_info_module.html#ansible-collections-kubernetes-core-k8s-info-module "k8_infor module") - comes with the install of kubernetes.core

[kubectl](https://kubernetes.io/docs/tasks/tools/ "kubectl install") - The Kubernetes command-line tool

[kubeconfig context configured](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/ "Configure Access to Multiple Clusters") - Your kubeconfig must be configured properly with the context of each of your clusters
  - The context name is vitally import as it is used as the **[clusterid](https://submariner.io/operations/deployment/subctl/#join)** for submariner and must be named in compliance with this
  - You should of a context setup for all the clusters that you want to use for the automation hub, and managed clusters

## Setup
Add variables

## Usage
| Description | Command |
| ----------- | ------- |
Install | `ansible-playbook install-all.yml`   
Delete | `ansible-playbook delete-all.yml`  
