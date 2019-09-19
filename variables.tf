variable "EC2Size" {
  type = "string"
  description = "Standard EC2 sizing of instances."
  default = "t2.micro"
}

variable "deploymentID" {
  type = "string"
  description = "A string to identify the deployment. Used to prefix most resource names."
}

variable "vpc_id" {
  type = "string"
  description = "The ID of the VPC you are creating the security group in."
  default = "vpc-1432726e"
}

variable "ec2_root_block_device" {
  type = "map"
  description = "Definition of the root disk."
  default = {
    volume_type = "gp2"
    volume_size = "20"
    delete_on_termination = "true"
  }
}

variable "subnet_ids" {
  type = "list"
  description = "A list of subnets to deploy into. Instances will be spread over them reasonably evenly."
  default = [ "subnet-724c7815" ]
}