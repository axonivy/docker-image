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
              sh "./build.sh 8.0 --push"

              // comment in, after 10.0.7 has been relased, otherwise we have a change in 10.0.6 image.
              //sh "./build.sh 10.0 --push"
            } else {
              sh "./build.sh ${version} --push"
            }
          }
        }
      }
    }
  }
}
