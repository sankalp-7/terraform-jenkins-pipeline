provider "aws" {
  region="us-east-1"
}
resource "aws_instance" "module-ec2" {
    ami=var.ec2ami
    instance_type=var.ec2type
    tags={
        Name= var.ec2name
    }
}