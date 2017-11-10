## Zero to Hero
### A Crash Course in Containers and Orchestration
&nbsp;
### Adrian Mouat
<img width="400" src="slides/img/cs-logo-transparent-background.png">
---

##Introduction

 - Chief Scientist @ Container Solutions
 - http://www.container-solutions.com
 - Wrote "Using Docker" for O'Reilly
 - Docker Captain
 - @adrianmouat

<img width="250" src="slides/img/bookcover.png">
<img width="250" src="slides/img/captain.png">
---

## Overview

 - Intro to
  - Cloud Native
  - Devops
  - Microservices
  - Containers 

 - Docker 101

---

## Cloud Native

 - Designing apps for the Cloud *First*
 - Designing for scalability 
   - Ability to handle large numbers of users
 - And reliability
   - 5 nines etc
 
-

## Cloud Native
 
 - Using modern techniques
   - Microservices
   - Programmable infrastructure
 - And modern technology
   - containers
   - dynamic orchestration platforms

-

## DevOps

 - Traditionally
  - Developers created applications
  - Operations hosted and maintained them 

<img width="500" src="slides/img/ops_problem.jpg">

-

## Lead to a "wall"

 - Developers "threw" software over the wall
  - Little regard for complete testing or reliability
 - Ops responsible for keeping things running
  - On call
  - Pushed back heavily on software/libraries 

<img src="slides/img/devops-wall.jpg">

-

## Issues

 - Slow updates
 - Poor relations between dev and ops
 - Issues with upgrades/releases

-

## Devops

 - Acknowledges both dev and ops
   - are part of the same team
   - attempts to tear down the wall
 - *Teams* become responsible for running services
  - made up of both dev and ops
  - on-call

-

## Microservices

 - System architecture that uses multiple small services
 - Each one has a simple, well-defined job
 - As opposed to "monolithic" architectures

-

## Monoliths

 - Entire system in one program
 - Typically Java/C#
  - still prevalent in enterprise 
 - Scale *up*

-

## Microservices
 
 - Lightweight SOA
 - Composable
  - Talk over APIs
  - REST and HTTP, GRPC
 - May use multiple languages
 - Scale *out*
 
-

## Minimal

 - James Lewis Head Metric

 - *Services must be small enough to fit in James Lewis's head*

 - http://www.bovon.org/archives/350

<img src="slides/img/lewis_head.png">

-

## Drawbacks

 - Complexity moved to network
 - Fast function calls become slow network calls

-

## Conway's Law

*orgamizations which design systems ... are constrained to produce designs which
are copies of the communication structures of these organizations*

Melvin Conway

<img width="400" src="slides/img/mel_conway.jpg">

-

## Two Pizza Teams

 - Small team sizes
 - Decentralized
 - Less communication overhead


<img src="slides/img/pizza.png">

-

## Containers

 - Portable format for developing and deploying applications 
 - Almost synonymous with microservices
 - Also great fit for Devops

-

## Conclusion

 - Modern software development is changing rapidly
   - Can be hard to keep up
   - Changes driven by need to constantly update
   - and high-expectations of uptime
 - Devops, Microservices and Cloud Native are all part of this

