pipeline {
  agent any

  options {
    buildDiscarder(logRotator(numToKeepStr: '50'))
  }
  
  parameters {
    string(name: 'version',
      defaultValue: 'dev',
      description: 'version to build (dev, nightly, nightly-10, sprint, 8.0, 10.0, 11.2, ...)',
      trim: true)
    booleanParam(name: 'triggerDockerScout', defaultValue: true)
  }

  triggers {
    parameterizedCron('''
      @midnight %version=8.0
      @midnight %version=10.0
      @midnight %version=11.2
    ''')
  }

  stages {
    stage('build') {
      steps {
        script {
          def version = params.version;
          currentBuild.description = "version: ${version}"
          docker.withRegistry('', 'docker.io') {
            sh "./build.sh ${version} --push"
          }
        }
      }
    }
  }

  post {
    success {
      script {
        if (params.triggerDockerScout) {
          build job: 'docker-image_docker-scout/master', wait: false, parameters: [string(name: 'version', value: "${params.version}")]
        }
      }
    }
  }
}
