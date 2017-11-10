\pagebreak

# Building an Image with Commit

In this exercise, we'll have a look at how we can build our own image and use it
to create containers. We can see which images are available to the Daemon with
the `docker images` command:

```
$ docker images
REPOSITORY  TAG     IMAGE ID      CREATED      SIZE
nginx       latest  6b914bbcb89e  7 days ago   182 MB
debian      latest  978d85d02b87  8 days ago   123 MB
```

Alternatively we could have used `docker image ls`. New images are retrieved
implicitly by `docker run` if they are not available locally. We can also pull
images explicitly with the `docker pull` command:

```
$ docker pull alpine
Using default tag: latest
latest: Pulling from library/alpine
627beaf3eaaf: Pull complete
Digest: sha256:58e1a1bb75db1b5a24a462dd5e2915277ea06438c3f1051...
Status: Downloaded newer image for alpine:latest
```

For the rest of this exercise, we'll build an image with the famous "cowsay"
program:

Start by launching a new `debian` container:

```
$ docker run -it --name cowsay debian bash
```

Now update the packager manager inside the container and install the cowsay and
fortune utilities:

```
root@49a02c8575e6:/# apt-get update
...
root@49a02c8575e6:/# apt-get install -y cowsay fortune
...
```

And try it out:

```
root@49a02c8575e6:/# /usr/games/cowsay $(/usr/games/fortune)
...
```

OK, so now we have a container with our software installed. The next step is to
turn it into an image. In this example, we'll take the easy route of using the
docker commit command. Exit from the container and run the commit command with
the container name and the name we want to give our image:

```
root@49a02c8575e6:/# exit
exit
$ docker commit cowsay cowmage
sha256:807f3c4c1eb0da3975a1f61642a3131bc4ec752ad644b5545509334...
```

Docker responds by giving us a content based hash that can be used to reference
our image. It doesn't matter that the container was stopped when we ran the
commit command - the filesystem still exists on disk until the container is
removed.

We can now run our image and execute our application directly:

```
$ docker run cowmage /usr/games/cowsay Moo
...
```

