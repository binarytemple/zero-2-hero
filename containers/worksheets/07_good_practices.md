\pagebreak

# Best Practices

In this exercise we'll briefly explore some of the best practices that
should be used when building a Docker image. 


## HealthChecks

When we build an image, it would be nice to be able to embed a form of
verification to confirm that the container is running as we expect it
to. We can use 
HEALTHCHECK as a way to verify this. Using HEALTHCHECK we can specify
a command that defines if a container is _healthy_. 

First we are going to run a simple container that implements a
health-check endpoint. We are then going to run the command that we
would like to use as a health check. Finally, we will integrate the
healthcheck into the Docker image itself.

```
$ docker run -d -p 80:80 moredhel/healthcheck
```

We now have our image up and running, let's test out the endpoints.

```
$ curl -f localhost/healthz
healthy
```

We can see that everything is healthy, let's make it act unhealthy:

```
$ curl -f localhost/toggle
now False
$ curl -f localhost/healthz
curl: (22) The requested URL returned error: 400 BAD REQUEST
```

We don't want to have to manually monitor the health of every
container though, it would be better if we could keep the method for
checking the health alongside the container. Let's do that now.

We need to download the three files that were used to build this
image:

```
$ mkdir healthcheck && cd healthcheck
$ wget https://git.io/vd8YY -O app.py
$ wget https://git.io/v5Hml -O Dockerfile
$ echo "flask" > requirements.txt
```

There should now be 3 files present:

```
$ md5sum app.py
e5dbe544f9f1bf6f5496ca16b7a707e0  app.py
$ md5sum Dockerfile
fc40b425d68f4f2a90abc41a70dddd72  Dockerfile
$ md5sum requirements.txt
cfdea7934019617dc8e2d9a7ea631e00  requirements.txt
```

Now we can add our healthcheck into the Dockerfile

```
HEALTHCHECK --interval=1s CMD curl -f localhost/healthz || exit 1
```

### Note
Remember that only one service can run on a host port at a time, we
need to shut down our previous instance of our service `docker stop
$(docker ps -lq)`. 
If you get an error that looks like this:

```
docker: Error response from daemon: driver failed programming external connectivity on endpoint pensive_thompson (83f527ec61f37495ef02c9dac98832c25969cffe70a1beb64cbc0297b2b5d71d): Bind for 0.0.0.0:80 failed: port is already allocated
```

It means that there is already a container bound to the port that you
are trying to use and you need to stop the currently running container
before you may start your new instance.

we can now rebuild and run our container:


```
docker build -t healthcheck .
docker run -td -p 80:80 healthcheck
```

We can now check the health of the container just by inspecting its status.

```
docker ps
CONTAINER ID        IMAGE               COMMAND                 CREATED             STATUS                           PORTS                  NAMES
61d3670f81a6        c1f835592685        "python /data/app.py"   2 seconds ago       Up 1 second (health: starting)   0.0.0.0:8081->80/tcp   quizzical_hugle

```

Here we can see that our container is healthy. If we now make our
container unhealthy:

```
curl -f localhost/toggle
now False
```

```
docker ps
CONTAINER ID        IMAGE               COMMAND                 CREATED              STATUS                          PORTS                  NAMES
61d3670f81a6        c1f835592685        "python /data/app.py"   About a minute ago   Up About a minute (unhealthy)   0.0.0.0:8081->80/tcp   quizzical_hugle
```

It is possible to see the container starts failing health checks. When
3 healthchecks have failed (after 5 seconds), the container is put into the _unhealthy_ state.

## Setting environment variables

Sometimes it's useful to set environment variables that are different
in different environments. One such example would be to tell your
application what log level to run at. We can configure environment
variables that can be set when the container is built, and optionally
overriden when the container is run. We are going to continue using
the container that you have built, let's see what the value of the
_VAR_ variable is:

```
curl localhost/env/var
Traceback
...
```

Oops, it looks like the VAR variable hasn't been set. It's a good idea
to set a default value for any variables that are required by the
program.

Note that the output looks pretty bad, This is expected because we
have made assumptions about our environment which don't hold, so our
program has crashed. Our program expects an environment variable to be
present so let's ad a default value.

In the Dockerfile:

```
ENV VAR "default value"
```

As the variable is baked into the image, we will need to rebuild the
image before restarting the container (refer to earlier in this
document if you get stuck):

```
curl localhost/env/var
default value
```

Great, we now have our default environment setup. We now want to run
our application in our test environment with a different value for our
variable. It's a hassle to build another image just for testing, and
also bad practice because we want to use the same image both in
testing and production. Let's override the variable for only this
running container.

```
docker run -td -p 80:80 -e VAR="I have overriden the default" <your-image>
```

And one more time, we see what we have:

```
curl localhost/env/var
I have overriden the default
```

## EXPOSE ports

There is less to be done in this section as there aren't really too
many effects. It is worth noting that it is good practice as it serves
as documentation for anyone reading your Dockerfile. The purpose of
the EXPOSE keyword is to document the port(s) that the running container
is listening on.

The command to add it is:

```
EXPOSE 80
```

We can now inspect the image to see that the metadata has been
applied:

```
docker inspect <image> | grep 80
"80/tcp": {}
"80/tcp": {}
```


## Use the Cache

When developing code, it's always good to have builds complete
quickly. We can refactor our Dockerfile to make sure our builds
complete faster.

We can see that the `RUN apt-get update && apt install -y curl`
command is run after we install the dependencies for our application
(our application dependency file is _requirements.txt_)

We are not likely to change our system dependencies (needed for our
healthcheck) very regularly, so there is little point in rebuilding it
every time we change a line of code. We are less likely to add or
remove a dependency of the application (_requirements.txt_), so we
have that next. We finally add the source code as the final dependency
in the list as it is added the most frequently.

As an example, we can change a dependency:

```
echo "redis" >> requirements.txt
docker build .
```

We can see that we are doing unnecessary work, we are re-installing
_curl_.

Let's rewrite the Dockerfile so that stops happening:

```
FROM python:3

RUN apt-get update && apt install -y curl
COPY requirements.txt /
RUN pip install --no-cache-dir -r /requirements.txt

HEALTHCHECK --interval=5s CMD curl -f localhost/healthz || exit 1
ENV VAR testing
EXPOSE 80

COPY . /data

CMD ["python", "/data/app.py"]
```

Now we can edit our code, and change dependencies without having to
rebuild the underlying environment each time.
