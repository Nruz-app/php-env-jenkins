pipeline {
    agent any

    environment {
        APP_VAR = 'Hola desde .env inyectado en Jenkins'
    }

    stages {
        stage('Clonar repositorio') {
            steps {
                git url: 'https://github.com/Nruz-app/php-env-jenkins', branch: 'main'
            }
        }

        stage('Instalar dependencias') {
            steps {
                script {
                    docker.image('composer:2').inside('--entrypoint=""') {
                        sh 'composer install'
                    }
                }
            }
        }

        stage('Ejecutar PHP en Docker') {
            steps {
                script {
                    docker.image('php:8.2-cli').inside('--entrypoint="" -e APP_VAR') {
                        sh '''
                            echo "APP_VAR=$APP_VAR" > .env
                            php index.php
                        '''
                    }
                }
            }
        }
    }
}
