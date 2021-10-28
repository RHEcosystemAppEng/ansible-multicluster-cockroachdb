# Automated cockraoch multicluster deployment
**Currently under construction**

Automation using Ansible to deploy the cockroachdb multicluster setup on Red Hat Advanced cluster management utilizing the submariner add-on.

The automation will do the following:
- Import multiple openshift clusters on AWS cloud into an ACM Hub cluster
- Create the clusterSet on the ACM HUB cluster
- Create the submariner add-on for the clusterSet
- Deploy the cockroachdb multicluster setup