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