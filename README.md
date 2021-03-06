### Bluejeans-task
Dockerized API server deployed behind ALB in AWS


### Description

  This project was intended to create an api server which accepts GET/POST requests. Api server is written using python and flask. Application has been dockerized and hosted in public dockerhub. 
  
  The following AWS resources will be created when using the templates.
  1. VPC
  2. Public and private subnets
  3. Public and private route tables
  4. NACL
  5. Security groups for webserver, bastion server and ALB
  6. Internet gateway and Nat gateway
  7. Ssh keys
  8. Bastion and Webserver
  9. ALB and target group
  10. EIPs for NAT gw and bastion server
  
Webserver will be bootstrapped using the install.sh script which installs the dependencies and deploys the docker image.

#### Prerequisites  
Please make the following changes before doing a terraform plan.

1. Add api credentials and preferred region in the provider.tf file (or) export as environment variable.
2. Please ensure the path of the your ssh public key file in vars.tf.


#### API server Deployment

1. Clone the repository 
  $ git clone  git@github.com:bala2289/bluejeans-task.git
2. Install terraform based on your distribution. [Terraform](https://www.terraform.io/intro/getting-started/install.html)
3. Initialize terraform.
    **$ cd bluejeans-task; terraform init.**
4. Create a terraform deploy plan.
    **$ terraform plan -out tf.out**
5. Apply the plan.
    **$ terraform apply "tf.out"**
6. Destroy the setup.
    **$ terraform destroy**

**Note:1 ensure api keys have been added to provider.tf before plan/apply.**


### API usage

  Once the AWS infrastructure has been provisioned use the below endpoints to access tht API server.

**Endpoint: http://ALB-DNS/api/v1.0/tasks**

Get:  Display current tasks

**example:** curl http://ALB-DNS/api/v1.0/tasks

Post:  Post accepts two key pairs. Title and Description.

**example:** curl -H "Content-Type: application/json" -X POST -d "{\"title\":\"redjeans\", \"description\":\"Im wearing redjeans\"}" "http://ALB-DNS/api/v1.0/tasks"

**Note:2 Replace ALB-DNS with the DNS name of the newly created ALB.**

