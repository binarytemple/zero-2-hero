\pagebreak

# Docker Volumes

Docker volumes can be used in a lot of different ways. First let's look at using
the `-v` flag to `docker run`.

Try the following:

```
$ echo "this is a file on the host" > /tmp/hostfile
$ docker run -v /tmp/hostfile:/containerfile \
         debian cat /containerfile
this is a file on the host
```

What's happened here is we've mounted the file `/tmp/hostfile` on the host as
the file `/containerfile` inside the container. We can do the same with
directories and binaries, so you can make anything on the host accessible to the
container (but be careful with file permissions and dynamic libraries). The path
must always be fully qualified, so you will often see files and directories in
local directories prefixed with `$PWD` or `$(pwd)`. 

Let's try adding a directory. Docker will create it for us if it doesn't exist:

```
$ docker run -v /tmp/hostdir:/condir debian \
    sh -c 'echo "hello from containerland" > /condir/containerfile'
$ cat /tmp/hostdir/containerfile
hello from containerland
```

So we can create files in the container and they will appear immediately on the
host. This is because it is in fact exactly the same file - Docker is not
copying or adding indirection here - it is simply exposing the file directly.

Rather than specify a directory or file on the host, we can let Docker manage
the volume itself, under a directory it controls. For example:

```
$ docker run -v /data debian \
  sh -c 'echo "hello from container $HOSTNAME" > /data/file'
```

Now if we use the `volume` subcommand, we can see our new volume:

```
$ docker volume ls
DRIVER              VOLUME NAME
local               1ec7b9124f932f36931de615e2985355c126112adbf...
```

Docker has assigned a unique, but rather large and unwieldy name to our volume.
We can find more information about the volume with inspect:

```
$ docker volume inspect \
  1ec7b9124f932f36931de615e2985355c126112adbf8c66b78e6440d6ab5f202 
[
    {
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/graph/volumes/1ec7b9124f932f36931de615...
        "Name": "1ec7b9124f932f36931de615e2985355c126112adbf8c...
        "Options": {},
        "Scope": "local"
    }
]
```

Amongst other things, this tells us the mountpoint, or where Docker has placed
our volume. If you have root access to the Docker host, you can directly access
the path (note this won't work if you are using Docker for Mac or Windows):

```
$ cat /graph/volumes/1ec7b9124f932f36931de615e29853.../\_data/file
hello from container 7ceb66d53323
```


Of course, you wouldn't normally access files like this - Docker managed volumes
are typically only accessed via containers.

Try also creating a volume with the `docker volume` command:

```
$ docker volume create my_vol
my_vol
```

You can run `docker volume ls` to verify this worked. To attach it to a
container, use the `-v` flag with the name of the volume and the mountpoint in
the container:

```
$ docker run -v my_vol:/data debian \
  sh -c 'echo "hi from $HOSTNAME" > /data/file'
```

Now we can read it from a different container:

```
$ docker run -v my_vol:/data debian cat /data/file
hi from 6470a9d242d6
```

The other option is declare a `VOLUME` in a `Dockerfile`. For example, the
`Dockerfile` for the Redis official image includes the line:

```
VOLUME /data
```

When a container is created, Docker will create a new volume for each `VOLUME`
statement. In this case, it means any data written to disk by the Redis
container will be persisted and not lost when the container is removed. Volumes
are only deleted when the `-v` flag is passed to `docker rm` or with the `docker
volume rm command`. Volumes will never be deleted if they are in use by a
container.

To finish this section, let's see how you might typically interact with a volume
during development. We'll start with an Nginx container:

```
$ docker run -d -p 8000:80 --name web nginx
...
$ curl localhost:8000
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...
```

Now, let's try to serve our own HTML page. Create a directory called `html` and
put a simple HTML file called `index.html` inside with the following contents:

```
<!DOCTYPE html>
<html>
  <head>
    <title>Test title</title>
  </head>
  <body>
    Test body
  </body>
</html>
```


The `nginx` image is configured to look for files in `/usr/share/nginx/html`, so
we mount our directory to that path:

```
$ docker stop web
...
$ docker rm web
...
$ ls html
html        index.html
$ docker run -v $PWD/html:/usr/share/nginx/html \
        -d -p 8000:80 --name web nginx
```

And try curling the file again. You should see your new HTML page! 

Now try editing the `index.html` file to read:

```
...
  <body>
     Updated body
  </body>
...
```

If you now access the webserver again, you should find your changes appear
immediately.

In this manner, we can iteratively and quickly develop software and assets. Once
you're happy with what you've built, you can then bake the results into a new
image. 

Try creating a new `Dockerfile` with the contents:

```
FROM nginx:1.11

COPY html /usr/share/nginx/html
```

Build it:

```
$ docker build -t myweb .
...
```

And now we can run it again without the mount (we need to stop the previous
container first)

```
$ docker stop web
web
$ docker run -d -p 8000:80 --name web2 myweb
9317adbef8ab5e6b69fe98e98ba8fd22638dbb6ae4fb8c19306cc4deac65d45a
$ curl localhost:8000
...
```

Note that you can still mount a volume on top of this image and continue
developing, then re-run the build command to create the final image.


