pipeline {
  environment {
    schema = "http"
    registry = "registry.crazyzone.be"
    registry_mirror = "registry-mirror.crazyzone.be"
    name = 'home'
  }  
  agent {
    kubernetes {
      yaml '''
kind: Pod
metadata:
  name: kaniko
spec:
  volumes:
    - name: kaniko-cache
      nfs: 
        server: nas.crazyzone.be 
        path: /volume1/docker-storage/kaniko/cache
  containers:
  - name: docs-builder
    image: registry.crazyzone.be/daux.io:latest
    imagePullPolicy: Always
    tty: true
    command:
    - cat
  - name: kaniko
    image: registry.crazyzone.be/kaniko:20210317
    imagePullPolicy: Always
    tty: true
    command:
    - sleep
    - infinity
    volumeMounts:
    - name: kaniko-cache
      mountPath: /cache
'''
    }

  }
  stages {
    stage('build') {
      steps {
        when { branch: "master" }
        container(name: 'kaniko', shell: '/busybox/sh') {
          sh '''#!/busybox/sh 
if [[ $GIT_LOCAL_BRANCH == "main" || $GIT_LOCAL_BRANCH == "master" ]];
then
  TAG=latest
else
  TAG=$GIT_LOCAL_BRANCH
fi

/kaniko/executor \
  --dockerfile Dockerfile \
  --context `pwd`/ \
  --verbosity debug \
  --destination ${registry}/${name}:$TAG \
  --destination ${registry}/${name}:`cat VERSION` \
  --cache=true \
  --cache-repo ${registry}/cache \
  --registry-mirror ${registry_mirror}
            '''
        }
      }
    }
  }
}