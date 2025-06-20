pipeline {
  agent any

  environment {
    IMAGE_NAME = "gcr.io/$GOOGLE_PROJECT_ID/secret-web"
    REGION = "us-central1"
  }

  stages {
stage('Obtener secreto') {
  steps {
    script {
      withCredentials([
        conjurSecretCredential(
          credentialsId: 'secret-message-conjur',
          variable: 'SECRET_MESSAGE'
        )
      ]) {
        echo "Secreto recuperado: ${env.SECRET_MESSAGE}"
        writeFile file: 'secret.env', text: "SECRET_MESSAGE=${env.SECRET_MESSAGE}"
      }
    }
  }
}

    stage('Build Docker image') {
      steps {
        sh 'docker build --build-arg SECRET_MESSAGE="$SECRET_MESSAGE" -t $IMAGE_NAME .'
      }
    }

    stage('Push a Google Container Registry') {
      steps {
        sh '''
        echo "$GCLOUD_SERVICE_KEY" | base64 --decode > gcloud-key.json
        gcloud auth activate-service-account --key-file=gcloud-key.json
        gcloud auth configure-docker
        docker push $IMAGE_NAME
        '''
      }
    }

    stage('Deploy en Cloud Run') {
      steps {
        sh '''
        gcloud run deploy secret-web \
          --image $IMAGE_NAME \
          --platform managed \
          --region $REGION \
          --allow-unauthenticated
        '''
      }
    }
  }
}
