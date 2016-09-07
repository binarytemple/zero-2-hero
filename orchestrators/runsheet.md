# Prepare the infrastructure
Clone the repo [https://github.com/ContainerSolutions/microservices-workshop](https://github.com/ContainerSolutions/microservices-workshop)

---

Minikube isn't shipped with weave installed so we need to install it.

---

### Start minikube  
`minikube start`

### ssh into the VM

username `docker`  
password `tcuser`

```bash
ssh docker@$(minikube ip) 
sudo wget -O /usr/local/bin/scope https://git.io/scope
sudo chmod a+x /usr/local/bin/scope
sudo scope launch
exit
```
This will download and start weave scope

---

### Lauch the application
`kubectl create -f wholeWeaveDemo.yaml`

---

### Access the front-end
`kubectl describe svc front-end` to find out which port the front-end is listening on
 and the `open http://$(minikube ip):<port>`

![svc](svc.png)

---

Or simply 🤓
```bash
$open http://`(minikube ip):$(kubectl describe service front-end \ 
| awk '$1 == "NodePort:" {print $3}' | cut -d/ -f1)
```
This will open the front-end with the default browser
### Access weave 
`open http://$(minikube ip):4040` 

---

## Review

* Questions?
* [On to Networking...](../networking/runsheet.md)
