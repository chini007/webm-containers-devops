pipeline {
    agent any
    parameters {
        string(name: 'buildScenario', defaultValue: '', description: 'Asset type to be build and pushed - available options: "microservices-runtime", "universal-messaging"')
        string(name: 'targetImageRegistryCredentials', defaultValue: '', description: 'Target image registry credentials') 
        string(name: 'sourceImageRegistryCredentials', defaultValue: '', description: 'Source image registry credentials') 

        string(name: 'sourceImageRegistryHost', defaultValue: '', description: 'Source registry host') 
        string(name: 'sourceImageRegistryOrg', defaultValue: '', description: 'Source registry organization') 
        string(name: 'sourceImageName', defaultValue: '', description: 'Source image name') 
        string(name: 'sourceImageTag', defaultValue: '', description: 'Source image tag') 

        string(name: 'targetImageRegistryHost', defaultValue: '', description: 'Target image registry host') 
        string(name: 'targetImageRegistryOrg', defaultValue: '', description: 'Target image registry organization') 
        string(name: 'targetImageName', defaultValue: '', description: 'Target image name') 
        string(name: 'targetImageTag', defaultValue: '', description: 'Target image tag') 
        booleanParam(name: 'runTests', defaultValue: true, description: 'Whether to run test stage')

        string(name: 'testProperties', defaultValue: ' -DtestISHost=localhost -DtestObject=microservices-runtime -DtestISPort=5555 -DtestISUsername=Administrator -DtestISPassword=manage -DtestDir=./containers/microservices-runtime/assets/Tests', description: 'test properties')
    }
    environment {
      REG_HOST="${params.sourceImageRegistryHost}"
      REG_ORG="${params.sourceImageRegistryOrg}"
      REPO_NAME="${params.sourceImageName}"
      REPO_TAG="${params.sourceImageTag}"
      TARGET_REG_HOST="${params.targetImageRegistryHost}"
      TARGET_REG_ORG="${params.targetImageRegistryOrg}"
      TARGET_REPO_NAME="${params.targetImageName}"
      TARGET_REPO_TAG="${params.targetImageTag}"
    }
    stages {
        stage('Build') {
            steps {
                script {
                  dir ('./containers') {
                        docker.withRegistry("https://${params.sourceImageRegistryHost}", "${params.sourceImageRegistryCredentials}"){
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
                        docker.withRegistry("https://${params.sourceImageRegistryHost}", "${params.sourceImageRegistryCredentials}"){
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
                    sh "ant -file build.xml test ${params.testProperties}" 
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
                        docker.withRegistry("https://${params.targetImageRegistryHost}", "${params.targetImageRegistryCredentials}"){
                            sh "docker-compose push ${params.buildScenario}"
                        }
                    }
                }
            }
        }
    }
}
