resource "aws_instance" "main" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.main.*.id[0]
  availability_zone = local.azs_names[0]
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name = "prasu"
  #user_data = file("./script/httpd.sh")
  iam_instance_profile = aws_iam_instance_profile.web_ec2_profile.name
  user_data_replace_on_change = true

  tags = {
    Name = "jhc-demo-${local.ws}"
  }
  provisioner "file" {
    source = "./code/index.html"
    destination = "/tmp/"
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("~/Downloads/prasu.pem")
    host = self.public_ip
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.web_ingress_rule
    content {
     description = "some description of ssh"
     from_port = ingress.value.port
     to_port = ingress.value.port
     protocol = ingress.value.protocol
     cidr_blocks = ingress.value.cidr_blocks 
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg"
  }
}

resource "aws_iam_role" "web_ec2_role" {
  name = "web_ec2_role-${local.ws}"
  managed_policy_arns = [aws_iam_policy.ec2_web_policy.arn]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "ec2_web_role"
  }
}

resource "aws_iam_policy" "ec2_web_policy" {
  name = "ec2_web_policy-618033-${local.ws}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:PutObject", "s3:GetObject"]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::lambda-s3-backup-xml-files/*"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "web_ec2_profile" {
  name = "web_ec2_profile"
  role = aws_iam_role.web_ec2_role.name
}
