# README: Easiest CI/CD pipeline installation you'll ever use
### Disclaimer: I didn't write the javaScript. That was AI

This pipeline automates the deployment process for your web application. It pulls code from this GitHub repository, creates and pushes a Docker image to your DockerHub repository, provisions an EC2 instance with Terraform, configures and deploys web app to the EC2 instance with Ansible, and provides the IP for accessing the web application.

![Screenshot from 2024-03-20 08-21-06](https://github.com/samdroberts87/snakejs/assets/127436118/0b35caf9-42b9-466b-8d52-0df3976d2620)



## Prerequisites:

- You need a AWS account (free tier is enough)
- dockerhub account
- Make sure there's no application running on port 8080 on your host machine.
- Have docker engine installed on your host machine
- You DO NOT need pre-existing knowledge of the tools on show here. This walks you through everything!

## Setup Instructions:

Run the following command to start the custom Jenkins image inside a Docker container:
```
docker run -v /var/run/docker.sock:/var/run/docker.sock -it -p 8080:8080 samdroberts/jenkinsimage
```
IMPORTANT - do not exit out of this terminal or the jenkins server will stop.

Navigate to your browser and head to AWS console to configure your AWS account:
- Create a new key pair named `Pipeline` from the AWS Management Console. Copy the downloaded Pipeline.pem file into the `/var/lib/jenkins/workspace` directory of the container. The pipeline will pull this in as part of the process.
- Configure your default security group in the AWS Management Console to allow incoming traffic on port 22 for SSH and outgoing traffic HTTP all so the app can be viewed when it's deployed.
- create IAM user with full EC2 access
- Keep this browser window open during this whole process
- Now, head back to your terminal

1. Configure the following inside the container's CLI (whihc will have opened after the run command):

- **AWS-cli:** Run ```aws configure``` and enter your AWS IAM details. Set your region to `us-west-2`. 
    Following this, add your access and secret keys as environmental variables in the container using the following commands:
  ```
  export AWS_ACCESS_KEY_ID=REPLACETHISWITHYOURACCESSKEY 
  export AWS_SECRET_ACCESS_KEY=REPLACETHISWITHYOURSECRETKEY
  ```
- **Docker:** Run ```docker login``` and enter your DockerHub details.
- **Start jenkins:** Run ```service jenkins start && cat /var/lib/jenkins/secrets/initialAdminPassword``` and make a note of the output, you'll need this for jenkins.

2. Access and configure Jenkins by navigating to http://localhost:8080 in your web browser and, when prompted, paste the password from the output of your last command.
3. Complete desired user login details when prompted and, on the next page, select the "install reccomended plugins" option.
4. Once this has completed and you are logged into the jenkins dashboard, head to `MANAGE JENKINS` > `PLUGINS` >`AVAILABLE PLUGINS` and search for and install the following plugins:
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

It's vital you follow the naming convention laid out above for `aws` & `docker` `ID` because they are reffered to in variables within the Groovy script. If you call them something else, it WONT be able to find your credentials.

7. Create pipeline:
- `DASHBOARD` > `NEW ITEM` > `name your pipeline 'pipeline-project'` > `PIPELINE` > `OK`
- Give short description and scroll to the Groovy script part (quick note, all other options are left defautl, you dont need to check any boxes).
  Paste in the code found at this link - https://github.com/samdroberts87/snakejs/blob/main/jenkinsfile
- Update the following parts of the groovy script:
  - Docker: Replace `YOURDOCKERUSERNAME` with your actual DockerHub username.
  
  - Momentarily navigate away from Jenkins and to your terminal
  - SSH: Create an SSH key pair on your host machine (not in the container cli, use a different terminal session to do this) with following command ```ssh-keygen``` and hit enter each time when promted to leave settings as default. Your file will then be saved in the default directory and will be accesible with the following command ```cat ~/.ssh/id_rsa.pub```. Copy the output and head back to your browser, paste the output of this command in the pipeline's `YOURPUBLICKEY` section.

With the above configurations the pipeline should work without problem. 
DONT FORGET TO CLOSE EC2 INSTANCES when you're done. I DO NOT TAKE ANY RESPONSIBILITY FOR AWS CHARGES!

**Note:** If you encounter any issues, feel free to troubleshoot with me. I've likely faced similar challenges while setting up this pipeline.

![62a736b5223343fbc2207cf2](https://github.com/samdroberts87/snakejs/assets/127436118/e1639eef-b9e5-4ebc-9139-c965af421a01)
