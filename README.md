# webm-azure-devops
Creating a pipeline project for building, testing and deploying a docker image

Pre-requisites:
1.  Fork the current github project
2.  In directory containers\microservices-runtime\assets\Packages place Integration Server packages which you would like to import in MSR image
3.  In directory containers\microservices-runtime\assets\Tests place wM Unit Tests to validate the packages
4. Log into  docker hub and checkout the MSR image. You have to accept the license agreement.
5. Log in https://dev.azure.com/ 
6. Create a new project in Azure DevOps
7. Create a github connection to the current repository
From "Project settigns" -> "GitHub connections create a GitHub connection to the current repository"
8. Create a service connection to docker hub registry (it will be used for pulling the base images)
From "Project settings" -> "Service connection" -> "Choose Docker Registry" -> "Select docker hub" -> provide your docker hub credentials -> give the connection a proper name like "dockerHub". 
Note: Step 4 should be done as a pre-requisite to this step. 
9. Create a service connection to a docker registry which will be used to push the images to.
Same as point 8, but this is the target connection. If you don't have a docker registry, use the one from azure
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
   - targetDockerRegistryConnection - the connection to docker registry from pre-requisite 4 
  Ex: targetDockerRegistryConnection: 'az-reg-sc-01'
  - targetDockerRegistryHost - the host(and port if needed) of the docker registry to push the image to
  Ex: targetDockerRegistryHost: 'letswebmacr.azurecr.io'
  - targetDockerRegistryOrg - the organization of the docker registry to push the image to.
  Ex: targetDockerRegistryOrg: 'ccdevops'
  - targetDockerRepoName - the repository name of the created image
  Ex: targetDockerRepoName: 'webm-azure-devops_microservices-runtime'
  - targetDockerRepoTag - the repository tag of the created image
  Ex: targetDockerRepoTag:  '10.5'
  
  - sourceDockerRegistryConnection - the connection to docker hub, created in the pre-requisite 3 
  Ex: sourceDockerRegistryConnection: 'dockehub'
  - sourceDockerRegistryHost - the host(and port if needed) of the docker registry to pull the base product image from (default is dockerhub)
  Ex: sourceDockerRegistryHost:  'docker.io'
  - sourceDockerRegistryOrg - the organization of the docker registry to pull the base product image from (default is dockerhub)
  Ex: sourceDockerRegistryOrg: 'store/softwareag'
  - sourceDockerRepoName - the repository name of the base product image 
  Ex: sourceDockerRepoName: 'webmethods-microservicesruntime'
  - sourceDockerRepoTag - the repository tag of the base product image 
  Ex: sourceDockerRepoTag: '10.5.0.0'
  
  - testDir - the path to the tests to be executed: 
  Ex: testDir: './containers/microservices-runtime/assets/Tests'
  - testProperties - the properties required by the tests: 
   testProperties: ' -DtestISHost=localhost -DtestObject=$(dockerComposeService) -DtestISPort=5555 -DtestISUsername=Administrator -DtestISPassword=manage -DtestDir=$(testDir)'

Note: You can change the variables values also from Azure pipeline edit page from Variable button.

3. Run the pipeline.

