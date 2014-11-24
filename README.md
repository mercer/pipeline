Usage
---------
- vagrant up
- visit [virtualbox]:8080 and configure a build job
- DOCKER_HOST is set to the docker as a service container
- REGISTRY_HOST is set to the registry as a service container 

Stages
---------
- [x] commit (compile, package, test, automated code review, [reports], publish, marked)
- acceptance
- uat
- performance
- production

Principles
------------
- i'd like to clearly see all steps a build goes through
- i'd like to have good monitoring of my containers
- i'd like to have good management of statefull containers

TODO BACKLOG
----------------
- i should commit to registry from gradle, not from jenkins
- Vagrant
- jenkins with java 1.8
- clean up gradle configuration
- ONBUILD trigger to pack a deployable artifact with a container (tomcat)
- add javadoc task call
- remove expose ports duplication from own Dockerfile
- cleanup all the mixes of pipeline config and env config, and all other config; remove hardcoded credentials
- have config pass guest os appliance urls and not component urls (fetch ports/host os ip)
- use artifactory as proxy/mirroring
- mirroring with docker registry
- shipyard?
- start mysql and tomcat in delivered container?
- DOCKER_HOST in jenkins container should not be hardcoded in the Dockerfile
- what if i'm not in boot2docker, is it ok for jenkins to be reliant on an outside docker provider?
- remove war file from artifactory (when doing a FROM, a hook is triggered for which you need to specify a war file)
- enable authentication to the registry (fixes "Invalid registry endpoint" errors)
- add dockerfile link in hub for repos
- build total time?
- diagnostics on all containers?
- [x] fix publish to unsecure registry
- [x] start one build artifact container from registry by hand
- [x] start several containers from registry by hand
- [x] add war file to build artifact container
- [x] build the deployable artifact
- [x] expose the appliance's ports to localhost
- [x] docker artifactory
- [x] docker registry appliance
- [x] fetch build number to version strategy
- [x] fix boot2docker os system time
- [x] have sonar run on all
- [x] remove ports, if possible
- [x] make acceptance build job
- [x] make acceptance job downstream of commit
- [x] research gradle acceptance tasks
- [x] create an (empty) acceptance gradle task
- [x] fetch any war from artifactory
- [x] fetch the correct war from artifactory
- [x] continue to fetch the correct war after artifactoru container is recreated

Features
------------
- I have a friendly entry point to services (ports are random)

Fictionized lifecycle of a container
--------------------------------------
- restore state
- start container
- state backuped from time to time, serve clients
- container stopped
- state backedup or archived
- if service died, logs and such should be saved for forensics purposes
- container erased

Questions
-----------
- [x] docker: started on 192.168.59.103:8080; how do I expose it on lan? on internet?
- docker: how do i get it on a Digitalocean instance? vagrant?
- docker: how to save/provision jenkins settings, plugins, build pipelines?
- docker: linked containers dependencies when starting? can a container start it's dependencies, wait for them to be completely started, then start itself?
- how to deliver artifacts in conjunction with docker? is an artifact (war) repository still needed?
- should a container be stateless? where should all state go? db, logs, all kinds of bits and bytes
- should we or shouldn't we use latest tags? versions should be under control, no?
- when giving passwords as parameters to containers, ok in clear? where should they come from?
- when starting a container, random ports --> localhost or not?
- how to debug boot2docker? 
- how to debug containers that fail to start?
- postgres?
- add build info together with artifact?
- extend Dockerfiles to install plugins on jenkins and sonar?
- jenkins jobs to git?
- how much space do container instances occupy? what about container snapshots?
- sidekick container specialized on backup?
- multi-container dockerfile?
- when starting all containers, how to start dependencies first?
- if upstream commit build has number x, downstream acceptance build has number y, is y relevant?
- before commiting an container increment, shouldn't it be started to verify that it works (smoke tests)

Appliances
--------------------------
- jenkins
- sonar-mysql
- sonar; default user and password for mysql is sonar:123qwe

What if
---------
- what if we store in artifact repository only the deployable artifacts?

Issues
-------------
- [x] https://issues.gradle.org/browse/GRADLE-3062 -> upgrade to gradlew 2.2+
- [x] VOLUME didn't work in Dockerfile -> you're not supposed to do it like that, state is maneged outside Dockerfile
- when sharing a volume, owner is set to root of the container; https://github.com/docker/docker/issues/3124 and others;
  and https://groups.google.com/forum/#!topic/docker-user/cVov44ZFg_c and https://github.com/docker/docker/issues/5189
  -> only solution so far is to run the container with root :/
- local insecure private docker registry: see https://github.com/docker/docker/issues/8887#issuecomment-61864331 and
  http://wanderingquandaries.blogspot.ro/2014/11/setting-up-insecure-docker-registry.html
- sometimes the registry container fails to start with "2014-11-09 23:49:15 [17] [ERROR] Exception in worker process:"
- after adding tags for a deployable docker container, now build tags are too long https://i.imgur.com/uIbroci.png
- ubuntu service does not start at container start time (jenkins container with apache2)

Add docker host to hosts file
------------------------------
echo $(docker-ip) dockerhost | sudo tee -a /etc/hosts

Useful docker scripts
-------------------------------------------------
$(boot2docker shellinit)

boot2docker-ip() {
  boot2docker ip 2> /dev/null
}

docker-enter() {
  boot2docker ssh '[ -f /var/lib/boot2docker/nsenter ] || docker run --rm -v /var/lib/boot2docker/:/target jpetazzo/nsenter'
  boot2docker ssh -t sudo /var/lib/boot2docker/docker-enter "$@"
}

docker-pid() {
  docker inspect --format '{{ .State.Pid }}' "$@"
}

docker-ip() {
  docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
}

echo $(docker-ip) dockerhost | sudo tee -a /etc/hosts

Very small docker containers
--------------------------------
- docker pull scratch
