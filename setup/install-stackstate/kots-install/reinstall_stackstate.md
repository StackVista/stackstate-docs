---
description: StackState Self-hosted v4.6.x
---

# Re-Install StackState

## Overview 

Should you wish to reinstall StackState when running on KOTS you have the option to reinstall from scratch or keep the existing configuration

## Before you start

Before you start the installation of KOTS and StackState:

* It is recommended that you take a backup if needed

## Re-install StackState but keep configuration 

{% hint style="warning" %}
This process will save your system configuration but will delete any data that StackState has ingested.
{% endhint %}

  1. Login to your server via `ssh`
  2. Run `helm ls -A` to view the current installed applications 
     You should see output similar to 
     ```
     [user@server ~]$ helm ls -A
     NAME      	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART           	APP VERSION
     stackstate	default  	2       	2022-03-21 14:24:43.826966101 +0000 UTC	deployed	stackstate-4.5.5	4.5.5
     ```
  3. Run `helm uninstall -n <namespace> stackstate` replacing `<namespace>` as appropriate. In the above example it is `default`
  4. Run `kubectl delete -n default pvc -l app.kubernetes.io/instance=stackstate` to remove the virtual disks
  5. Run `kubectl delete -n default pvc -l app=stackstate-elasticsearch-master` to remove the ElasticSearch virtual disks.
  6. To check everything is removed correctly check there are no StackState pods or disks. This may take a few minutes
     ```
     # Example commands
     kubectl get pods -A | grep stackstate # Check for running pods
     kubectl get pvc -A | grep stackstate # Check for disks
     ```
  7. Once these commands show there are no pods or disks login to the KOTS UI, Click on Version History and then click Redeploy

## Full reinstall 

{% hint style="warning" %}
This process will delete all of your StackState data and configuration
{% endhint %}

  1. Login to your server via `ssh`
  2. Run `helm ls -A` to view the current installed applications 
     You should see output similar to 
     ```
     [user@server ~]$ helm ls -A
     NAME      	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART           	APP VERSION
     stackstate	default  	2       	2022-03-21 14:24:43.826966101 +0000 UTC	deployed	stackstate-4.5.5	4.5.5
     ```
  3. Run `helm uninstall -n <namespace> stackstate` replacing `<namespace>` as appropriate. In the above example it is `default`
  4. Run `kubectl delete -n default pvc -l app.kubernetes.io/instance=stackstate` to remove the virtual disks
  5.  Run `kubectl delete -n default pvc -l app=stackstate-elasticsearch-master` to remove the ElasticSearch virtual disks.
  6. To check everything is removed correctly check there are no StackState pods or disks. This may take a few minutes
     ```
     # Example commands
     kubectl get pods -A | grep stackstate # Check for running pods
     kubectl get pvc -A | grep stackstate # Check for disks
     ```
  7. Once the pods and disks are deleted you can reset your KOTS configuration via the command `kubectl kots remove stackstate -n default --force` 
  8. You can now login to the KOTS UI and follow the [install instructions](/setup/install-stackstate/kots-install/install_stackstate.md) to reinstall