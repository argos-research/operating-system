#!groovy
pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        checkout scm
        sh 'git submodule update --init'
        sh 'make ports'
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
