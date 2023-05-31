pipeline {
  agent any

  stages {
    stage('Build and Test') {
      steps {
        // Install dependencies
        sh 'pip install -r ./app/requirements.txt'

        // Run Migration
        sh 'python3 ./app/manage.py migrate'
        
         // Lint with flake8
        sh 'python3 -m flake8 ./app --count --select=E9,F63,F7,F82 --show-source --statistics'
        sh 'python3 -m flake8 ./app --count --ignore=E501 --exit-zero --max-complexity=10 --max-line-length=127 --statistics'

        // Run unit tests
        sh 'python3 ./app/manage.py test'
      }
    }

    stage('Package as Docker Image and Push to Registry') {
      steps {

        script {
            docker.withRegistry('https://esrysf.azurecr.io', 'acr-esrysf-credentials') {
                app.push("${env.BUILD_NUMBER}")
                app.push("latest")
            }
        }

      }
    }


    // stage('Push Docker Image to Registry') {
    //   steps {
    //     azureContainerRegistryLogin('acr-prod')

    //     azureContainerRegistryPush('acr-prod', 'esr-todolist')
    //   }
    // }

    // stage('Deploy to AKS') {
    //   steps {
    //     kubernetes.withCluster() {
    //       kubernetes.configure(namespace: 'prod')

    //       sh "kubectl apply -f deployment.yml"
    //       sh "kubectl apply -f service.yml"
    //   }
    //   }
    // }
  }
}