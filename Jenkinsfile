stage('Ejecutar PHP en Docker con Apache') {
    steps {
        script {
            docker.image('php:8.2-apache').inside('-p 8080:80') {
                sh '''
                    cp .env /var/www/html/.env
                    cp index.php /var/www/html/index.php
                    apache2-foreground &
                    sleep 5
                '''
            }
        }
    }
}