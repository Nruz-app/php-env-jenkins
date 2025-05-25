pipeline {
    agent any

    environment {
        VAULT_ADDR = 'http://172.21.208.1:8200'
        VAULT_TOKEN = credentials('vault-root-token')  // Token de Vault guardado en Jenkins Credentials
        ENVIRONMENT = 'DEV' // O 'PROD' - podrías parametrizar este valor en Jenkins para elegir ambiente
    }

    stages {
        stage('Clonar repositorio') {
            steps {
                git url: 'https://github.com/Nruz-app/php-env-jenkins', branch: 'main'
            }
        }

        stage('Obtener secreto desde Vault') {
            steps {
                script {
                    // Llamada CURL para obtener secreto desde Vault, parsear JSON y extraer la variable correcta
                    def vaultSecretJson = sh (
                        script: """
                            curl -s --header "X-Vault-Token: ${VAULT_TOKEN}" \
                            ${VAULT_ADDR}/v1/secret/data/test
                        """, returnStdout: true
                    ).trim()

                    def vaultSecret = readJSON text: vaultSecretJson
                    // Extraemos el dato dinámicamente según ambiente
                    def appVarFromVault = vaultSecret.data.data["APP_VAR_${ENVIRONMENT}"]

                    // Asignamos la variable al entorno Jenkins
                    env.APP_VAR = appVarFromVault
                }
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
                    docker.image('php:8.2-cli').inside('--entrypoint=""') {
                        sh """
                            # Creamos el archivo .env con la variable inyectada
                            echo APP_VAR="${APP_VAR}" > .env
                            cat .env
                            php index.php
                        """
                    }
                }
            }
        }
    }
}