\pagebreak

# Docker Compose 

In this exercise we'll briefly explore the Docker Compose tool.

First we will insure docker-compose is installed

On your ubuntu machine

```
$ sudo apt-get install -y docker-compose
```

__Note__: Whitespace is extremely important in this example, generally
each successive level of indentation should use 2 spaces each.  
Create a file `docker-compose.yml` with the following contents:

```
version: '2'
services:
  identidock:
    image: amouat/identidock
    ports:
      - "5000:5000"
    environment:
      ENV: DEV

  dnmonster:
    image: amouat/dnmonster:1.0

  redis:
    image: redis:3.0
```

This file defines three containers, identidock, dnmonster and redis. They all
have associated images and the identidock container also exposes a port to the
host and sets an environment variable.

Try starting the service:

```
$ docker-compose up -d
...
```

You should now be able to access the application at http://localhost:5000

Let's have a quick look at what docker-compose has set up for us.

We can have a quick look at the Network that _docker-compose_ has set
up for us:

```
$ docker network ls
...
099edf2df125        traininguser_default     bridge              local
```

docker-compose sets up a custom network for each instance of
docker-compose. This helps us keep seperate projects from accidentally
talking to one another.

In this example we don't use docker volumes, docker-compose also
namespaces volumes such as 'traininguser_data'.

All of the settings specified in the docker-compose.yml file can also
be specified on the command-line.
The advantage of docker-compose is the ability to store the required
command-line arguments with the project and in version-control.

We can look at the logs of all the containers that were started using:

```
$ docker-compose logs
dnmonster_1   | 
dnmonster_1   | > dnmonster@0.1.0 start /usr/src/app
identidock_1  | Running Development Server
identidock_1  |  * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
identidock_1  |  * Restarting with stat
dnmonster_1   | > node server.js
dnmonster_1   | 
dnmonster_1   | dnmonster listening at http://:::8080
redis_1       | 1:C 09 Oct 09:32:25.405 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
redis_1       |                 _._                                                  
redis_1       |            _.-``__ ''-._                                             
redis_1       |       _.-``    `.  `_.  ''-._           Redis 3.0.7 (00000000/0) 64 bit
redis_1       |   .-`` .-```.  ```\/    _.,_ ''-._                                   
redis_1       |  (    '      ,       .-`  | `,    )     Running in standalone mode
redis_1       |  |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
redis_1       |  |    `-._   `._    /     _.-'    |     PID: 1
redis_1       |   `-._    `-._  `-./  _.-'    _.-'                                   
redis_1       |  |`-._`-._    `-.__.-'    _.-'_.-'|                                  
redis_1       |  |    `-._`-._        _.-'_.-'    |           http://redis.io        
redis_1       |   `-._    `-._`-.__.-'_.-'    _.-'                                   
redis_1       |  |`-._`-._    `-.__.-'    _.-'_.-'|                                  
redis_1       |  |    `-._`-._        _.-'_.-'    |                                  
redis_1       |   `-._    `-._`-.__.-'_.-'    _.-'                                   
redis_1       |       `-._    `-.__.-'    _.-'                                       
redis_1       |           `-._        _.-'                                           
redis_1       |               `-.__.-'                                               
redis_1       | 
redis_1       | 1:M 09 Oct 09:32:25.409 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
redis_1       | 1:M 09 Oct 09:32:25.409 # Server started, Redis version 3.0.7
redis_1       | 1:M 09 Oct 09:32:25.409 # WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
redis_1       | 1:M 09 Oct 09:32:25.409 # WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
redis_1       | 1:M 09 Oct 09:32:25.409 * The server is now ready to accept connections on port 6379
```

One may also do the same for checking the state of the processes:

```
$ docker-compose ps
        Name                      Command               State                     Ports                   
----------------------------------------------------------------------------------------------------------
scratch_dnmonster_1    npm start                        Up      8080/tcp                                  
scratch_identidock_1   /cmd.sh                          Up      0.0.0.0:5000->5000/tcp, 9090/tcp, 9191/tcp
scratch_redis_1        docker-entrypoint.sh redis ...   Up      6379/tcp                                  
```

<!-- removed top command as docker-compose is too old on GKE -->

All of these commands are directly equivalent to commands that can be
run on a single container using the docker command.

Try some of the other Compose commands that you can list with `docker-compose
--help` e.g. `logs` and `ps`.

