pipeline{
       agent { node { label 'Agent-1' } }
       stages {
            stage('Deploy'){
                  steps{
                     echo "Deploying..."
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
