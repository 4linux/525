node {
    def servers = [100,200]
    def server = servers[new Random().nextInt(servers.size())]
    def img = 'viniciusfelix1/php-login'
    def parameters = [
        '--restart always',
        "--name ${JOB_BASE_NAME}",
        "--network ${JOB_BASE_NAME}",
        '--ip 192.168.10.10',
        '--add-host=memcached:172.27.11.30',
        '-e DB_HOST=172.27.11.30',
        '-e DB_PORT=3306',
        '-e DB_NAME=infraagil',
        '-e DB_USER=devops',
        '-e DB_PASS=4linux'
    ]
    try {
        docker.withServer("172.27.11.${server}:2375") {
            println "Utilizando servidor 172.27.11.${server}"
            stage('Build') {
                git branch: 'dev', credentialsId: 'jenkins', url: 'git@172.27.11.10:devops/php-login.git'
                sh 'rm -rf .git*'
                sh "sed -i 's/8080/80/' docker/Dockerfile"
                docker.build(img, '-f docker/Dockerfile .')
            }
            stage('Test') {
                sh "docker-compose -p $JOB_BASE_NAME -f docker/docker-compose.yml up -d"
                sleep 10
                sh "docker exec -i ${JOB_BASE_NAME}_mysql_1 mysql -u root -p'Abc123!' php < db/dump.sql"
                ip = sh(returnStdout: true, script: "docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${JOB_BASE_NAME}_app_1").trim()
                docker.image('alpine').withRun("--tty --interactive --network ${JOB_BASE_NAME}_default") { alpine ->
                    sh "docker exec ${alpine.id} apk add --no-cache curl"
                    sh "docker exec ${alpine.id} curl -sL ${ip}:80 > /dev/null"
                    output = sh(returnStdout: true, script: "docker exec ${alpine.id} curl -sL --cookie-jar cookie -d 'username=victor@frankenstein.co.uk&pass=123' ${ip}:80/login.php").trim()
                    if(!output.contains('Bem Vindo!'))
                    error("Login falhou!")
                }
            }
            stage('Save') {
                docker.withRegistry('https://index.docker.io/v1/', 'dockerregistry') {
                    docker.image(img).push()
                }
            }
        }
        stage('Deploy') {
            servers.each {
                docker.withServer("172.27.11.${it}:2375") {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerregistry') {
                        docker.image(img).pull()
                    }
                    sh "docker network create --subnet 192.168.10.0/24 ${JOB_BASE_NAME} || /bin/true"
                    sh "docker rm -f ${JOB_BASE_NAME} || /bin/true"
                    docker.image(img).run(parameters.join(' '))
                }
            }
        }
    } catch (ex) {
        throw ex
    } finally {
        docker.withServer("172.27.11.${server}:2375") {
            sh "docker-compose -p $JOB_BASE_NAME -f docker/docker-compose.yml down -v"
        }
    }
}
