# Automated cockroachdb multicluster deployment
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
  
  - **Currently only supported on AWS/GCP**
  - 1 cluster must meet the [requirements](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.4/html/install/installing#sizing-your-cluster "ACM install") needed for Advanced Cluster Management

    - Running openshift = 4.9.9
  - 2 or more clusters will be imported as managed clusters and connected via the submariner-addon
  - Managed clusters Pod and Service Classless Inter-Domain Routing (CIDR) between the clusters that do not overlap
  - Your kubeconfig contexts must have the necessary permissions sets to create the kuberenetes objects needed for the automation
## Automation Requirements

[Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html "Ansible installation requirements") >= 2.11 - This includes all requirements needed for ansible and modules

-  Modules
   
   - [k8s](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_module.html#ansible-collections-kubernetes-core-k8s-module "k8s module") - To install it, use: ansible-galaxy collection install kubernetes.core
   - [k8_info](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_info_module.html#ansible-collections-kubernetes-core-k8s-info-module "k8_infor module") - comes with the install of kubernetes.core

[kubectl](https://kubernetes.io/docs/tasks/tools/ "kubectl install") - The Kubernetes command-line tool

[cockroach cli](https://www.cockroachlabs.com/docs/stable/install-cockroachdb-mac.html "cockroachdb cli install") - The cockroachdb command line tool

[kubeconfig context configured](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/ "Configure Access to Multiple Clusters") - Your kubeconfig must be configured properly with the context of each of your clusters
  - The context name is vitally import as it is used as the **[clusterid](https://submariner.io/operations/deployment/subctl/#join)** for submariner and must be named in compliance with this
  - You should of a context setup for all the clusters that you want to use for the automation hub, and managed clusters

Access to push and clone from the remote repository

## Setup
Add environment variables

| Environment variable | Description |
| --- | --- |
| AWS_ACCESS_KEY | The AWS access key id for the AWS clusters you are importing
| AWS_SECRET_KEY | The AWS secret key for the AWS clusters you are importing
| GIT_SSH_COMMAND | Git push will use this command instead of ssh when connecting to a remote system
| OCP_SERVICE_ACCOUNT | [GCP Service Account](https://cloud.google.com/iam/docs/service-accounts)
| IR_PASSWORD | image registry password


Modify variables in **group_vars/all.yml**

| Variable | Description
| --- | --- |
| clusters | A list that includes: name of the cluster you want, and the name of the context associated with the cluster in your kubeconfig, and the cloud that the cluster is running in
| hub_context | The context name for your hub cluster
| ocp_pull_secret_path | The path to your OpenShift container platform [pull secret](cloud.redhat.com/openshift/install/pull-secret)
| clusterset_name | Default cockroackdb-clusterset the name of the clusterset you want
| kubectl | The path to your kubectl 
| cockroach | The path to your cockroachdb cli
| git_url | Your repo location in ssh format
| git_branch | Defaults to master
| git_msg | Defaults to "update files with ansible" is the message sent when automation pushes 
| git_remove_local | Defaults to false
| git_username | Defaults to ansible_git your username for github
| git_email | Defaults to ansible_git@ansible.com the email associated with your github account
| Resources | Resources for the `pod.spec.containers.resources` and `volumeClaimTemplate.spec.resources.requests.storage`
| ir_username | username for image [registry](https://access.redhat.com/terms-based-registry/)

## Usage
| Description | Command |
| ----------- | ------- |
Install | `ansible-playbook install-all.yml`   
Delete | `ansible-playbook delete-all.yml`  
