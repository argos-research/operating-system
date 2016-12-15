node {
   stage('Preparation') { // for display purposes
      sh "make clean"
      // Get some code from a GitHub repository
      // Could possibly be obsolete, will further investigate when isnan/inf bug is fixed
      checkout scm
      //git branch: 'master', url: 'https://github.com/argos-research/operating-system.git'  
      //git submodule init
      //git submodule update
      //Preparing build
      sh "wget https://nextcloud.os.in.tum.de/s/KVfFOeRXVszFROl/download --no-check-certificate -O libports.tar.bz2"
      sh "tar xvjC genode/ -f libports.tar.bz2"
      sh "mkdir -p log"
      sh "touch log/prepare.log"
      sh "make > log/prepare.log 2>&1"
      sh "mkdir -p genode/build/genode-focnados_panda/log"
      sh "touch genode/build/genode-focnados_panda/log/make.log"
   }
   stage('Build') {
      // Run the build of dom0-HW
      sh "make run > build/genode-focnados_panda/log/make.log 2>&1"
   }
   stage('Notifications') {
      sh "cp log/* genode/build/genode-focnados_panda/log/"
      mattermostSend color: "#439FE0", message: "Build Finished: ${env.JOB_NAME} ${env.BUILD_NUMBER}"
      // should be with specific channel
      
   }
   //Here tests or other stuff would appear
}
