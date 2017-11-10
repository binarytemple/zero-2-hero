---
title: Kubernetes Essentials
revealOptions:
    transition: 'none'
    slideNumber: 'true'
---

## Creating and Managing **Services**

In this section you will create a `hello-node` service to "expose" the `hello-node` Pod. 

You will learn how to:

* Create a **Service**.
* Use label and selectors to expose a limited set of **Pods** externally.

---

### Introduction to **Services**

* Stable endpoints for **Pods**.
* Configured via labels and selectors.

---

### **Service** types

* `ClusterIP` (Default) Exposes the service on a cluster-internal IP.

* `NodePort` Expose the **Service** on a specific port on each node.

* `LoadBalancer` Use a loadbalancer from a Cloud Provider. Creates `NodePort` and `ClusterIP`.

* `ExternalName` Connect an external service (CNAME) to the cluster.

---

### Create a Service

Explore the hello-node **Service** configuration file:

```
apiVersion: v1
kind: Service
metadata:
  name: hello-node
spec:
  type: NodePort
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
    nodePort: 30080
  selector:
    app: hello-node
```

Setting `nodePort` is optional. If not set, a random high port is assigned.

---

Create the hello-node **Service** using `kubectl`:

```
$ kubectl create -f configs/service.yaml
```

---

### Query the **Service**

Use the IP of any of your nodes.

```
$ kubectl get nodes -o wide
...
$ curl [cluster-node-ip]:30080
```

---

### Explore the hello-node **Service**

```bash
$ kubectl get services hello-node
```

```bash
$ kubectl describe services hello-node
```

---

### Using labels

Use `kubectl get pods` with a label query, e.g. for troubleshooting.

```
$ kubectl get pods -l "app=hello-node"
```

Use `kubectl label` to add labels.

```
$ kubectl label pods hello-node 'secure=disabled'
```
... and to modify
```
$ kubectl label pods hello-node "app=goodbye-node" --overwrite
$ kubectl describe pod hello-node
```

---

View the endpoints of the `hello-node` **Service**:

(Note the difference from the last call to `describe`)

```
$ kubectl describe services hello-node
```

---

### Do it yourself

* Create a service for an nginx pod.
* Expose port 80 to a static nodePort 31000.
* Access the service using `curl` or a browser.

----

### Cleanup

```
$ kubectl delete po --all
$ kubectl delete svc --all
```

----

[Next up Deployments...](./05_deployments.md)
