---
title: Kubernetes Essentials
revealOptions:
    transition: 'none'
    slideNumber: 'true'
---

### Setting up and using the **User Interface**

In this section we will

* learn how to setup the Kubernetes Dashboard
* improve understanding of relationships between resources
* debug from the Dashboard

---

### Kubernetes Dashboard

The Kubernetes Dashboard is a *General-purpose web UI for Kubernetes clusters*.

---

### Why?

* Manage and troubleshoot running applications
* Manage the cluster itself
* Deploy containerised applications using a UI (not recommended for production)

---

### Setting up the Dashboard

Luckily Google Container Engine (GCE) has already preconfigured it for us.
We just need to setup the proxy so we can access it.

```
$ kubectl proxy --address 0.0.0.0 --port 8001 --accept-hosts='^*$'
```

---

### Creating a Deployment

We want to create the following deployment...

```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: wp-hello
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: wp-hello
    spec:
      containers:
      - name: wp-hello
        image: wordpress:4.8.0
        ports:
        - containerPort: 80
```

---

### Navigating to the Dashboard

Let's use the Dashboard for this...

First, we navigate to: [http://<your-vm-ip>:8001/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:/proxy/#!/namespace?namespace=default]()
(your vm IP is the one you use to SSH).

---

### creating a deployment

* Press the '_Create_' button in the top right
* select 'Upload a YAML or JSON file'
* navigate to _kubernetes-essentials/config/dashboard-v1.yaml_
* Click on the __Workloads__ tab on the left hand side to see progress.

---

### Look through the UI

We can see that a Deployment is being created.

The Deployment has created a ReplicaSet that is responsible for managing the lifecycle of it's Pods.

---

### Look through the UI

The status of each Pod is also available. They should be saying 'Waiting: Container Creating'.

Refresh the page, and see the updated states of the Containers.

We can see the Memory and CPU load in each pod after a short while.

---

### Changing the Image

We are now going to try and deploy a broken image, to see what the Dashboard tells us

This expands on the _Do it yourself_ section of the last exercise.

---

### Updating a Deployment through the Dashboard

* Click on the Deployment `wp-hello`
* Click on the Edit button in the top right
* search for `image` in the search field
* replace `wordpress:4.8.0` with `wordpress:broken`

---

### View 

Refresh the page to get an up to date snapshot of the cluster state

We can immediately see an error.

```
Failed to pull image "wordpress:broken"
```

The image pull has failed.

The error has propogated from the Pod, up through ReplicaSet to the Deployment.

---

### Things to note

The image update has stopped rolling out.

This is due to the default Rolling Release Deployment strategy.

As seen in the previous exercise.

---

### Fixing the issue

* Click on the Deployment `wp-hello`
* Click on the Edit button in the top right
* search for `image` in the search field
* replace `wordpress:4.8.0` with `wordpress:4.8-php7.1-fpm`


---

### Verify

Roll back to a known working version. have we?

Verify in the UI that everything is green.

has the broken ReplicaSet been unscheduled?

---

### Cleaning up

* Click deployment
* select `wp-hello`
* Delete

---

### Do it yourself

* Create a **Deployment** for one nginx:1.12-alpine container.
* Scale the **Deployment** up to 3.
* Validate the scaling was successful.
* Delete a Pod, and see what happens.
* Delete the ReplicationSet and see what happens.
* Cleanup
