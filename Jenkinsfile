pipeline {
  agent any

  stages {
    stage('Build and Test') {
      steps {
        # Install dependencies
        sh 'pip install -r requirements.txt'

        # Run Migration
        sh 'python manage.py migrate'
        
        # Run unit tests
        sh 'python manage.py test'

        # Lint with flake8
        sh 'flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics'
        sh 'flake8 . --count --ignore=E501 --exit-zero --max-complexity=10 --max-line-length=127 --statistics'
      }
    }

    stage('Package as Docker Image') {
      steps {
        // Package the app as a Docker image
      }
    }

    stage('Push Docker Image to Registry') {
      steps {
        // Push the Docker image to Azure Container Registry
      }
    }

    stage('Deploy to AKS') {
      steps {
        // deploy the Docker image to AKS cluster
      }
    }
  }
}
