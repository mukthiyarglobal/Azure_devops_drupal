pipeline {
    agent any
    environment {
        //once you sign up for Docker hub, use that user_id here
        registry = "drupalacr01.azurecr.io/drupal"
        //- update your credentials ID after creating credentials for connecting to Docker Hub
        registryCredential = 'azure_acr_drupal'
        dockerImage = ''
        DOCKER_TAG = "$BUILD_NUMBER"
    } 
    stages {
        stage ('checkout') {
            steps {
                git credentialsId: 'Github_login', url: 'https://github.com/mukthiyarglobal/Azure_devops_drupal.git'
            }
        }
        stage ('build docker image') {
            steps {
                script {
                    dockerImage = docker.build registry
                    dockerImage.tag("${DOCKER_TAG}") // Add dynamic tag
                }
            }
        }
        stage ('push image into acr') {
            steps {
                script {
                    // docker.withRegistry('', registryCredential) {
                    //     //dockerImage.push()
                    //     dockerImage.push("${registry}:${BUILD_NUMBER}") // Push image with dynamic tag
                    // }
                    withCredentials([usernamePassword(credentialsId: 'azure_acr_drupal', passwordVariable: 'password', usernameVariable: 'username')]) {
                       sh 'docker login -u ${username} -p ${password} ${registry}'
                    }
                    sh "docker push ${registry}:${DOCKER_TAG}"
                   // sh "docker push ${registry}:latest"
                }
            }
        }
        stage ('K8S Deploy') {
            steps {
                script {
                    sh "sed -i 's|{{DOCKER_TAG}}|${DOCKER_TAG}|g' deployment.yml"
                   withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'K8S', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                    sh ('kubectl apply -f deployment.yml')
                   }           
                }
            }
            
        }
    }
}
