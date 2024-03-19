this pipeline will 
pull from YOUR gothub repo > create and push docker image to YOUR dockerhub repo > create an EC2 with terraform > configure the EC2 with ansible > output the url for you to access the webapp


in order for this to work out of the box (ish) you'll need to configure the installed applications in the container and configure your credentials in jenkins. You'll also need to make sure you don't have anything running on port 8080 on your host machine.

To start with, you will run the following command to run a custom jenkins image inside a docker container:
docker run -v /var/run/docker.sock:/var/run/docker.sock -it -p 8080:8080 samdroberts/jenkinsimage
and use your hosts docker to run the docker commands inside the container (so if you haven't already, you'll need the docker engine installed on your host machine. This jenkins pipeline will run in this container. 

I've done as much as possible but In order to get it to work, you'll need to configure the following:

first, From the cli of the container (which will have opened after you punched in the docker run commad from above:
- AWS-cli - Run the following command: aws configure -  then enter your aws IAM details (make sure you've given your IAM full EC2 access and set your region to us-west-2) also add your public and secret keys as variables using the following commands:
export AWS_ACCESS_KEY_ID=REPLACETHISWITHYOURACCESSKEY
export AWS_SECRET_ACCESS_KEY=REPLACETHISWITHYOURSECRETKEY
- docker  - with the following commands: docker login - then enter your dockerhub details

  
to enter and configure jenkins, go to your webbrowser at http://localhost:8080 and enter the username admin and password admin

The next step is to configure your AWS & docker credentials in jenkins. Go into DASHBOARD > MANAGE JENKINS > CREDENTIALS >  and update the current credentials with yours. Leave the name of the credentials (aws & docker respectively) as they are. These names are referenced as variables in the groovy script. Just update the username & password for docker, and the access key and secret access key for aws.

Next, you need to head to the pipeline and edit a few details.
Go into the pipeline called "pipeline-project" and scroll to the groovy script. 
Here you'll need to update the following:
* docker - Update the pipeline script with your username in the YOURDOCKERUSERNAME sections

next, in your host machines cli, create an ssh key pair with the ssh-keygen command. Then, make a note of your public key with the following command cat ~/.ssh/id_rsa.pub. You'll need to paste this in the pipeline in the YOURPUBLICKEY section


other things to configure
AWS - create a new key pair called Pipeline from the aws management console. Save the file into the /var/lib/jenkins/workspace directory of the container so that the pipeline can pull it into your working directory
Go into your AWS management console and change your default security group to allow incomming traffic on port 22 for ssh and outgoing traffic http all. if you're worried about security you could configure a new security group but then you'll have to change the main.tf to assign the ec2 to that group. Up to you.

I'm 99% sure this covers everything but if not, feel free to let me know what issues you have and i'm sure i'll be able to trouble shoot with you as i'll have had the same issues along the way to getting this to work.
