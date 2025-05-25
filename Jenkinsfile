pipeline {
    agent any

    stages {
        stage('Clonar repositorio') {
            steps {
                git url: 'https://github.com/Nruz-app/php-env-jenkins', branch: 'main'
            }
        }

        stage('Ejecutar index.php con PHP') {
            steps {
                // Ejecuta php directamente (requiere que PHP esté instalado en el agente Jenkins)
                sh 'php index.php'
            }
        }
    }
}