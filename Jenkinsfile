pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' // Test Line
            }
        }
      
    stage('Unit Test Cases') {
            steps {
              sh "mvn test"
            }
            
            post{
              always{
              junit 'target/surefire-reports/*.xml'
              jacoco execPattern: "target/jacoco.exec"  
              }
            }
        }
      
    stage('Docker Build and Push') {
            steps {
              withDockerRegistry([credentialsId: "docker-hub", url: ""]){
                sh 'printenv'
                sh 'docker build -t devopsmela/numeric-app:""$GIT_COMMIT""'
                sh 'docker push devopsmela/numeric-app:""$GIT_COMMIT""'
              }
            }
          }
      }
}
