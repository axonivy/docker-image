pipeline {
  agent any

  options {
    buildDiscarder(logRotator(numToKeepStr: '50'))
  }
  
  parameters {
    string name: 'version',
    defaultValue: 'rebuildAllSupportedLTSVersions',
    description: 'version to build (dev, nightly, nightly-8, sprint, 8.0, 9.1, 9.2, ...)',
    trim: true
  }

  triggers {    
    cron '@midnight'
  }

  stages {
    stage('build') {
      steps {
        script {
          def version = params.version;
          currentBuild.description = "version: ${version}"
          docker.withRegistry('', 'docker.io') {
            if (version == 'rebuildAllSupportedLTSVersions') {              
              sh "./build.sh 8.0 --push"
              sh "./build.sh 10.0 --push"
              triggerDockerScoutBuild('8.0');
              triggerDockerScoutBuild('10.0');
            } else {
              sh "./build.sh ${version} --push"
              triggerDockerScoutBuild(version);
            }
          }
        }
      }
    }
  }
}

def triggerDockerScoutBuild(def version) {
  build job: 'docker-image_docker-scout/master', wait: false, parameters: [string(name: 'version', value: "${version}")]
}
