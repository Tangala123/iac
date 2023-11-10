variable "location" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  default = ["10.0.0.0/24" , "10.0.1.0/24"]
}

variable "ami" {
  default = "ami-051f7e7f6c2f40dc1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "web_ingress_rule" {
  type = map(object({
    port = number
    protocol = string
    cidr_blocks = list(string)
    description = string
  }))
  /*
  default = {
    "22" = {
      port = 22
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "ssh"
    },
    "80" = {
      port = 80
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "http"
    },
    "icmp" = {
      port = "-1"
      protocol = "icmp"
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "ping"
    }
  }
  */
}

variable "web_bucket" {
  #default = "lambda-s3-backup-xml-files"
}