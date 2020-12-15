# webm-azure-devops
Creating a pipeline project for building, testing and deploying a docker image

Prerequisites:
0. Create a project with the format as 'https://github.com/YanaSimeonova/webmethods-sample-project-layout.git'. It will contain the assets to import in the image (packages) and tests to validate if they are fine.

1. Log in https://dev.azure.com/
2. Create a github connection to the current repository
3. Create a service connection to docker hub registry (it will be used for pulling the base images)
4. Create a service connection to a docker registry which will be used to push the images to.


1. Create a new pipeline 
 - select github yaml for your code base
 - select the current repository
 - select existing azure pipeline
 
 2. Configure pipelines variables to use your custom values
 The path to the github project with the assets and tests:
  gitProject: 'https://github.com/YanaSimeonova/webmethods-sample-project-layout.git'
 The connection to docker registry from pre-requisite 4 
  dockerRegistryConnection: 'az-reg-sc-01'
 The docker registry to push the image to:
  dockerRegistry: 'letswebmacr.azurecr.io/ccdevops'
 The image will be taged with: 
  image: 'yanasimeonovawebm-azure-devops_microservices-runtime'
 The connection to docker hub, created in the pre-requisite 3 
  baseDockerRegistryConnection: 'dockehub'
 The path to the tests to be executed: 
  testDir: './containers/microservices-runtime/webmethods-sample-project-layout/assets/IS/Tests'
 The project name: 
  projectName: 'webmethods-sample-project-layout'
 Test properties: 
  testProperties: ' -DtestISHost=localhost -DtestObject=$(dockerComposeService) -DtestISPort=5555 -DtestISUsername=Administrator -DtestISPassword=manage -DprojectName=$(projectName) -DtestDir=$(testDir)'


3. Run the pipeline.

