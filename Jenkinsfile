pipeline {
    agent { label 'docker1' }
    parameters {
        string(name: 'targetDockerRegistryCredentials', defaultValue: '', description: 'Target docker registry credentials') 
        string(name: 'sourceDockerRegistryCredentials', defaultValue: '', description: 'Source docker registry credentials') 

        string(name: 'sourceDockerRegistryHost', defaultValue: 'docker.io', description: 'Source registry host') 
        string(name: 'sourceDockerRegistryOrg', defaultValue: 'store/softwareag', description: 'SOurce registry organization') 
        string(name: 'sourceDockerRepoName', defaultValue: 'webmethods-microservicesruntime', description: 'Source docker repo name') 
        string(name: 'sourceDockerRepoTag', defaultValue: '10.5.0.0', description: 'Source docker repo tag') 

        string(name: 'targetDockerRegistryHost', defaultValue: 'daerepository03.eur.ad.sag:4443', description: 'Target registry host') 
        string(name: 'targetDockerRegistryOrg', defaultValue: 'ccdevops', description: 'Target registry organization') 
        string(name: 'targetDockerRepoName', defaultValue: 'webmethods-microservicesruntime', description: 'Target docker repo name') 
        string(name: 'targetDockerRepoTag', defaultValue: '10.5.0.0', description: 'Target docker repo tag') 
        
        string(name: 'testProperties', defaultValue: ' -DtestISHost=localhost -DtestObject=microservices-runtime -DtestISPort=5555 -DtestISUsername=Administrator -DtestISPassword=manage -DtestDir=./containers/microservices-runtime/assets/Tests', description: 'test properties')
    }
    environment {
      REG_HOST="${params.sourceDockerRegistryHost}"
      REG_ORG="${params.sourceDockerRegistryOrg}"
      REPO_NAME="${params.sourceDockerRepoName}"
      REPO_TAG="${params.sourceDockerRepoTag}"
      TARGET_REG_HOST="${params.targetDockerRegistryHost}"
      TARGET_REG_ORG="${params.targetDockerRegistryOrg}"
      TARGET_REPO_NAME="${params.targetDockerRepoName}"
      TARGET_REPO_TAG="${params.targetDockerRepoTag}"
    }
    stages {
        stage('Build') {
            steps {
                script {
                  dir ('./containers') {
                        docker.withRegistry("https://${params.sourceDockerRegistryHost}", "${params.sourceDockerRegistryCredentials}"){
                            sh "docker-compose config"
                            sh "docker-compose build"
                        }
                  }
                }
            }
        }
        stage('Run') {
            steps {
                script {
                  dir ('./containers') {
                        docker.withRegistry("https://${params.sourceDockerRegistryHost}", "${params.sourceDockerRegistryCredentials}"){
                            sh "docker-compose up -d --force-recreate --remove-orphans microservices-runtime"
                        }
                    }
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    sh "/opt/apache-ant-1.9.15/bin/ant -file build.xml test ${params.testProperties}" 
                }
                dir('./report') {
                    junit '*.xml'
                }
            }
        }
        stage("Push") {
            steps {
                script {
                    dir ('./containers') {
                        docker.withRegistry("https://${params.targetDockerRegistryHost}", "${params.targetDockerRegistryCredentials}"){
                            sh "docker-compose push microservices-runtime"
                        }
                    }
                }
            }
        }
    }
}
