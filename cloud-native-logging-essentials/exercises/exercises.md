---
title: Cloud Native Logging Essentials
revealOptions:
    transition: 'none'
    slideNumber: 'true'
---

# Cloud Native Logging Essentials - Exercises

---

## Outline

1. Inspecting logs with `kubectl logs`

2. Centralized Log Aggregation with Fluentd, Elasticsearch and Kibana


---


## 1. Inspecting logs with `kubectl logs`


---


### Outline


* We will deploy a pod, deployment and service

* Inspect the logs

* Make changes and inspect the logs again


---


### Preparation

* Go to `training-modules/cloud-native-logging-essentials/exercises`

* This directory contains this slide deck

* The `files` directory contains code, k8s manifests and a `Dockerfile`

* Edit `deployment.yaml` and replace the string `$USER` with your VM username

---


### Build the image


```
gcloud docker -- build -t eu.gcr.io/$USER/server -f Dockerfile .
```


---


### Push the image

```
gcloud docker -- push eu.gcr.io/$USER/server
```


---


###  Create a deployment


```
kubectl create -f deployment.yaml
```


---


### Check the logs

```
kubectl logs $POD_NAME
```

If the pod's `STATUS` is `ContainerCreating` you won't see logs yet

---


### Change the code

* Add **`console.log(request)`** to **`server.js`** inside the request loop

* Hack, hack


---


### Delete the deployment


```
kubectl delete deployment server
```


---


### Build & push again

```
gcloud docker -- build -t eu.gcr.io/$USER/server -f Dockerfile .
```

```
gcloud docker -- push eu.gcr.io/$USER/server
```

---


### Now deploy the deployment again


```
kubectl -f create deployment.yaml
```


---


### Now follow the logs


```
kubectl logs -f $POD_NAME
```


---

### Enable port forwarding

* SSH into the VM with another session

* Port forwarding in the background

```
kubectl port-forward $POD_NAME 8080:8080 &
```


---


### Hit the server with curl

```
curl localhost:8080
```

---


### Now check the logs in the other terminal


---


## Centralized Log Aggregation 

#### with **Fluentd**, **Elasticsearch** and **Kibana**


---


### Outline


* In this exercise you will install Fluentd, Elasticsearch and Kibana

* Then you can experiment with the setup and search logs in Kibana


---


### Deploying Fluentd

* The cluster already has a Fluentd that is integrated with GCP

```
kubectl --namespace=kube-system get ds
```


---


### Deploying Fluentd
 
 
* We will deploy Fluentd with Elasticsearch config

```
kubectl create -f fleuntd-daemonset.yaml
```

* Check that it is running

```
kubectl --namespace=kube-system get ds
```


---


### Deploying Elasticsearch

* Deploy the ReplicationController and Service

```
kubectl create -f elasticsearch-rc.yaml
```

```
kubectl create -f elasticsearch-service.yaml
```


---


### Deploying Elasticsearch

* Check if it is up
  
```
kubectl --namespace=kube-system get pods
```  

* Copy the `EXTERNAL-IP` from the output

* Hit the endpoint

```
curl $EXTERNAL-IP:9200
```


---


### Deploy Kibana

* Deploy the ReplicationController and Service

```
kubectl create -f kibana-rc.yaml
```

```
kubectl create -f kibana-service.yaml
```


---


### Deploying Kibana

* Check if it is up
  
```
kubectl --namespace=kube-system get pods
```  

* Copy the `EXTERNAL-IP` from the output

```
kubectl get pods --namespace=kube-system
``` 

* Open the UI in the browser at `$EXTERNAL-IP:5601`


---


### Experiment!

* Now deploy pods from the previous exercise or your own app

* Go to Kibana 'Discover' and find logs

* Kibana Docs https://www.elastic.co/guide/en/kibana/current/index.html