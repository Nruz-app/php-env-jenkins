# Documentacion e Instalacion Jenkins 

[jenkins io](https://www.jenkins.io/doc/book/installing/)

# Docker Hub Jenkins 

[Docker Hub](https://hub.docker.com/r/jenkins/jenkins)

# Comando limpiar docker
``` 
docker-compose down
docker system prune -a --volumes -f
```
# Comando Para countruir la imagen local y prod
``` 
docker-compose build
docker-compose -f docker-compose.prod.yml build
```
# Comado para levantar imagen local y prod
```
docker-compose up -d
docker-compose -f docker-compose.prod.yml up -d
```

# Comado para obtener Initial Password
```
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

# LocalHost:6162 

[Home Jenkins](http://localhost:8080/)

