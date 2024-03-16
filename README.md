in order for this to work out of the box (ish) you'll need to install several items on your jenkins server, install plugins on juenkins, set up credentials named as they are specified here and edit some file paths etc. You'll also need to create a key pair on amazon. I'll explain all here:

install on the jenkins server
* docker - configured to your docker login details. You'll need to update the pipeline script with your username in the YOURDOCKERUSERNAME sections
* terraform
* ansible
* git - log in and update the pipeline with your git username, then after cloning the repo and making relevant changes to the files, push up to git hub and call your repo "snakejs" the update pipeline script with your git username everywhere it says YOURGITHUBUSERNAME
* AWS CLI - configure to allow access to all EC2 settings on your IAM and set region to us-west-2
create an ssh key pair for the jenkins server if you havent already and make a note of your public key cat ~/.ssh/id_rsa.pub. You'll need to paste this in the pipeline in the YOURPUBLICKEY section

Plugins for jenkins
Docker (just grab loads. deffo need the docker plugin and the cloudbees docker one but just throw loads in) - add your docker credentials too and call them "docker" so the pipeline can pull them in
ansible
terraform
AWS credentials - configure and save it as aws so that the pipeline can pull it in

other things to configure
AWS - create a new key pair called Pipeline. Save the file into your /var/lib/jenkins/workspace directory so that the pipeline can pull it into your working directory
change your default security group to allow incomming traffic on port 22 for ssh and outgoing traffic http all. if you're worried about security you could configure a new security group but then you'll have to change the main.tf to assign the ec2 to that group. Up to you.

finally, call your pipeline project "pipeline-project" just so that the script works. If you call it something different you'll have to change the filepaths in the script. when creating the pipeline chose new item > Pipeline(naming it pipeline-project) > then leave ever setting as default appart from opbviously adding the jenkinsfile code to the script part. Make sure to edit it as advised above or it wont work. 

I'm 99% sure this covers everything but if not, feel free to let me know what issues you have and i'm sure i'll be able to trouble shoot with you as i'll have had the same issues along the way to getting this to work.
