data "aws_ami" "redhat" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-8.*_HVM-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  user_data = <<-EOT
    #!/bin/bash -ex
    sudo yum -y update
    sudo yum install -y httpd
    sudo systemctl start httpd  
  EOT
}

locals {
  ssm_user_data = <<-EOT
    #!/bin/bash -ex
    sudo yum -y update
    sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    sudo systemctl start amazon-ssm-agent
    sudo systemctl enable amazon-ssm-agent
  EOT
}

###### Instance that resides in public network subnet2 #########
######################################################################
resource "aws_instance" "ec2_instance" {
  count                       = 1
  ami                         = data.aws_ami.redhat.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.cf_public_subnet[1].id
  associate_public_ip_address = true
  user_data                   = base64encode(local.ssm_user_data)
  iam_instance_profile        = aws_iam_instance_profile.iam_profile.name
}

####### Configuration for ASG resources ###############
#################################################################
resource "aws_launch_template" "cf_asg_launch_template" {
  image_id               = data.aws_ami.redhat.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  user_data              = base64encode(local.user_data)
}

resource "aws_autoscaling_group" "cf_asg" {
  count = 1
  launch_template {
    id      = aws_launch_template.cf_asg_launch_template.id
    version = "$Latest"
  }
  desired_capacity = 2
  min_size         = 2
  max_size         = 6

  # Deploys ASG to only the private subnets 3 and 4
  vpc_zone_identifier = [aws_subnet.cf_private_subnet[0].id, aws_subnet.cf_private_subnet[1].id]
}
