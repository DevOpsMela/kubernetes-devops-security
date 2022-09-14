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
    }
}
