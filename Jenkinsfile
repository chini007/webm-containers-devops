pipeline {
    agent { label 'docker1' }
    parameters {
        string(name: 'buildScenario', defaultValue: '', description: 'Asset type to be build and pushed - available options: "microservices-runtime", "universal-messaging"')
        string(name: 'targetContainerRegistryCredentials', defaultValue: '', description: 'Target container registry credentials') 
        string(name: 'sourceContainerRegistryCredentials', defaultValue: '', description: 'Source container registry credentials') 

        string(name: 'sourceContainerRegistryHost', defaultValue: '', description: 'Source registry host') 
        string(name: 'sourceContainerRegistryOrg', defaultValue: '', description: 'Source registry organization') 
        string(name: 'sourceContainerName', defaultValue: '', description: 'Source container name') 
        string(name: 'sourceContainerTag', defaultValue: '', description: 'Source container tag') 

        string(name: 'targetContainerRegistryHost', defaultValue: '', description: 'Target registry host') 
        string(name: 'targetContainerRegistryOrg', defaultValue: '', description: 'Target registry organization') 
        string(name: 'targetContainerName', defaultValue: '', description: 'Target image name') 
        string(name: 'targetContainerTag', defaultValue: '', description: 'Target image tag') 
        booleanParam(name: 'runTests', defaultValue: true, description: 'Whether to run test stage')

        string(name: 'testProperties', defaultValue: ' -DtestISHost=localhost -DtestObject=microservices-runtime -DtestISPort=5555 -DtestISUsername=Administrator -DtestISPassword=manage -DtestDir=./containers/microservices-runtime/assets/Tests', description: 'test properties')
    }
    environment {
      REG_HOST="${params.sourceContainerRegistryHost}"
      REG_ORG="${params.sourceContainerRegistryOrg}"
      REPO_NAME="${params.sourceContainerName}"
      REPO_TAG="${params.sourceContainerTag}"
      TARGET_REG_HOST="${params.targetContainerRegistryHost}"
      TARGET_REG_ORG="${params.targetContainerRegistryOrg}"
      TARGET_REPO_NAME="${params.targetContainerName}"
      TARGET_REPO_TAG="${params.targetContainerTag}"
    }
    stages {
        stage('Build') {
            steps {
                script {
                  dir ('./containers') {
                        docker.withRegistry("https://${params.sourceContainerRegistryHost}", "${params.sourceContainerRegistryCredentials}"){
                            sh "docker-compose config"
                            sh "docker-compose build ${params.buildScenario}"
                        }
                  }
                }
            }
        }
        stage('Run') {
            steps {
                script {
                  dir ('./containers') {
                        docker.withRegistry("https://${params.sourceContainerRegistryHost}", "${params.sourceContainerRegistryCredentials}"){
                            sh "docker-compose up -d --force-recreate --remove-orphans ${params.buildScenario}"
                        }
                    }
                }
            }
        }
        stage('Test') {
            when {
                expression {
                    return params.runTests
                }
            }
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
                        docker.withRegistry("https://${params.targetContainerRegistryHost}", "${params.targetContainerRegistryCredentials}"){
                            sh "docker-compose push ${params.buildScenario}"
                        }
                    }
                }
            }
        }
    }
}
