#!groovy
pipeline {
  agent any
  stages {
    stage('Prepare') {
      steps {
        sh 'git submodule update --init'
        sh 'wget https://nextcloud.os.in.tum.de/s/KVfFOeRXVszFROl/download --no-check-certificate -O libports.tar.bz2'
        sh 'tar xvjC genode/ -f libports.tar.bz2'
        sh 'make ports'
        // for check in run files
        sh 'export ON_JENKINS="true"'
      }
    }
    stage('Build') {
      steps {
        sh 'make jenkins_build_dir'
        sh 'make jenkins_run'
      }
    }
  }
  post {
    always {
      deleteDir()
    }
  }
}
