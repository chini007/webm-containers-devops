# webm-azure-devops
Creating a pipeline project for building, testing and deploying a docker image

Pre-requisites:
1.  Create a github project with the same format as 'https://github.com/YanaSimeonova/webmethods-sample-project-layout.git'. 
    It will contain:
  - assets(packages) to import in MSR image 
  - tests to validate that the assets are working as expected
2. Log into  docker hub and checkout the MSR image. You have to accept the license agreement.
3. Log in https://dev.azure.com/ 
4.	Create a new project
5. Create a github connection to the current repository
From "Project settigns" -> "GitHub connections create a GitHub connection to the current repository"
6. Create a service connection to docker hub registry (it will be used for pulling the base images)
From "Project settings" -> "Service connection" -> "Choose Docker Registry" -> "Select docker hub" -> provide your docker hub credentials -> give the connection a proper name like "dockerHub". 
Note: Step 2 should be done as a pre-requisite to this step. 

6. Create a service connection to a docker registry which will be used to push the images to.
Same as point 3, but this is the target connection. If you don't have one use the one from azure
Guide how to achieve it can be found here
https://portal.azure.com/#create/hub
If using the Azure Container Registry - from the Docker registry connection tab from step 3, pick Azure Registry. Note! It takes Azure time to refresh the systems and show the registry created outside of AzureDevOps.

Creating and running the pipeline steps:
1. Create a new pipeline 
 -> Select github yaml for your code base
 -> Select the current repository
 -> Select existing azure pipeline
 Note: Save the pipeline (Click on arrow on button Run -> button Save will appear) and then you will be able to reconfigure it.
 
 2. Configure pipelines variables to use your custom values
  - The path to the github project with the assets and tests:
  gitProject: 'https://github.com/YanaSimeonova/webmethods-sample-project-layout.git'
   - The connection to docker registry from pre-requisite 4 
  dockerRegistryConnection: 'az-reg-sc-01'
  - The docker registry to push the image to:
  dockerRegistry: 'letswebmacr.azurecr.io/ccdevops'
  - The image will be taged with: 
  image: 'yanasimeonovawebm-azure-devops_microservices-runtime'
  - The connection to docker hub, created in the pre-requisite 3 
  baseDockerRegistryConnection: 'dockehub'
  - The path to the tests to be executed: 
  testDir: './containers/microservices-runtime/webmethods-sample-project-layout/assets/IS/Tests'
  - The project name: 
  projectName: 'webmethods-sample-project-layout'
  - Test properties: 
  testProperties: ' -DtestISHost=localhost -DtestObject=$(dockerComposeService) -DtestISPort=5555 -DtestISUsername=Administrator -DtestISPassword=manage -DprojectName=$(projectName) -DtestDir=$(testDir)'


3. Run the pipeline.

