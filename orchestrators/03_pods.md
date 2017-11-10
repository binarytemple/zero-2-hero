---
title: Kubernetes Essentials
revealOptions:
    transition: 'none'
    slideNumber: 'true'
---

## Creating and managing **Pods**

In this lab you will:

* Write a **Pod** configuration file.
* Create and inspect **Pods**.
* Interact with **Pods** using `kubectl`.

---

### What is a **Pod**?

* Collection of
  * Application container(s)
* With associated
  * Storage
  * Network
* Atomic unit of deployment and scaling

---

### Deploy application to Kubernetes
```
$ kubectl run hello-pod --image=nginx:1.12 --port=80

deployment "hello-pod" created
```

---

### Check **Deployment** and **Pod**

```
$ kubectl get deployment
NAME         DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
hello-pod   1         1         1            1           49s

$ kubectl get pod
NAME                          READY     STATUS    RESTARTS   AGE
hello-pod-2399519400-02z6l   1/1       Running   0          54s
```

---

### Creating a **Pod** manifest

An example Pod manifest:

```
apiVersion: v1
kind: Pod
metadata:
  name: hello-pod
  labels:
    app: hello-pod
spec:
  containers:
    - name: hello-pod
      image: nginx:1.12
      ports:
        - containerPort: 80
```

---

### Create the **Pod** using `kubectl`:

```bash
$ kubectl delete deployment hello-pod
$ kubectl create -f configs/pod.yaml
```

(note this is not the same yaml as the example)

---

### View **Pod** details

Use the `kubectl get` and `kubectl describe` to view details for the `hello-node` **Pod**:

```
$ kubectl get pods
```

```
$ kubectl describe pods <pod-name>
```

---

### Interact with a **Pod** remotely

* Pods get a private IP address by default.
* Cannot be reached from outside the cluster.
* Use `kubectl port-forward` to map a local port to a port inside the `hello-pod` pod.



---

Use two terminals.

* Terminal 1

```
$ kubectl port-forward hello-node 8080:8080
```

* Terminal 2

```
$ curl 0.0.0.0:8080
Hello World!
```

---

### Do it yourself
* Create an `nginx.conf` which returns a  
`200 "Hello Container Solutions"`.
* Create a custom Nginx image.
* Build the container.
* Create a **Pod** manifest using the image.
* Query the application using `curl` or a browser.
* Access the **Pod** on port 80 using port-forward.
* View the logs of the nginx container.

---

### Debugging

### View the logs of a **Pod**

Use `kubectl logs` to view the logs for the `<PODNAME>` **Pod**:

```
$ kubectl logs <PODNAME>
```

> Use the -f flag and observe what happens.

---

### Run an interactive shell inside a **Pod**

Execute a shell in a **Pod**, like in Docker:

```
$ kubectl exec -ti <PODNAME> /bin/sh
```

----

[Next up Services...](./04_services.md)

