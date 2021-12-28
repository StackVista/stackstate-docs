---
title: Naming Guide
kind: Documentation
aliases:
  - /configuring/naming_guide/
listorder: 15
---

# Naming guide

{% hint style="warning" %}
**This page describes StackState version 4.4.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/configure/topology/naming_guide).
{% endhint %}

## Overview

Getting the most out of StackState becomes easier when components are easy to find. What things are called helps a lot with creating that clarity. To help when naming your new layers or components, this page provides a list of examples used within StackState. Often already provided to you within StackPacks.

## Layers

Are easiest to use when they resemble the layers of your infrastructure. In settings the ordering can be changed. The following are examples of layers used in StackPacks.

* Processes
* Containers
* Hosts
* Applications
* Databases
* Servers
* Storage
* Network

## Component types

Components should be generic enough to group similar components but specific enough to clearly identify what they are. The following are examples of component types used in StackPacks.

* application
* database
* docker container
* host
* java
* kubernetes container
* kubernetes deployment
* kubernetes host
* kubernetes node
* kubernetes pod
* kubernetes process
* kubernetes replicaset
* kubernetes service
* mysql
* postgresql
* postgresql worker
* process
* server
* tomcat

## Relations

Relation names depend heavily on how much is known about the relation. Do we only know these nodes are connected or de we know why they are connected. Make sure the name reflects what you know for a fact about the relation. The following are examples of relations used in StackPacks.

* connection
* depends on
* is connected to
* is hosted on
* is used by
* located in
* runs on
* runs in
* used by
* uses
* uses database
* uses service

