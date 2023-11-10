location = "us-east-1"
vpc_cidr = "10.0.0.0/16"
subnet_cidrs = ["10.0.0.0/24" , "10.0.1.0/24"]
ami = "ami-051f7e7f6c2f40dc1"
instance_type = "t2.micro"
web_ingress_rule = {
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
    }
}

web_bucket = "lambda-s3-backup-xml-files"