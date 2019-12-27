versions = ['rebuildAllSupportedVersions', 'dev', 'nightly', 'sprint', 'latest', '8.0']

pipeline {
  agent any

  options {
    buildDiscarder(logRotator(artifactNumToKeepStr: '50'))
  }
  
  parameters {
    choice name: 'version', choices: versions
  }

  triggers {    
    cron '@midnight'
  }

  stages {
    stage('build') {
      steps {
        script {
          def version = params.version;
          docker.withRegistry('', 'docker.io') {
            if (version == 'rebuildAllSupportedVersions') {
              sh "./build.sh latest"
              sh "./build.sh 8.0"
            } else {
              sh "./build.sh ${version}"          
            }
          }
        }
      }
    }
  }
}
