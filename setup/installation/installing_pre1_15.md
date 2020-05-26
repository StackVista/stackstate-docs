---
title: Install StackState before 1.15.0
kind: Documentation
---

### Requirements

Before starting the installation, ensure your system(s) meet StackState's [installation requirements](/setup/installation/requirements/).

### Installing

**NOTE**: Installing StackState on versions older than 1.14.5 requires an alternative procedure, see ([Installing before 1.14.5](/setup/installation/installing_pre1_14_5)).

#### Install using the RPM distribution

**NOTE**: StackState requires **JDK 8** to run. This version of Java must already be present on the installation machine and will not automatically be installed by the `rpm` command.

`LICENSE_KEY=<<<LICENSE_KEY>>> RECEIVER_BASE_URL="http://<<<HOST>>>:7077/" API_KEY=<<<API_KEY>>> SETUP=<<<PRODUCTION|DEVELOPMENT>>> rpm -i <stackstate>.rpm`

* `<<<LICENSE_KEY>>>`: Your license key provided by StackState.
* `<<<HOST>>>`: Public DNS resolvable hostname external services can use to connect to
  the installed StackState instance.
* `<<<API_KEY>>>`: Secret key StackState agents must use to authenticate.
* `SETUP`: Choose whether to install in production or development mode. These setups
  should meet the [system-requirements](/setup/installation/requirements).

#### Install using the DEB distribution

**NOTE**: StackState requires **JDK 8** to run. This version of Java must already be present on the installation machine and will not automatically be installed by the `dpkg` command.

`LICENSE_KEY=<<<LICENSE_KEY>>> RECEIVER_BASE_URL="http://<<<HOST>>>:7077/" API_KEY=<<<API_KEY>>> SETUP=<<<PRODUCTION|DEVELOPMENT>>> dpkg -i <stackstate>.deb`

* `<<<LICENSE_KEY>>>`: Your license key provided by StackState.
* `<<<HOST>>>`: Public DNS resolvable hostname external services can use to connect to
  the installed StackState instance.
* `<<<API_KEY>>>`: Secret key StackState agents must use to authenticate.
* `SETUP`: Choose whether to install in production or development mode. These setups
  should meet the [system-requirements](/setup/installation/requirements).
