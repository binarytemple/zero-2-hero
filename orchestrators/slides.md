---
title: Kubernetes Essentials
revealOptions:
    transition: 'none'
    slideNumber: 'true'
---

# Kubernetes Essentials

---

### What will you learn?

- Slides
  - Orchestration
  - Kubernetes core concepts
  
- Exercises
  - Managing cloud native apps with `kubectl`

---

## What is Orchestration?

&nbsp;

<blockquote>
"The planning or coordination of the elements of a situation to produce a desired
effect, especially surreptitiously"
</blockquote><!-- .element: class="fragment" data-fragment-index="2" -->

Oxford English Dictionary<!-- .element: class="fragment" data-fragment-index="2" -->

---

<blockquote>
"The planning or coordination of **the elements of a situation** to produce a desired
effect, especially surreptitiously"
</blockquote>

---

## Elements

 - Containers
 - Hosts
 - Networking

---

<blockquote>
"The planning or coordination of the elements of a situation to **produce a desired
effect**, especially surreptitiously"
</blockquote>

---

## Desired Effect

 - Running application
 - Automatically scale
 - Fault tolerant
   - failover, node rebalancing, health checks
 - Use resources efficiently
 - Little manual intervention

---

<blockquote>
"The planning or coordination of the elements of a situation to produce a desired
effect, **especially surreptitiously**"
</blockquote>

---

## Surreptitiously

<blockquote>
"In a way that attempts to avoid notice or attention; secretively"
</blockquote>

Oxford English Dictionary

---

## Surreptitiously

 - Should happen in the background
 - User doesn't need to details
 - Complexity is hidden

---

## How important is orchestration?

 - Might not need it for small apps
 - No orchestration == manual orchestration
 - Manually place containers, network, scale, check, update

---

## Common Components

 - Container Runtime
 - Resource Manager
 - Scheduler
 - Service Discovery
 - Advanced Networking

---

## Container Orchestrators

 - Kubernetes

 - Mesos

 - Docker Swarm Mode

 - Plus others
   - Nomad, PaaSs...

---

## Side note - The Borg/Omega Papers

 - Influential papers from Google
 - Lessons learnt from 10 years with containers
 - Both high-level and technical reports
 - Kubernetes, Docker Swarm and Nomad 

---

### Kubernetes

* Open Source container orchestrator created by Google
* Now part of Cloud Native Computing Foundation (CNCF) 
* Popular: 27K stars on Github
* Often shortened to k8s

---

## Kubernetes

 - Based on Google's experience running containers
 - Bakes in various features
   - Load-balancing, secret management
 - Opinionated
   - Impact on application design

---

## Core Concepts

 - Pods
 - Flat networking space
 - Labels & Selectors
 - Services
 - Deployments
 - ReplicaSets
 - Namespaces

---

### Architecture Diagram


<img src="img/kubernetes-architecture.png">

---

<img src="img/arch.png" width="800">

---

<img src="img/control_plane.png" width="800">

---

<img src="img/node.png">

---

### Master

* api-server
 * Provides outbound Kubernetes REST API
 * Validates requests
 * Saves cluster state to etcd

---


### Master

* controller-manager
  * Runs "control loops"
  * Regulates the state of the system
  * Watches cluster state through the apiserver
  * Changes current state towards the desired state
     - e.g. checks correct number of pods running

---


### Master

* Scheduler
  - Selects node on which to run a pod

---

### Master

* etcd

 - Distributed, consistent key-value store for shared configuration and service discovery

---


### Node

* kubelet
  * Agent that runs on each node
  * Takes a set of `PodSpecs` from API server 
  * Starts containers to fulfill specs
  * Exposes monitoring data

---


### Node

* kube-proxy
  * Implements service endpoints (virtual IPs)
  - iptables

---

## Pods

 - Groups of containers deployed and scheduled together
 - Atomic unit
 - Containers in a pod share IP address
 - Single container pods are common
 - Pods are ephemeral

---

## Flat networking space

 - All pods, across all hosts, are in the same network space
   - Can see each other without NAT
 - Simple cross host communication

---

## Labels

 - K/V pairs attached to objects 
    - e.g: "version: dev", "tier: frontend"
 - Objects include Pods, ReplicaSets, Services
 - Label selectors then used to identify groups
 - Used for load-balancing etc

---

## Selectors

 - Used to query labels
   - environment = production
   - tier != frontend
 - Also set based comparisons
   - environment in (production, staging)
   - tier notin (frontend, backend)

---

## Services

 - Stable endpoints addressed by name
 - Forward traffic to pods
 - Pods are selected by labels
 - Round-robin load-balancing
 - Separates endpoint from implementation

---

## Service types

* ClusterIP (default)
  - Uses internal IP for service
  - No external exposure

* NodePort
  - Service is externally exposed via port on host
  - Same port on every host
  - Port automatically chosen or can be specified

---

## Service Types

* LoadBalancer
  - Exposes service externally
  - Implementation dependent on cloud provider

* ExternalName
  - For forwarding to resources outside of k8s

---

## Service Example

```
apiVersion: v1
kind: Service
metadata:
  name: railsapp
spec:
  type: NodePort
  selector:
    app: railsapp
  ports:
    - name: http
      nodePort: 36000
      port: 80
      protocol: TCP
```

---

## Deployments & ReplicaSets

 - ReplicaSets monitor status of Pods
   - define number of pods to run 
   - start/stop pods as needed
 - Deployments start ReplicaSets
 - Rollout/Rollback & Updates

---

## Dashboard

* Simple Web User Interface

* Good *high-level* overview of the cluster

* Can drill down into details

* Useful for debugging

---

### Manifests

 - Used to define resources
 - Specified in YAML or JSON

---


## Manifests

```
apiVersion: v1
   kind: Pod
   metadata:
     name: hello-node
     labels:
       app: hello-node
   spec:
     containers:
       - name: hello-node
         image: hello-node:v1
         ports:
           - containerPort: 8080
```



---

## Namespaces

 - Resources can be paritioned into namespaces
 - Logical groups
 - System resources run in their own namespace
 - Normally only use one namespace

---

## Jobs

 - Typically for performing batch processing
 - Spins up short-lived pods
 - Ensures given number run to completion

---

### And more

 - Annotations
 - Daemon Sets
 - Horizontal Pod Autoscaling
 - Ingress Resources
 - Namespaces
 - Network Policies
 - Persistent Volumes
 - Stateful Sets
 - Resource Quotas
 - Secrets
 - Security Context
 - Service Accounts
 - Volumes
