---
title: POC Installation
kind: Documentation
---

# Installing StackState in a POC configuration

Proof-of-concept \(POC\) mode is StackState's installation mode best suited for POCs. It requires only one machine, and can handle \(almost\) the same load as a regular production setup. The only limitations are that the system cannnot handle lots of perpetual data \(like &gt;10 agents or a big perpetually running AWS landscape\).

## Requirements

Before starting the installation, ensure your system meet StackState's POC setup [installation requirements](requirements.md).

## Installing StackState in a POC configuration

**NOTE**: This installation configuration is only available since StackState 4.0.0.

For a POC setup of StackState, simply follow the instructions for [Installing StackState](install_stackstate.md), using `POC` as the SETUP configuration parameter.

## Starting and Stopping

### SystemD service

The RPM and DEB packages install SystemD services for StackState and StackGraph. StackState can be started with `sudo systemctl start stackstate.service` this will also start service StackGraph. Starting StackState can take some time.

After starting processes are complete, the service is available at `http://<stackstate_hostname>:7070`.

### Stopping StackState

StackState can be stopped by `sudo systemctl stop stackstate.service`. StackGraph is not automatically stopped when stopping StackState, StackGraph can be stopped by `sudo systemctl stop stackgraph.service`.

### StackState Status

Checking the service status can be done with `sudo systemctl status stackstate.service` and `sudo systemctl status stackgraph.service`.

