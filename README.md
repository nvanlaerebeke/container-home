# home-docs

## Introduction

Collection of docs about personal projects

The docs are provided in markdown format or can be build in a container and served as html.

## Building the image

A makefile that builds the docker container is included, to build run:

```
NAME="home-docs" TAG="latest" make build
```

This will result in a local image tagged with as "home-docs:latest".  
See the 'Additional Options' section for more information about the available options.  

To push the image to the repository use the command below.  

## Pushing the image to a repository

The included makefile can also push the build image, first the container is build with the given options and once build it is pushed to the repository.

To build and push, run:

```
NAME="home-docs" TAG="latest" make push
```

### Additional Options

There are several options that can be passed to customize the build process.  
The defaults are only set when using the Jenkins pipeline.


- REPO(default: registry.crazyzone.be): repository to push the image to
- NAME(default: home-docs): name of the image
- TAG(default: latest): tag name


## Using the image

The image contains the html code already, so all is needed is to expose the port 

Example:

```
docker run --rm -ti registry.crazyzone.be/home-docs -p 80:80
```

## SSL/TLS

No certificate support is provided, it is assumed that the container will be run behind a reverse proxy doing SSL termination

## Building with Jenkins

The included Jenkinsfile is made to be run and deploy on the crazyzone network.  
The Jenkinsfile can be modified can be modified to apply to other environments