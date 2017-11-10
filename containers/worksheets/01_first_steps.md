# First Steps with Docker

You should either have access to a VM with Docker installed, or use
http://play-with-docker.com for this exercise.

To begin with, type:

```
 $ docker run debian echo hello world
```

(Don't type the $, it's intended to represent your command prompt).

You should get output similar to:

```
Unable to find image 'debian:latest' locally
latest: Pulling from library/debian
693502eb7dfb: Pull complete
Digest: sha256:52af198afd8c264f1035206ca66a5c48e602afb32dc912eb...
Status: Downloaded newer image for debian:latest
hello world
```

Run the exact same command again and the output should be a lot cleaner and
faster:

```
$ docker run debian echo hello world
hello world
```

So what's happened here? Docker has spun up a new container based on the image
we specified (`debian`) and asked it to execute the command `echo hello world`.
Once the container had executed the command, Docker stopped the container. A
Docker container will always stop when the main process (PID 0) completes, even
if other processes are still running.

The first time around, Docker didn't have a copy of the `debian` image, so it had
to download a copy.

It's worth considering for a moment how much longer this would have taken if we
were using traditional VMs - spinning up a new VM would likely have taken a
minute or two and downloading a new image could easily have taken much longer.
We'll look at how these speed benefits are realised later.

For now, let's look at some more useful examples. Try running:

```
$ docker run -it debian bash
```

This time we've specified the flags `-i` and `-t` which will give us an
interactive terminal inside the container. This should look something like:
```
root@14efb4f27237:/#
```

Try running simple commands such as `ls`, `uname`, `ps`, `hostname` and `touch`.

Note that changes you make in a container do not affect the host system, in the
same way as a VM. Try:

```
root@14efb4f27237:/# echo "in a container" > /testfile
root@14efb4f27237:/# cat /testfile
in a container
```

Now let's leave the container. The easiest way is just to type exit:

```
root@14efb4f27237:/# exit
```

Note that the file we created does not exist on the host:

```
$ cat /testfile
cat: can't open '/testfile': No such file or directory
```

Try starting a new container and looking for the file:

```
$ docker run -it debian bash
root@68cb1624d4cb:/# cat /testfile
cat: /testfile: No such file or directory
```

Again, it's not there — each container gets it own filesystem that is completely
separate from other containers and the host. Later on, we'll see how we can
share files between containers and the host.

Let's have a look at something a bit more useful. Exit from the last container
and try running the following command:

```
root@68cb1624d4cb:/# exit
$ docker run --name web -d -p 8000:80 nginx
...
```

This time we've used the `nginx` image — a webserver — and the `-d` flag to
start the container in the background rather than taking over our terminal.
We've also taken the opportunity to give the container a name — "web". We can
see information on all the running containers on our host by using the `docker
ps` or `docker container ls` commands (they are synonymns for each other):

```
$ docker container ls
CONTAINER ID  IMAGE  COMMAND                  CREATED...
a31dae86c263  nginx  "nginx -g 'daemon ..."   2 hours ago
```

You can also see stopped containers by providing the `-a` flag:

```
$ docker container ls -a
CONTAINER ID  IMAGE   COMMAND                  CREATED...
a31dae86c263  nginx   "nginx -g 'daemon ..."   2 hours ago
68cb1624d4cb  debian  "bash"                   2 hours ago
5e7818911284  debian  "bash"                   3 hours ago
```

Now try running:

```
$ curl localhost:8000
<!DOCTYPE html>
<html>
...
```

If you know the IP address of your Docker host, you should also be able to visit
this page in a webbrowser (if you're using Play With Docker there should be a
link at the top of the page with the number 8000).

This example shows how we can run a simple application in Docker - in this case
a webserver - and have it serve traffic to clients by exposing ports using the
`-p` flag. Our example exposed port 80 inside the container, which Nginx is
listening on, to port 8000 on the host.

We can see what's happening in the container with `docker logs`:

```
$ docker logs web
172.17.0.1 - - [06/Mar/2017:13:40:03 +0000] "GET / HTTP/1.1" 200..
```

If you need to get an interactive terminal inside a container running in the
background (e.g. for debugging), use the `docker exec` command:

```
$ docker exec -it web bash
root@a31dae86c263:/# cd /usr/share/nginx/html
root@a31dae86c263:/usr/share/nginx/html# ls -l
total 8
-rw-r--r-- 5 root root 537 May 30 13:03 50x.html
-rw-r--r-- 5 root root 612 May 30 13:03 index.html
root@a31dae86c263:/usr/share/nginx/html# exit
exit
```

Finally, we can stop the running container with the `stop` command:

```
$ docker stop web
```

And we can remove containers with the `rm` command:

```
$ docker rm web
```

## Bonus Task

See if you can get a Redis database working in a container (if you haven't heard
of it, Redis is a simple in-memory key-value store). Bonus points for
successfully managing to use the `redis-cli` within the container to
insert/return data.
