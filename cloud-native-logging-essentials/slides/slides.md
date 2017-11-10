---
title: Cloud Native Logging Essentials
revealOptions:
    transition: 'none'
    slideNumber: 'true'
---

# Cloud Native Logging Essentials

---


## Outline

* The Purpose of logging

* Traditional vs Cloud Native Logging

* Logging in k8s

---


### The Purpose of logging

* Help Troubleshooting

* Incident response

* Continuous Improvement

---


## Traditional Logging vs Cloud Native Logging


---

### Traditional Logging

* Monolithic applications running on a fixed server

* Logging relies on **configuration**

  * Locations - `/var/log/apache/access.log`
  
  * Formats - XML, JSON
  
  * Log rotation policies
    
* Traditional logging is painful - no standardization!

---

###	Cloud Native Logging

*A truly cloud-native application never concerns itself with routing or storage of its output stream" ~ Kevin Hoffman - Beyond the Twelve Factor App*

---

### Cloud Native Logging
	
* Why?

  * Elastic Scalability
  
  * You don't know where your cloud native app will run
  
  * You also don't know and should not care where the logs are written to

---

		
### Cloud Native Logging

* Containers are ephemeral - flexible locations 

* Relies on **conventions**

  * Your app should always log to *stdout* and *stderr* - k8s takes care of the rest

---

### Cloud Native Logging

* More machines...

* More logs...

* More communication...

*Monitor the small things, and use aggregation to see the bigger picture*


---


## Logging in K8s


---


### Logging in k8s

* Node level logging

  * Store logs on the node

* Cluster level logging

  * Store logs on a backend outside the cluster

---

### Node level logging

* Pod logs to stdout and stderr

* Docker has logging driver that writes JSON file


---


### Node level logging

* Inspecting logs of a pod

  * `kubectl logs $POD`

  * If the pod dies the logs die with it


---


### Cluster level logging

* Install a node level logging agent like Fluentd

* Use a sidecar container

* Push logs directly to a backend


---


### Cluster level logging

* Fluentd can aggregate and route logs

* Top level CNCF project

* 500+ plugins: AWS S3, Hadoop, Elasticsearch


---

### Cluster level logging

* Example setup:

  * Deploy Elasticsearch + Kibana 

  * Create Fluentd image with configuration for Elasticsearch 

  * Deploy on each node using a **DaemonSet**

  * Logs are routed to Elasticsearch

---
