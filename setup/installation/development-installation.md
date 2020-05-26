---
title: Development Installation
kind: Documentation
---

Development mode is StackState's installation mode for a small installation to do experiments
on. It requires only one machine,
but it is limited to 1000 components per view, due to the limited setup. This is recommended for small trials. Production mode is what we recommend for bigger
proof-of-concept projects or in an actual production environment.

### Requirements

Before starting the installation, ensure your system meets StackState's development setup  [installation requirements](/setup/installation/requirements/).

### Installing StackState in a development configuration

**NOTE**: Installing StackState on versions older than 1.15.0 requires an alternative procedure, see ([Installing before 1.15.0](/setup/installation/development-installation_pre1_15)).

For a development setup of StackState, simply follow the instructions for
[Installing StackState](/setup/installation/install_stackstate), using `DEVELOPMENT` as the SETUP configuration parameter.

### Starting and Stopping

#### SystemD service

The RPM and DEB packages install SystemD services for StackState and StackGraph. StackState can be started with
`sudo systemctl start stackstate.service` this will also start service StackGraph. Starting StackState can take some time.

After starting processes are complete, the service is available at `http://<stackstate_hostname>:7070`.

#### Stopping StackState

StackState can be stopped by `sudo systemctl stop stackstate.service`. StackGraph is not automatically stopped when stopping StackState, StackGraph can be stopped by `sudo systemctl stop stackgraph.service`.

#### StackState Status

Checking the service status can be done with `sudo systemctl status stackstate.service` and `sudo systemctl status stackgraph.service`.
