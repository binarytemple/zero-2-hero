This module teaches how to work with Java applications on Kubernetes. It focues on two main topics:

- Building Java app in Docker using a multi-stage build.
- Java memory issues. The JVM can't detect container memory limits and is very greedy for memory.

The story goes like this: Java is fine to run in Docker. There are base images supported by Oracle for both building
and running java apps. However you should be aware that the JVM has issues with adhering to container memory limits,
and by it's greedy nature it will sooner or later crash unless Xmx is set. There is a slide about the 3 possible solutions
to the memory issue. There was no time to show this problem in the exercises so those focus on building the
Docker image and running it in Kubernetes against a MySQL database.