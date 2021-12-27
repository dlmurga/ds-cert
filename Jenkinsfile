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
        sh "cd build/ && sudo terraform init && sudo terraform plan && sudo terraform apply -input=false -auto-approve"
        sh "cd build/ && sudo terraform destroy -input=false -auto-approve"
      }
    }

   stage ('Create prodserver and deploy java app') {
     steps{
       sh "cd deploy/ && sudo terraform init && sudo terraform plan && sudo terraform apply -input=false -auto-approve"
     }
   }

  }
}