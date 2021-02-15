pipeline {
    agent { label 'docker1' }
    parameters {
        string(name: 'targetDockerRegistryHost', defaultValue: 'daerepository03.eur.ad.sag:4443', description: 'Target registry host') 
        string(name: 'targetDockerRegistryOrg', defaultValue: 'sagdevops', description: 'Target registry organization') 
        string(name: 'targetDockerRepoName', defaultValue: 'webmethods-microservicesruntime', description: 'Target docker repo name') 
        string(name: 'targetDockerRepoTag', defaultValue: '10.5.0.0', description: 'Target docker repo tag') 

        string(name: 'sourceDockerRegistryHost', defaultValue: 'docker.io', description: 'Source registry host') 
        string(name: 'sourceDockerRegistryOrg', defaultValue: 'store/softwareag', description: 'SOurce registry organization') 
        string(name: 'sourceDockerRepoName', defaultValue: 'webmethods-microservicesruntime', description: 'Source docker repo name') 
        string(name: 'sourceDockerRepoTag', defaultValue: '10.5.0.0', description: 'Source docker repo tag') 
    }
    environment {
      REG_HOST='$sourceDockerRegistryHost'
      REG_ORG='$sourceDockerRegistryOrg'
      REPO_NAME='$sourceDockerRepoName'
      REPO_TAG='$sourceDockerRepoTag'
      TARGET_REG_HOST='$targetDockerRegistryHost'
      TARGET_REG_ORG='$targetDockerRegistryOrg'
      TARGET_REPO_NAME='$targetDockerRepoName'
      TARGET_REPO_TAG='$targetDockerRepoTag'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    sh "docker-compose -f containers/docker-compose.yml config"
                    sh "docker-compose -f containers/docker-compose.yml build"
                    }
                }
            }
        stage('Run') {
            steps {
                script {
                     sh "docker-compose -f containers/docker-compose.yml run"
                }
            }
        }
    }
}
