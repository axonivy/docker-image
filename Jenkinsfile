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
            } else {
              sh "./build.sh ${version} --push"
            }
          }
        }
      }
    }

    stage('docker-scout') {
      steps {
        script {
          def version = params.version;
          docker.withRegistry('', 'docker.io') {
            if (version == 'rebuildAllSupportedLTSVersions') {
              dockerScoutAnalyze('8.0');
              dockerScoutRecordInEnv('8', '8.0');
              dockerScoutAnalyze('10.0');
              dockerScoutRecordInEnv('10', '10.0');
            } else {
              def env = version.replace('.0', '').replace('.', '-');
              currentBuild.description = "version: ${version} <a href='https://scout.docker.com/reports/org/axonivy/overview?stream=environment%3A${env}'>docker-scout</a>"
              dockerScoutAnalyze(version);
              dockerScoutRecordInEnv(env, version);
            }
          }
        }
      }
    }
  }
}

def dockerScoutRecordInEnv(String env, String version) {
  withCredentials([usernamePassword(credentialsId: 'docker.io-axonivyinfo', passwordVariable: 'dockerPass', usernameVariable: 'dockerUser')]) {
    ansiColor('xterm') {
      sh "docker run -t -e DOCKER_SCOUT_HUB_USER=${dockerUser} -e DOCKER_SCOUT_HUB_PASSWORD=${dockerPass} " +
         "docker/scout-cli env ${env} --org axonivy axonivy/axonivy-engine:${version}"
    }
  }
}

def dockerScoutAnalyze(String version) {
  withCredentials([usernamePassword(credentialsId: 'docker.io', passwordVariable: 'dockerPass', usernameVariable: 'dockerUser')]) {
    ansiColor('xterm') {
      catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
        sh "docker run -t -e DOCKER_SCOUT_HUB_USER=${dockerUser} -e DOCKER_SCOUT_HUB_PASSWORD=${dockerPass} " +
          "docker/scout-cli cves axonivy/axonivy-engine:${version} --exit-code --ignore-base --only-fixed --locations"
      }
    }
  }
}
