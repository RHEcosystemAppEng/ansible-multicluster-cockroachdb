#!/bin/bash

start_time=`date +%s`
ansible-playbook remove-submar-addon-uninstall-acm.yml
end_time=`date +%s`
echo execution time was `expr $end_time - $start_time` s.
say `expr $end_time - $start_time` seconds

start_time=`date +%s`
ansible-playbook install-acm.yml
end_time=`date +%s`
echo execution time was `expr $end_time - $start_time` s.
say `expr $end_time - $start_time` seconds


start_time=`date +%s`
ansible-playbook install-acm-import-clusters.yml
end_time=`date +%s`
echo execution time was `expr $end_time - $start_time` s.
say `expr $end_time - $start_time` seconds

start_time=`date +%s`
ansible-playbook remove-import-clusters.yml
end_time=`date +%s`
echo execution time was `expr $end_time - $start_time` s.
say `expr $end_time - $start_time` seconds


start_time=`date +%s`
ansible-playbook remove-clusters-uninstall-acm.yml
end_time=`date +%s`
echo execution time was `expr $end_time - $start_time` s.
say `expr $end_time - $start_time` seconds


start_time=`date +%s`
ansible-playbook uninstall-acm.yml
end_time=`date +%s`
echo execution time was `expr $end_time - $start_time` s.
say "done"

start_time=`date +%s`
ansible-playbook install-acm.yml
end_time=`date +%s`
echo execution time was `expr $end_time - $start_time` s.
say "done"

# This is working
pip3 freeze | egrep "(ansible|openshift|kubernetes)"
ansible==4.7.0
ansible-core==2.11.6
kubernetes==12.0.0
openshift==0.12.1

$PYTHON -m pip install 'openshift==0.7.2' 

apiVersion: v1
kind: Secret
metadata:
  name: auto-import-secret
  namespace: hub
stringData:
  autoImportRetry: "5"
  token: sha256~nXP4tJxipVLsD-n8vO3rm9XEtVAtWfNgl00rGWhZqdE
  server: https://api.acm-managed-1.kni.syseng.devcluster.openshift.com:6443
type: Opaque