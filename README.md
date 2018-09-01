# bluejeans-task
Dockerized API server deployed behind ALB in AWS

Please make the following changes before doing a terraform plan.

1. Add credentials and preferred region in the provider.tf file (or) export as environment variable
2. Use the provided ssh key or create new. Please ensure the path of the key file vars.tf.

Description:
  This project was intended to create an api server which accepts GET/POST requests. Api server is written using python and flask. Application has been dockerized and hosted in public dockerhub. 
  
  The following AWS resources will be created when using the templates.
  1. VPC
  2. Public and private subnets
  3. Public and private route tables
  4. NACL
  5. Security groups for webserver, bastion server and ALB.
  6. Internet gateway and Nat gateway
  7. Ssh keys
  8. Bastion and Webserver
  9. ALB and target group
  10. EIPs for NAT gw and bastion server
  
Webserver will be bootstrapped using the install.sh script which deploys the docker image.


API usage:

Get current values : curl http://ALB-DNS/api/v1.0/tasks

Post new values : curl -i -H "Content-Type: application/json" -X POST -d "{\"title\":\"redjeans\", \"description\":\"Im wearing redjeans\"}" "http://ALB-DNS/api/v1.0/tasks"

Note: Replace ALB-DNS with the DNS name of the newly created ALB.
Example:

curl -i http://front-alb-1170548121.us-west-1.elb.amazonaws.com/api/v1.0/tasks

{
  "tasks": [
    {
      "description": "Im wearing bluejeans", 
      "title": "bluejeans"
    }
  ]
}

curl -i -H "Content-Type: application/json" -X POST -d "{\"title\":\"redjeans\", \"description\":\"Im wearing redjeans\"}" "http://front-alb-1170548121.us-west-1.elb.amazonaws.com/api/v1.0/tasks"
{
  "task": {
    "description": "Im wearing redjeans", 
    "title": "redjeans"
  }
}
 
 curl -i http://front-alb-1170548121.us-west-1.elb.amazonaws.com/api/v1.0/tasks
{
  "tasks": [
    {
      "description": "Im wearing bluejeans", 
      "title": "bluejeans"
    }, 
    {
      "description": "Im wearing redjeans", 
      "title": "redjeans"
    }
  ]
}
