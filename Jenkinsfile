pipeline {
  agent {
    docker { image 'php:8.2-cli' }
  }

  stages {
    stage('Verificar PHP') {
      steps {
        sh 'php --version'
      }
    }

    stage('Ejecutar index.php') {
      steps {
        sh 'php index.php'
      }
    }
  }
}