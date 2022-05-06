---
description: StackState Self-hosted v4.6.x
---

# Re-Install StackState

## Overview 

This page describes how to re-install a StackState instance running on KOTS. When reinstalling, it is possible to start over from scratch or keep the existing configuration.

## Before you start

Before you start the installation of KOTS and StackState, it is recommended to create a backup if needed.

## Re-install StackState and keep configuration 

{% hint style="warning" %}
This process will save the existing system configuration, but will delete any data that StackState has ingested.
{% endhint %}

  1. Log in to your server via `ssh`.
  2. Run `helm ls -A` to view the current installed applications. You should see output similar to this:
     ```
     [user@server ~]$ helm ls -A
     NAME      	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART           	APP VERSION
     stackstate	default  	2       	2022-03-21 14:24:43.826966101 +0000 UTC	deployed	stackstate-4.5.5	4.5.5
     ```

  3. Uninstall StackState using the command below. Replace `<namespace>` as appropriate - in the above example, the namespace is `default`:
     ```
     helm uninstall -n <namespace> stackstate
     ``` 

  4. Remove the virtual disks:
     ```
     kubectl delete -n default pvc -l app.kubernetes.io/instance=stackstate
     ```
  
  5. Remove the ElasticSearch virtual disks:
     ```
     kubectl delete -n default pvc -l app=stackstate-elasticsearch-master
     ```

  6. To check that everything has been removed correctly, confirm that there are no StackState pods or disks. This may take a few minutes:
     ```
     # Example commands
     kubectl get pods -A | grep stackstate # Check for running pods
     kubectl get pvc -A | grep stackstate # Check for disks
     ```
     
  7. When you have confirmed that there are no StackState pods or disks:
     1. Log in to the KOTS UI.
     2. Click **Version History**.
     3. Click **Redeploy**.

## Full reinstall 

{% hint style="warning" %}
This process will delete all of your StackState data and configuration.
{% endhint %}

  1. Log in to your server via `ssh`
  2. Run `helm ls -A` to view the current installed applications. You should see output similar to this:
     ```
     [user@server ~]$ helm ls -A
     NAME      	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART           	APP VERSION
     stackstate	default  	2       	2022-03-21 14:24:43.826966101 +0000 UTC	deployed	stackstate-4.5.5	4.5.5
     ```
  3. Uninstall StackState using the command below. Replace `<namespace>` as appropriate - in the above example, the namespace is `default`:
     ```
     helm uninstall -n <namespace> stackstate
     ```
  4. Remove the virtual disks:
     ```
     kubectl delete -n default pvc -l app.kubernetes.io/instance=stackstate
     ```
  5. Remove the ElasticSearch virtual disks:
     ```
     kubectl delete -n default pvc -l app=stackstate-elasticsearch-master
     ```
  6. To check that everything has been removed correctly, confirm that there are no StackState pods or disks. This may take a few minutes:
     ```
     # Example commands
     kubectl get pods -A | grep stackstate # Check for running pods
     kubectl get pvc -A | grep stackstate # Check for disks
     ```

  7. Once the pods and disks are deleted, reset the KOTS configuration:
     ```
     kubectl kots remove stackstate -n default --force
     ``` 
  8. Log in to the KOTS UI and follow the [KOTS install instructions](/setup/install-stackstate/kots-install/install_stackstate.md) to reinstall.