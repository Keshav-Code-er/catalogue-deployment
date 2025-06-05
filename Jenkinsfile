pipeline{
       agent { node { label 'Agent-1' } }
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
            
       }

       post{
            always{
                  echo 'cleaning up workspace'
                  deleteDir()
            }
       }
}
