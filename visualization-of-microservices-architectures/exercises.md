---
title: Visualization of Microservices Architectures
revealOptions:
    transition: 'none'
    slideNumber: 'true'
---

# Visualization of Microservices Architectures

---

## Outline

* This module only has a single exercise

* We will install the Weave Sock Shop

* Then we will install Weave Scope to visualize it

---

## Installing Weave Sock Shop

* Check out the Sock Shop code

```
git clone https://github.com/microservices-demo/microservices-demo
```

Read the documentation located at: https://microservices-demo.github.io/microservices-demo

To start the sock-shop, follow the instructions at: https://microservices-demo.github.io/microservices-demo/deployment/kubernetes-start.html

---


## Installing Weave Scope

* Download the k8s manifest for Scope

```
wget "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')" -O weave-scope.yaml
```

* Deploy Scope

```
kubectl apply --namespace kube-system -f weave-scope.yaml
```

Now take a look around. Try:

* Viewing instances
* Browsing to the command promt on an instance
* Killing and instance
* Scaling an instance

If you get stuck, check out the documentation at: https://www.weave.works/docs/scope/latest/features/
