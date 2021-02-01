# webm-azure-devops
Use this project to create an Azure pipeline for building, testing, and deploying a docker image of webMethods Microservices Runtime.

## Prerequisites
1.  Fork this repository.
2.  Add the Integration Server packages that you want to import in the Microservices Runtime (MSR) image in the containers\microservices-runtime\assets\Packages directory.
3.  Add the webMethods Unit Tests to validate the packages in the containers\microservices-runtime\assets\Tests directory.
4. Log in Docker Hub (https://hub.docker.com/) and checkout the MSR image. Accept the license agreement.
5. Log in Azure DevOps (https://dev.azure.com/). 
6. Create a new project in Azure DevOps.
7. In the new project, go to "Project settings" -> "GitHub connections" -> "Create a GitHub connection to the current repository" to add the webm-azure-devops repository as the source code repository.
8. Create a service connection to the Docker Hub registry that will be used to pull the base images from Docker Hub:
- Go to "Project settings" -> "Service connection" -> "Choose Docker Registry" -> "Select Docker Hub".
- Provide your Docker Hub credentials when prompted, but also make sure you are logged in your account on Docker Hub.
- Give the connection a name that indicates its purpose, such as "dockerHub".
9. Create a service connection to a target docker registry to which to push the images:
- If you have a docker registry, follow the steps in step 8 to set up the target connection to the docker registry that you already use.
- If you do not have a docker registry and want to use the Azure Container Registry, from "Choose Docker Registry" select "Azure Registry". For details see https://portal.azure.com/#create/hub

**Note:** When connecting to an external docker registry, it takes some time for Azure to refresh the systems and show the registry created outside of Azure DevOps.

## Creating and running the Azure pipeline
1. In the Azure project, choose the action to create a new pipeline and select: 
- GitHub YAML for your code base
- the current repository
- existing Azure pipeline

 **Note:** To save the pipeline, click the arrow on the **Run** button and **Save**. After saving the pipeline, you can manage the pipeline configuration.
 
 2. Configure the pipelines variables to use your custom values:
   - `targetDockerRegistryConnection` - the connection to the docker registry to which to push the image.
   Example: `targetDockerRegistryConnection: 'az-reg-sc-01'`
  - `targetDockerRegistryHost` - the host (and port if needed) of the docker registry to which to push the image.
  Example: `targetDockerRegistryHost: 'letswebmacr.azurecr.io'`
  - `targetDockerRegistryOrg` - the organization of the docker registry to which push the image.
  Example: `targetDockerRegistryOrg: 'ccdevops'`
  - `targetDockerRepoName` - the repository name of the created image.
  Example: `targetDockerRepoName: 'webm-azure-devops_microservices-runtime'`
  - `targetDockerRepoTag` - the repository tag of the created image.
  Example: `targetDockerRepoTag:  '10.5'`
  
  - `sourceDockerRegistryConnection` - the connection to Docker Hub (from where the base product image gets pulled).
  Example: `sourceDockerRegistryConnection: 'dockehub'`
  - `sourceDockerRegistryHost` - the host (and port if needed) of the docker registry from which to pull the base product image. (The default is `dockerhub`.)
  Example: `sourceDockerRegistryHost:  'docker.io'`
  - `sourceDockerRegistryOrg` - the organization of the docker registry from which to pull the base product image. (The default is `dockerhub`.)
  Example: `sourceDockerRegistryOrg: 'store/softwareag'`
  - `sourceDockerRepoName` - the repository name of the base product image.
  Example: `sourceDockerRepoName: 'webmethods-microservicesruntime'`
  - `sourceDockerRepoTag` - the repository tag of the base product image.
  Example: `sourceDockerRepoTag: '10.5.0.0'`
  
  - `testDir` - the path to the location of the tests to be executed:
  Example: `testDir: './containers/microservices-runtime/assets/Tests'`
  - `testProperties` - the properties required by the tests.
  Example: `testProperties: ' -DtestISHost=localhost -DtestObject=$(dockerComposeService) -DtestISPort=5555 -DtestISUsername=Administrator -DtestISPassword=manage -DtestDir=$(testDir)'`

**Note:** You can also change the values of the variables from the **Variable** button on the Azure pipeline edit page.

3. Run the pipeline.
