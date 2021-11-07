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
    stage('version') {
      when { anyOf { branch "master" } }
      steps {
        checkout \
              scm: [ $class: 'GitSCM', \
              branches: [[name: '*/' + env.BRANCH_NAME]],  \
              extensions: [[  $class: 'RelativeTargetDirectory', relativeTargetDir: "repository/" ], [$class: 'CleanCheckout']],
              userRemoteConfigs: [[ credentialsId: '1743f099-9f0f-43e0-9aa2-4ffc9e9cd066', url: "https://github.com/nvanlaerebeke/container-home.git" ]]
            ]
          sh '''
            VERSION=`cat ./repository/VERSION`
            echo $VERSION | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}' > ./repository/VERSION
            git commit -am 'Upped version'
'''
      }
    }
    stage('build') {
      when { anyOf { branch "master" } }
      steps {
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