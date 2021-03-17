pipeline {
    agent any
   
    parameters {
        string(name: 'buildScenario', defaultValue: 'microservices-runtime', description: 'Asset type to be build and pushed - available options: "microservices-runtime", "universal-messaging"')
        string(name: 'sourceImageRegistryCredentials', defaultValue: '', description: 'Source image registry credentials') 

        string(name: 'sourceImageRegistryHost', defaultValue: 'docker.io', description: 'Source registry host') 
        string(name: 'sourceImageRegistryOrg', defaultValue: 'store/softwareag', description: 'Source registry organization') 
        string(name: 'sourceImageName', defaultValue: 'webmethods-microservicesruntime', description: 'Source image name') 
        string(name: 'sourceImageTag', defaultValue: '10.5', description: 'Source image tag') 

        
        string(name: 'testContainerHost', defaultValue: 'localhost', description: 'Host where the test container will be exposed') 
        string(name: 'testContainerPort', defaultValue: '5555', description: 'Port under which the test container will be reachable')       
        
        string(name: 'targetImageRegistryCredentials', defaultValue: '', description: 'Target image registry credentials') 
        string(name: 'targetImageRegistryHost', defaultValue: '', description: 'Target image registry host') 
        string(name: 'targetImageRegistryOrg', defaultValue: '', description: 'Target image registry organization') 
        string(name: 'targetImageName', defaultValue: '', description: 'Target image name. Small caps only.') 
        string(name: 'targetImageTag', defaultValue: '', description: 'Target image tag. A tag name must be valid ASCII and may contain lowercase and uppercase letters, digits, underscores, periods and dashes. A tag name may not start with a period or a dash and may contain a maximum of 128 characters.') 
        booleanParam(name: 'runTests', defaultValue: true, description: 'Whether to run test stage')

        //string(name: 'testProperties', defaultValue: ' -DtestISHost=localhost -DtestObject=microservices-runtime -DtestISPort=5555 -DtestISUsername=Administrator -DtestISPassword=manage -DtestDir=./containers/microservices-runtime/assets/Tests', description: 'test properties')
        string(name: 'testProperties', defaultValue: ' -DtestISUsername=Administrator -DtestISPassword=manage', description: 'test properties. The default are covering the IS test case.')
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
                    def testsDir = "./containers/microservices-runtime/assets/Tests"
                    sh "ant -file build.xml test -DtestISHost=${testContainerHost} -DtestISPort=${testContainerPort} -DtestObject=${params.buildScenario} -DtestDir=${testsDir} ${params.testProperties}" 
                }
                dir('./report') {
                    junit '*.xml'
                }
            }
        }
        stage('Stop') {
            steps {
                script {
                  dir ('./containers') {
                        sh "docker-compose stop ${params.buildScenario}"
                    }
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
