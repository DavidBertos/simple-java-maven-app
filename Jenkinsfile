pipeline {
    agent any
    stages {
        stage('Build') { 
            steps {
                bat 'mvn -B -DskipTests clean package' 
            }
        }
        stage('Test') {
            steps {
                bat 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Deliver') {
            steps {
                script {
                    // Obtiene el mensaje del último commit
                    def commitMsg = bat(script: 'git log -1 --pretty=%%B', returnStdout: true).trim()
                    if (commitMsg.contains('DO_NOT_DELIVER')) {
                        echo "El commit contiene DO_NOT_DELIVER. Saltando Deliver."
                    } else {
                    // Construye la imagen Docker usando el Dockerfile
                    bat 'docker build -t my-app:latest .'

                    // Elimina el contenedor si ya existe
                    bat 'docker rm -f my-app-container || exit 0'

                    // Detiene todos los contenedores en ejecución (si hay)
                    bat '''
                    for /f "tokens=*" %%i in ('docker ps -q') do docker stop %%i
                    exit /b 0
                    '''

                    // Corre un contenedor basado en esa imagen y mapea el puerto 8080
                    bat 'docker run -d --name my-app-container my-app:latest'
                    }
                }
            }
        }
    }
    post {
        always {
            script {
                def telegramToken = '7578468974:AAGNx0orOs71LJl8Vg3hhl1FYafVrYqjH-Y'
                def chatId = '6369339784'
                def mensaje = "La pipeline ha terminado con estado: ${currentBuild.currentResult}"
                def url = "https://api.telegram.org/bot${telegramToken}/sendMessage?chat_id=${chatId}&text=${URLEncoder.encode(mensaje, 'UTF-8')}"
                httpRequest url: url
            }
        }
    }
}