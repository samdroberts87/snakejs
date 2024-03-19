# README: Automated Deployment Pipeline Setup

This pipeline automates the deployment process for your web application. It pulls code from a specified GitHub repository, creates and pushes a Docker image to your DockerHub repository, provisions an EC2 instance with Terraform, configures the EC2 instance with Ansible, and provides the URL for accessing the web application.

## Prerequisites:

- You need a AWS account (free tier is enough)
- dockerhub account
- Make sure there's no application running on port 8080 on your host machine.

## Setup Instructions:

1. Run the following command to start the custom Jenkins image inside a Docker container:

docker run -v /var/run/docker.sock:/var/run/docker.sock -it -p 8080:8080 samdroberts/jenkinsimage

IMPORTANT - do not exit out of this terminal or the jenkins server will stop.


2. Configure the following inside the container's CLI (whihc will have opened after the run command):

first, start Jenkins - 'service jenkins start'

- **AWS-cli:** Run `aws configure` and enter your AWS IAM details. Set your region to `us-west-2`. 
    Following this, add your access and secret keys as environmental variables using the following commands:
  ```
  export AWS_ACCESS_KEY_ID=REPLACETHISWITHYOURACCESSKEY 
  export AWS_SECRET_ACCESS_KEY=REPLACETHISWITHYOURSECRETKEY
  ```
- **Docker:** Run `docker login` and enter your DockerHub details.

4. Access and configure Jenkins by navigating to http://localhost:8080 in your web browser. Use the username `admin` and password `admin`.

5. Configure AWS and Docker credentials in Jenkins:
- Go to `DASHBOARD` > `MANAGE JENKINS` > `CREDENTIALS`.
- Update the current credentials with yours, leaving the name as `aws` and `docker` respectively.

6. Edit the pipeline details in Jenkins:
- Go to the pipeline named "pipeline-project" and edit the Groovy script.
- Update the following:
  - Docker: Replace `YOURDOCKERUSERNAME` with your actual DockerHub username.
  - SSH: Create an SSH key pair on your host machine (not in the container cli, use a different terminal session to do this) with following command `ssh-keygen`, then paste your public key in the pipeline's `YOURPUBLICKEY` section.

7. Other AWS configurations:
- Create a new key pair named `Pipeline` from the AWS Management Console. Save the file into the `/var/lib/jenkins/workspace` directory of the container. The pipeline will pull this in as part of the process.
- Configure your default security group in the AWS Management Console to allow incoming traffic on port 22 for SSH and outgoing traffic HTTP all.

**Note:** If you encounter any issues, feel free to troubleshoot with me. I've likely faced similar challenges while setting up this pipeline.
