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
      }
    }
    stage('Build') {
      steps {
        sh 'make jenkins_build_dir'
        sh 'make jenkins_run'
      }
    }
    stage('Notifications') {
      steps {
      //sh "mkdir -p /home/bliening/ownCloud/702nados/log/${env.JOB_NAME}/${env.BUILD_NUMBER}"
      //sh "cp -R log/* /home/bliening/ownCloud/702nados/log/${env.JOB_NAME}/${env.BUILD_NUMBER}/"
      // should be with specific channel
      }
    }
    post {
      failure {
        mattermostSend color: "#E01818", message: "Build Failed: ${env.JOB_NAME} ${env.BUILD_NUMBER} ${env.BUILD_URL}"
      }
      success {
        mattermostSend color: "#3cc435", message: "Build Successful: ${env.JOB_NAME} ${env.BUILD_NUMBER} ${env.BUILD_URL}"
      }
      always {
        deleteDir()
      }
    }
}
