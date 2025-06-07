pipeline{
       agent { node { label 'Agent-1' } }
        options {
        ansiColor('xterm')
    }
       parameters {
        string(name: 'Version', defaultValue: '1.0.1', description: 'which version to deployment')
    }
          stages {
            stage('Deploy'){
                  steps{
                       echo "Deploying..."
                       echo "Version from params: ${params.Version}"
                  }
            }
        
            stage('Init'){
                  steps{
                       sh """
                       cd terraform
                       terraform init -reconfigure

                       """
                  }
            }

             stage('Plan'){
                  steps{
                       sh """
                       cd terraform
                       terraform plan -var="app_version=${params.Version}"

                       """
                  }
            }
          
       }

       post{
            always{
                  echo 'cleaning up workspace'
                  deleteDir()
            }
       }
}
