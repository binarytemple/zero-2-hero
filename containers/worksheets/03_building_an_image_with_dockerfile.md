\pagebreak

# Building an Image with a Dockerfile

Let's create our `cowsay` image the proper way. Start by creating a new
directory for our code and our empty `Dockerfile`:

```
$ mkdir cowsay
$ cd cowsay
$ touch Dockerfile
```

Put the following contents into the `Dockerfile` using whichever editor you're
most comfortable with (try nano if you don't have much experience with vi or
emacs):

```
FROM debian:jessie

RUN apt-get update
RUN apt-get install -y cowsay fortune
```

The `FROM` statement defines the *base image* for the new image we are creating.
In this case we are using the `debian` image as before, although we've been a
little more specific and chosen the "jessie" version.

The `RUN` statements define the "steps" in creating our new image. 

Try building the image from the same directory as the Dockerfile:

```
$ ls
Dockerfile
$ docker build -t cowmage2 .
...
```

Note that the "." at the end is important (it specifies the "context" of the
build to be the current directory). We used the -t flag to specify a name
(`cowmage2`) for the image.

We can test out the new image as before:

```
$ docker run cowmage2 /usr/games/cowsay boo
...
```

So, this has achieved the same effect as `docker commit`, but in a repeatable
manner which is easy to build on. The next thing we can do is set a `CMD`
statement that calls cowsay automatically when a container is started. Edit the
`Dockerfile` so it contains the following:

```
FROM debian:jessie

RUN apt-get update 
RUN apt-get install -y cowsay fortune
CMD /usr/games/cowsay $(/usr/games/fortune)
```

Repeat the build:

```
$ docker build -t cowmage2 .
...
```

And this time try running with no command specified:

```
$ docker run cowmage2
...
```

Nice, this is a bit simpler. But we can actually do a bit better - currently if
we want to specify new text we have to overwrite the whole command rather than
just provide the new text. We can use the `ENTRYPOINT` statement to achieve
this.

Update the Dockerfile to:

```
FROM debian:jessie

RUN apt-get update 
RUN apt-get install -y cowsay fortune
ENTRYPOINT ["/usr/games/cowsay"] 
CMD ["Moo", "to", "you"]
```

Build it and run it:

```
$ docker build -t cowmage2 .
...
$ docker run cowmage2
...
$ docker run cowmage2 "boo"
...
```

Effectively `ENTRYPOINT` specifies the "command" to run and `CMD` specifies any
arguments to the `ENTRYPOINT`. `CMD` is directly analogous to the command
specified at the end of `docker run` CLI calls and can be overridden by the CLI
as shown above.  The `ENTRYPOINT` command can also be overridden by passing the
`--entrypoint` flag to `docker run`.

Note that this time we've used the exec syntax (the square brackets) to execute
the `cowsay` binary directly, rather than calling through a shell (which is the
default for all `RUN`, `ENTRYPOINT` and `CMD` commands). A side-effect of this
is that we are no longer able to use the fortune program as a default input. In
order to do something like that, we have to get a bit more organized and write a
small script to help us out. Let's try that now. Start by creating a file in the
cowsay directory called `entrypoint.sh` with the following contents:

```
#!/bin/bash
if [ $# -eq 0 ]; then
  /usr/games/cowsay $(/usr/games/fortune)
else
  /usr/games/cowsay "$@"
fi
```

Make the file executable:

```
$ ls
Dockerfile  entrypoint.sh
$ chmod +x entrypoint.sh
```

Now update the `Dockerfile` so that it looks like:

```
FROM debian:jessie

RUN apt-get update 
RUN apt-get install -y cowsay fortune

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"] 
```

The `COPY` command will copy our script from the directory into the Docker
image, and the new `ENTRYPOINT` command will execute it by default. Build and
run it once more:

```
$ docker build -t cowmage2 .
...
$ docker run cowmage2
...
$ docker run cowmage2 moo
...
```

Great, this is about as far as we want to go with the venerable cowsay
application...

## Bonus Task

Cowsay can use different graphics rather than just the cow - see if you can
modify the `Dockerfile` to use a different animal by default.
