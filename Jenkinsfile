#!groovy
pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        checkout scm
        sh 'git submodule update --init'
        sh 'make jenkins'
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
