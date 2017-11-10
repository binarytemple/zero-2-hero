---
title: Spring PetClinic on Kubernetes
revealOptions:
    transition: 'none'
    slideNumber: 'true'

---

## Spring PetClinic on Kubernetes

---

## Overview

You should leave here knowing:

 - How to build Java containers
 - How to deploy Java apps to Kubernetes
 - Unique challenges in running Java in a container environment

---

## Prerequisites

 - Java and Spring knowledge
 - Docker essentials
 - Kubernetes essentials
 - Access to a GKE cluster

---

## Docker and the JVM - the Good

 - Java runs on Linux, so it can easily run in a Docker container
 - Good support - base images for all JDK, JRE and Maven versions

---

## Building Java apps

 - Just use Maven or any other build tool
 - Maven cache will not be used
 - But Docker layer caching makes up for it
 - Supported base image for Maven

---

## Docker and the JVM - the Bad

 - Java memory management designed be single process on machine
 - No more sharing of JVM by deploying to Java App Server (Tomcat)
 - JVM before version 9 doesn't respect container memory limits
 - Runs out of memory if *any* limit is set on container
 - Without limit Java process just uses more and more memory without ever returning to OS

---

## Solutions

 - Manually configuring Xmx flag to about 50% of available container memory
 - Fabric8 base image contains script to set memory limits correctly
 - Java 9 will correctly adjust JVM memory usage to container limit
 
 https://hub.docker.com/r/fabric8/java-jboss-openjdk8-jdk/
 
 https://developers.redhat.com/blog/2017/03/14/java-inside-docker/