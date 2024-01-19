Deploy a Temporal cluster to production

https://docs.temporal.io/diagrams/basic-platform-topology-cloud.svg

PART 1
setting up Temporal cloud

1. //Requested a Temporal cloud account from [Request form](https://pages.temporal.io/cloud-request-access)
2. switched to self hosted temporal cluster guide
3. run temporal cluster in docker container
4. Launch ec2 instance for Temporal server on an amazon linux image
5. connect to instance using ec2 instance connect
6. become root user `sudo -i`
7. install docker on instance `sudo yum install -y docker`
8. start docker service `sudo service docker start`
9. Add the ec2-user to the docker group so that you can run Docker commands without using sudo. `sudo usermod -a -G docker ec2-user`
10. log out and log back in to start a new session som that ec2-user picks up permission
11. run `service docker status` to confirm docker is up and running
12. install git `sudo yum install git`
13. confirm it's installed `git --version`
14.Clone the Temporal docker compose repo ` git clone https://github.com/temporalio/docker-compose.git ` 
 <img width="1366" alt="image" src="https://github.com/abdulxs/hello-workflow/assets/18741380/53a39f7a-3502-4e37-95e0-7b12fdeda5f0">

14. cd into the repo `cd docker-compose`
15. came across error `command noit found`
16. fix: install docker compose tool, run commands `sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`
17. then `sudo chmod +x /usr/local/bin/docker-compose`
18. run the docker container `docker-compose up`
19. <img width="1393" alt="image" src="https://github.com/abdulxs/hello-workflow/assets/18741380/d0462587-57d9-4116-91d3-3637288d35fe">

PART 2

Package Temporal App as a Docker image

1. clone the app repo `git clone https://github.com/abdulxs/hello-workflow.git`
2. create dockerfile. See `dockerfile`

Write a CI/CD for the app
See `.github/workflows/main.yml`
set repo secrets
![ci/cd](https://github.com/abdulxs/hello-workflow/assets/18741380/80d1f8b7-353e-40d6-b2de-787fdd025165)

As part of the workflow, I deployed the docker image to the docker-hub. 

Provision EKS cluster with Terraform see `./terraform/`

![EKS Cluster on AWS console](https://github.com/abdulxs/Containerized-Workflow/assets/18741380/d6aea814-d57b-4e6a-b6ae-6ae363efb035)

create manifest, see `starter.yaml`

deploy application to EKS cluster
