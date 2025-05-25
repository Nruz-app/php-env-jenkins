pipeline {
    agent any

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['DEV', 'PROD'], description: 'Selecciona el entorno de despliegue')
    }

    environment {
        VAULT_ADDR = 'http://172.21.208.1:8200'
        VAULT_TOKEN = credentials('vault-root-token')  // Token de Vault guardado en Jenkins Credentials
        // ENVIRONMENT se toma del parámetro, no es necesario definirlo aquí
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
                    def vaultSecretJson = sh (
                        script: """
                            curl -s --header "X-Vault-Token: ${VAULT_TOKEN}" \
                            ${VAULT_ADDR}/v1/secret/data/test
                        """, returnStdout: true
                    ).trim()

                    def vaultSecret = readJSON text: vaultSecretJson

                    // Accede a la clave APP_VAR_DEV o APP_VAR_PROD, dependiendo del parámetro
                    def appVarFromVault = vaultSecret.data.data["APP_VAR_${params.ENVIRONMENT}"]
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