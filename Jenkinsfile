pipeline {
  agent any

  stages {

    stage ('Copy code from git') {
      steps {
        git 'https://github.com/dlmurga/ds-cert.git'
      }
    }

    stage ('Create buildserver ant package java app') {
      steps {
        sh "ls -l"
      }
    }

   stage ('Create prodserver and deploy java app') {
     steps{
       sh "ls -l"
     }
   }

  }
}