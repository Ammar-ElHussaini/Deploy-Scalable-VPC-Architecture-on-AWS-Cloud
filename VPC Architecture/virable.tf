# Variables for reusability
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "172.32.0.0/16"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  default     = ["172.32.3.0/24", "172.32.4.0/24"]
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  default     = ["172.32.1.0/24", "172.32.2.0/24"]
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  default     = ["us-east-1a", "us-east-1b"]
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  default     = "ami-020cba7c55df1f615"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  default     = "t2.micro"
  type        = string
}