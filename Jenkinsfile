pipeline {
    agent any

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['DEV', 'PROD'], description: 'Selecciona el entorno de despliegue')
    }

    environment {
        VAULT_ADDR = 'http://172.23.16.1:8200'
        VAULT_TOKEN = credentials('vault-root-token')
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
                    def json = sh(script: "curl -s --header 'X-Vault-Token: ${VAULT_TOKEN}' ${VAULT_ADDR}/v1/secret/data/test", returnStdout: true).trim()
                    def secreto = readJSON text: json

                    def appVar = ''
                    if (params.ENVIRONMENT == 'DEV') {
                        appVar = secreto.data.data.APP_VAR_DEV
                    } else if (params.ENVIRONMENT == 'PROD') {
                        appVar = secreto.data.data.APP_VAR_PROD
                    }

                    echo "Valor de APP_VAR (${params.ENVIRONMENT}): ${appVar}"

                    writeFile file: '.env', text: "APP_VAR=${appVar}"
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
                        sh '''#!/bin/bash
                            cat .env
                            export $(cat .env | xargs)
                            php index.php
                        '''
                    }
                }
            }
        }
    }
}