# Microservices

---

## Building a new Microservice

Check initial code

```bash
cd ex1/
vi main.go
```

---

## Build and Run Docker images

```bash
docker build -t microservices-demo/deals .
docker run -d --publish 8080:8080 --name deals-dev microservices-demo/deals
```

---

## Call service

Docker for Mac

```bash
curl localhost:8080/deals?id=1
```

Docker Machine
```bash
curl $(docker-machine ip default):8080/deals?id=1
```

---

## Review

* Questions?
* [On to orchestrators...](../orchestrators/runsheet.md)
