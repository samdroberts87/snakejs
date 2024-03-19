# README: Automated Deployment Pipeline Setup

This pipeline automates the deployment process for your web application. It pulls code from a specified GitHub repository, creates and pushes a Docker image to your DockerHub repository, provisions an EC2 instance with Terraform, configures the EC2 instance with Ansible, and provides the URL for accessing the web application.

## Prerequisites:

- You need a AWS account (free tier is enough)
- dockerhub account
- Make sure there's no application running on port 8080 on your host machine.
- Have docker engine installed on your host machine

## Setup Instructions:

Run the following command to start the custom Jenkins image inside a Docker container:
```
docker run -v /var/run/docker.sock:/var/run/docker.sock -it -p 8080:8080 samdroberts/jenkinsimage
```
IMPORTANT - do not exit out of this terminal or the jenkins server will stop.

1. Configure the following inside the container's CLI (whihc will have opened after the run command):

- **AWS-cli:** Run ```aws configure``` and enter your AWS IAM details. Set your region to `us-west-2`. 
    Following this, add your access and secret keys as environmental variables using the following commands:
  ```
  export AWS_ACCESS_KEY_ID=REPLACETHISWITHYOURACCESSKEY 
  export AWS_SECRET_ACCESS_KEY=REPLACETHISWITHYOURSECRETKEY
  ```
- **Docker:** Run ```docker login``` and enter your DockerHub details.
- **Start jenkins:** Run ```service jenkins start && cat /var/lib/jenkins/secrets/initialAdminPassword``` and make a note of the output, you'll need this for jenkins.

2. Access and configure Jenkins by navigating to http://localhost:8080 in your web browser and, when prompted, paste the password from the ooutput of your last commad.
3. Complete user details as prompted and on the next page, select the "install reccomended plugins" option.
4. Once completed and logged into jenkins dashboard, head to `MANAGE JENKINS` > `PLUGINS` >`AVAILABLE PLUGINS` and search for and install the following plugins:
   `Docker`, `Docker Pipeline`, `docker-build-step`, `CloudBees Docker Build and Publish`, `Terraform`, `Ansible`, `AWS Credentials`.
5. Restart jenkins
6. Configure AWS and Docker credentials in Jenkins:
- Go to `DASHBOARD` > `MANAGE JENKINS` > `CREDENTIALS` > `GLOBAL` > `ADD CREDENTIALS`
- Docker credentials
      kind: username and password
      scope: default
      username: `YOUR DOCKERHUB USERNAME`
      password: `YOUR DOCKERHUB PASSWORD`
      ID: `docker`
      Description `docker`
- AWS credentials
      kind: AWS credentials
      scope: default
      ID: `aws`
      Description: `aws`
      Access key: `YOUR AWS ACCESS KEY`
      Secret Access Key: `YOUR AWS SECRET ACCESS KEY`        

7. Create pipeline:
- `DASHBOARD` > `NEW ITEM` > `name your pipeline 'pipeline-project'` > `pipeline` > `OK`
- Give short description and scroll to the Groovy script part. Paste the code from the jenkinsfile in this github repository.
- Update the following:
  - Docker: Replace `YOURDOCKERUSERNAME` with your actual DockerHub username.
  - SSH: Create an SSH key pair on your host machine (not in the container cli, use a different terminal session to do this) with following command ```ssh-keygen``` and hit enter each time when promted to leave settings as default. Your file will then be saved in the default directory and will be accesible with the following command ```cat ~/.ssh/id_rsa.pub```. Paste the output of this command in the pipeline's `YOURPUBLICKEY` section.

8. Other AWS configurations:
- Create a new key pair named `Pipeline` from the AWS Management Console. Save the downloaded Pipeline.pem file into the `/var/lib/jenkins/workspace` directory of the container. The pipeline will pull this in as part of the process.
- Configure your default security group in the AWS Management Console to allow incoming traffic on port 22 for SSH and outgoing traffic HTTP all.

With the above configurations the pipeline should work without problem. 
DONT FORGET TO CLOSE EC2 INSTANCES. I DO NOT TAKE ANY RESPONSIBILITY FOR AWS CHARGES!

**Note:** If you encounter any issues, feel free to troubleshoot with me. I've likely faced similar challenges while setting up this pipeline.
