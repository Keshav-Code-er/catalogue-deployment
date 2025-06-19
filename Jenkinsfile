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

            stage('Approval') {
            input {
                message "Should we continue?"
                ok "Yes, we should."
                submitter "alice,bob"
                parameters {
                    string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
                }
            }
            steps {
                echo "Hello, ${PERSON}, nice to meet you."
            }
        }

              stage('Apply'){
                  steps{
                       sh """
                       cd terraform
                       terraform apply -var="app_version=${params.Version}" -auto-approve

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
