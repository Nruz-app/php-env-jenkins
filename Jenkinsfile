pipeline {
    agent any

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['DEV', 'PROD'], description: 'Selecciona el entorno de despliegue')
    }

    environment {
        VAULT_ADDR = 'http://172.21.208.1:8200'
        VAULT_TOKEN = credentials('vault-root-token')
    }

    stages {
        stage('Clonar repositorio') {
            steps {
                echo "Clonando repositorio..."
                git url: 'https://github.com/Nruz-app/php-env-jenkins', branch: 'main'
            }
        }

        stage('Obtener secreto desde Vault') {
            steps {
                script {
                    echo "Obteniendo secretos desde Vault..."
                    def json = sh(script: "curl -s --header 'X-Vault-Token: ${VAULT_TOKEN}' ${VAULT_ADDR}/v1/secret/data/test", returnStdout: true).trim()
                    def secreto = readJSON text: json

                    def appVar = ''
                    if (params.ENVIRONMENT == 'DEV') {
                        appVar = secreto.data.data.APP_VAR_DEV
                    } else if (params.ENVIRONMENT == 'PROD') {
                        appVar = secreto.data.data.APP_VAR_PROD
                    } else {
                        error "Parámetro ENVIRONMENT inválido: ${params.ENVIRONMENT}"
                    }

                    echo "Valor de APP_VAR (${params.ENVIRONMENT}): ${appVar}"

                    writeFile file: '.env', text: "APP_VAR=${appVar}"
                }
            }
        }

        stage('Instalar dependencias PHP') {
            steps {
                script {
                    echo "Instalando dependencias con Composer..."
                    docker.image('composer:2').inside('--entrypoint=""') {
                        sh 'composer install --no-interaction --prefer-dist --optimize-autoloader'
                    }
                }
            }
        }

        stage('Construir y levantar servicios con Docker Compose') {
            steps {
                script {
                    echo "Construyendo y levantando contenedores con docker-compose..."
                    sh 'docker-compose down -v || true' // limpia antes de levantar
                    sh 'docker-compose build'
                    sh 'docker-compose up -d'
                }
            }
        }

        stage('Esperar servicio web') {
            steps {
                script {
                    echo "Esperando a que el servicio web esté disponible en http://localhost:6162 ..."
                    timeout(time: 1, unit: 'MINUTES') {
                        waitUntil {
                            def response = sh(script: "curl -s -o /dev/null -w '%{http_code}' http://localhost:6162 || true", returnStdout: true).trim()
                            return response == '200'
                        }
                    }
                    echo "Servicio web listo"
                }
            }
        }

        stage('Mostrar estado contenedores') {
            steps {
                sh 'docker-compose ps'
            }
        }
    }

    post {
        always {
            echo "Pipeline finalizado."
            // Si quieres bajar los contenedores, descomenta la siguiente línea:
            // sh 'docker-compose down'
        }
        success {
            echo "Pipeline completado correctamente!"
        }
        failure {
            echo "Pipeline falló, revisa logs."
        }
    }
}