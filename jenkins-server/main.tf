#VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "terraform-vpc"
  cidr = "10.0.0.0/16"

  azs = data.aws_availability_zones.azs.names

  public_subnets = var.public-subnet
     
  map_public_ip_on_launch = true
  enable_dns_hostnames = true

  tags = {
    Name        = "terraform-vpc1"
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "terraform-subnet"
  }
}

#SG
module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "terraform-sg"
  description = "Security group for terraform-vpc"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    Name = "terraform-sg"
  }
}

#EC2
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "terraform-ec2"

  instance_type               = var.instance-type
  key_name                    = "kube-key"
  monitoring                  = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("jenkins-install.sh")
  availability_zone           = data.aws_availability_zones.azs.names[0]
  tags = {
    Name        = "terraform-ec2"
    Terraform   = "true"
    Environment = "dev"
  }
}