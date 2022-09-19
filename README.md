# Automated cockroachdb multicluster deployment
**Currently under construction**

## Synopsis
This provides an easy automated way to deploy the CockroachDB multicluster setup on Red Hat Advanced Cluster Management utilizing the Submariner Add-on.

The automation will do the following:
- Install Advanced cluster management (ACM)
- Import multiple openshift clusters into an ACM multi cluster Hub
- Create the `ClusterSet` on the ACM HUB cluster
- Create the Submariner Add-on for the clusterSet
- Deploy the CockroachDB multicluster setup

## Prerequistes
- A minimum of 3 kubernetes clusters are recommended but not enforced.
  - 1 cluster as the dedicated ACM Hub which meets [requirements](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.4/html/install/installing#sizing-your-cluster "ACM install")
    - Tested on OpenShift 4.9.9
    - Tested on OpenShift 4.10
  - 2 or more clusters will be imported as `ManagedClusters` and connected via the submariner-addon
  - Managed Clusters **must** have non-overlapping Pod and Service CIDR ranges
  - Your kubeconfig contexts must have the necessary permissions sets to create the kubernetes objects needed for the automation. We recommend a cluster-admin role assigned to your user.
  - Your cloud credentials (AWS, GCP, Azure) must have necessary permissions to create networking configuraion for the Submariner addon. _We recommend admin permissions for handling such tasks._

## Automation Requirements

[Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html "Ansible installation requirements") >= 2.11 - This includes all requirements needed for ansible and modules

-  Modules
   - [k8s](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_module.html#ansible-collections-kubernetes-core-k8s-module "k8s module") - To install it, use: `ansible-galaxy collection install kubernetes.core`
   - [k8_info](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_info_module.html#ansible-collections-kubernetes-core-k8s-info-module "k8_info module") - comes with the install of kubernetes.core
   - Other dependent modules:
      - ```bash
         pip3 install openshift pyyaml kubernetes jmespath --user
        ```

[kubectl](https://kubernetes.io/docs/tasks/tools/ "kubectl install") - The Kubernetes command-line tool

[cockroach cli](https://www.cockroachlabs.com/docs/stable/install-cockroachdb-mac.html "cockroachdb cli install") - The cockroachdb command line tool

[kubeconfig context configured](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/ "Configure Access to Multiple Clusters") - Your kubeconfig must be configured properly with the context of each of your clusters
  - The context name is vitally import as it is used as the **[clusterid](https://submariner.io/operations/deployment/subctl/#join)** for submariner and must be named in compliance with this
  - You should of a context setup for all the clusters that you want to use for the automation hub, and managed clusters
  - https://github.com/cmwylie19/kubeconfig-builder can build your master kubeconfig by combining KubeConfig's into one 

Access to push and clone from the remote repository

## Setup
Add environment variables:

| Environment variable | Description |
| --- | --- |
| AWS_ACCESS_KEY | The AWS access key id for the AWS clusters you are importing
| AWS_SECRET_KEY | The AWS secret key for the AWS clusters you are importing
| GIT_SSH_COMMAND | Git push will use this command instead of ssh when connecting to a remote system
| OCP_SERVICE_ACCOUNT | [GCP Service Account](https://cloud.google.com/iam/docs/service-accounts)
| IR_PASSWORD | image registry password

For Azure managed clusters:
- must have an `~/.azure/osServicePrincipal.json` with with admin permissions for the automation to configure the network

Modify variables in **group_vars/all.yml**:

| Variable | Description
| --- | --- |
| clusters | A list that includes: name of the cluster you want, and the name of the context associated with the cluster in your kubeconfig, and the cloud that the cluster is running in
| hub_context | The context name for your hub cluster
| ocp_pull_secret_path | The path to your OpenShift container platform [pull secret](cloud.redhat.com/openshift/install/pull-secret)
| clusterset_name | Default cockroackdb-clusterset the name of the clusterset you want
| kubectl | The path to your kubectl 
| az | The path to your ([Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)) 
| cockroach | The path to your [cockroachdb CLI](https://www.cockroachlabs.com/docs/releases/index.html#production-releases)
| git_url | Your repo location in ssh format
| git_branch | Must always be main. You cannot change this at this time.
| git_msg | Defaults to "update files with ansible" is the message sent when automation pushes 
| git_remove_local | Defaults to false
| git_username | Defaults to ansible_git your username for github
| git_email | Defaults to ansible_git@ansible.com the email associated with your github account
| Resources | Resources for the `pod.spec.containers.resources` and `volumeClaimTemplate.spec.resources.requests.storage`

## Usage
| Description | Command |
| ----------- | ------- |
Install | `ansible-playbook install-all.yml`   
Delete | `ansible-playbook delete-all.yml`  

or command can be run one by one for more control:
- `ansible-playbook -i localhost install-acm.yml`
- `ansible-playbook -i localhost import-clusters`
- `ansible-playbook -i localhost create-clusterset`
- `ansible-playbook -i localhost install-submar-addon.yml`
- `ansible-playbook -i localhost install-multi-cockroachdb.yml`

**Please note:** Due to the nature of ACM, this is a very slow process. I recommend running the plays one by one, letting them  finish individually for best results. It can take 15-20 for a single play to finish depending on how many clusters are preset. The uninstallation, removing a `ManagedCluster` in ACM can take many hours. The installation add files to this repository used in the automation - after an installation the uninstall **MUST** run to clean up the repository.