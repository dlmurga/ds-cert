pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
    WS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    }

  stages {

    stage ('Copy code from git') {
      steps {
        git 'https://github.com/dlmurga/ds-cert.git'
      }
    }

    stage ('Create buildserver ant package java app') {
      steps {
        sh "cd build/ && sudo terraform init && sudo terraform plan"
      }
    }

   stage ('Create prodserver and deploy java app') {
     steps{
       sh "ls -l"
     }
   }

  }
}