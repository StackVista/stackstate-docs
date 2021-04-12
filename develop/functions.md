---
title: Functions
kind: Documentation
description: Extending StackState's capabilities using functions.
---

# Extending StackState with functions


{% hint style="warning" %}
**This page describes StackState version 4.x.**

The StackState 4.0 version range is End of Life (EOL) and **no longer supported**. We encourage customers still running the 4.0 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

StackState is built to deal with a wide variety of different situations. StackState comes with functions to stay flexible enough to account for different types of logic.

Functions are predefined scripts that transform input into an output. Functions are called by StackState on-demand. For example, when a component changed state, some new telemetry flowed in or when the user triggered an action.

## Packaging Functions

Functions give power-users the ability to customize StackState fully. However, everyday users of StackState should not need to know that they exist.

StackPacks pre-package functions and automatically install functions on StackState whenever the StackPack gets installed. You can develop your function in StackState. When you are confident that it does what you want, you can export it and package it with a StackPack. Read more about it on [how to create StackPacks page](../integrations/introduction.md).

## Async vs sync functions

Traditionally functions in StackState were written in a synchronous blocking manner. This limited the capability of what these functions can achieve and how many of these functions can be run in parallel. StackState started supporting a new kind of function called _async_ functions that allow anyone to access the [Script APIs](scripting/). The following functions have started supporting the _async_ mode and no longer allows you to edit the older \(legacy\) synchronous function anymore, though the older synchronous functions will remain working.

* Propagation functions \(since 1.15.1\)

The following functions do not support async mode:

* Check function
* Baseline function
* View state configuration function
* Event handler function
* Id extractor function
* Component mapper function
* Relation mapper function

