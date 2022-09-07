# Notes Rough Draft
Need to bake extra networking into ansible scripts to account for Submariner when a managed cluster is azure.

https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.4/html/services/services-overview#preparing-selected-hosts-to-deploy-submariner

https://docs.microsoft.com/en-us/cli/azure/network/lb?view=azure-cli-latest

https://docs.google.com/document/d/1mphK1H5cZ9WywJAl8hrel_WpuC_4bKZoV6Gj6h7m93k/edit

Steps to Completion:
```
ansible-playbook install-acm.yml -i localhost
ansible-playbook import-clusters.yml -i localhost
ansible-playbook create-clusterset.yml -i localhost
ansible-playbook install-submar-addon.yml  -i localhost
```

Prereqs

```bash
pip3 install openshift pyyaml kubernetes --user
```


 ansible-playbook prepare-submariner.yaml  -i localhost

