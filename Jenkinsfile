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
          docker.withRegistry('', 'docker.io') {
            if (version == 'rebuildAllSupportedLTSVersions') {              
              // activate as soon as 8.0.15 has been released
              // sh "./build.sh 8.0"
            } else {
              sh "./build.sh ${version}"
            }
          }
        }
      }
    }
  }
}
