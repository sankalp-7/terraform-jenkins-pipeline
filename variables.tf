variable "vpc-cidr" {
  description = "vpc cidr"
  type        = string
}
variable "public-subnet" {
  description = "public subnets"
  type        = list(string)
}
variable "instance-type" {
  description = "instance type"
  type        = string

}