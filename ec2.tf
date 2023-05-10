#EC2 instance
resource "aws_instance" "web1" {
  ami               = "ami-052f483c20fa1351a"
  instance_type     = "t2.micro"
  vpc_security_group_ids   = [ aws_security_group.ec2-tf-sg1a.id ]
  subnet_id         = aws_subnet.private-subnet1.id
  availability_zone = "ap-southeast-1a"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # root disk
  root_block_device {
    volume_size           = "8"
    volume_type           = "gp2"
    delete_on_termination = true
  }

#EBS volume
  ebs_block_device {
    device_name           = "/dev/sdc"
    volume_size           = "1"
    volume_type           = "gp2"
    delete_on_termination = true
     tags = {
    Name = "EBS1"
  }
    
}
   

  #UserData in AWS EC2 using terraform
  user_data = file("userdata_script1.sh")
}



resource "aws_instance" "web2" {
  ami               = "ami-052f483c20fa1351a"
  instance_type     = "t2.micro"
  vpc_security_group_ids   = [ aws_security_group.ec2-tf-sg1b.id ]
  subnet_id         = aws_subnet.private-subnet2.id
  availability_zone = "ap-southeast-1b"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # root disk
  root_block_device {
    volume_size           = "8"
    volume_type           = "gp2"
    delete_on_termination = true
  }

 #EBS volume
  ebs_block_device {
    device_name           = "/dev/sdc"
    volume_size           = "1"
    volume_type           = "gp2"
    delete_on_termination = true
    tags = {
    Name = "EBS2"
  }
}

  #UserData in AWS EC2 using terraform
  user_data = file("userdata_script1.sh")
}


# Cloudwatch Alarm for EC2
resource "aws_cloudwatch_metric_alarm" "ec2alarm1" {
  alarm_name                = "ec2-CPUUtilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 10
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    InstanID = aws_instance.web1.id
  }
  #alarm_actions = ["arn:aws:automate:ap-southeast-1a:ec2:stop"]
}

resource "aws_cloudwatch_metric_alarm" "ec2alarm2" {
  alarm_name                = "ec2-CPUUtilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 10
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    InstanID = aws_instance.web2.id
  }
  #alarm_actions = ["arn:aws:automate:ap-southeast-1b:ec2:stop"]
}