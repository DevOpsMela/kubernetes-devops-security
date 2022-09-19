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
    
        stage('Mutation Tests - PIT') {
            steps {
              sh "mvn org.pitest:pitest-maven:mutationCoverage"
            }
            post{
              always{
                pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'  
              }
            }
        }
    
//           stage('SonarQube Scan') {
//             steps {
//               sh "mvn clean verify sonar:sonar \
//                  -Dsonar.projectKey=numeric-application \
//                  -Dsonar.host.url=http://20.127.102.255:9000 \
//                  -Dsonar.login=sqp_81947c5801381b6b8726e9fae3e2e4c90b7e2aed" 
//             }
//         }
    
          stage('SonarQube - SAST') {
            steps {
              withSonarQubeEnv('SonarQube') {
                sh "mvn sonar:sonar \
                        -Dsonar.projectKey=numeric-application \
                        -Dsonar.host.url=http://20.127.102.255:9000"
              }
              timeout(time: 2, unit: 'MINUTES') {
                script {
                  waitForQualityGate abortPipeline: true
                }
              }
            }
          }

      
    stage('Docker Build and Push') {
            steps {
              withDockerRegistry([credentialsId: "docker-hub", url: ""]){
                sh 'printenv'
                sh 'docker build -t devopsmela/numeric-app:""$GIT_COMMIT"" .'
                sh 'docker push devopsmela/numeric-app:""$GIT_COMMIT""'
              }
            }
          }
    
    stage('Kubernetes Deployment - Dev ') {
            steps {
              withKubeConfig([credentialsId: "kubeconfig"]){
                sh "sed -i 's#replace#devopsmela/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
                sh 'kubectl apply -f k8s_deployment_service.yaml'
              }
            }
          }
      }
}
