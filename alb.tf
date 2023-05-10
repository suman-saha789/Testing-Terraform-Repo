# Security group for aws_lb
#6 Security Group
resource "aws_security_group" "alb-sg" {
  name        = "ec2-sg"
  vpc_id      = aws_vpc.tf-vpc.id


  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  
}
}


#Target group
resource "aws_lb_target_group" "front" {
  name     = "application-front"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.tf-vpc.id
  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    timeout             = 5
    matcher             = 200
    healthy_threshold   = 2
    unhealthy_threshold = 2
}
}



# Target group attachment
resource "aws_lb_target_group_attachment" "attach-app1" {
  target_group_arn = aws_lb_target_group.front.arn
  target_id        = aws_instance.web1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach-app2" {
  target_group_arn = aws_lb_target_group.front.arn
  target_id        = aws_instance.web2.id
  port             = 80
}

# Create Load balancer
resource "aws_lb" "front" {
  name               = "front"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [ aws_subnet.public-subnet1.id, aws_subnet.public-subnet2.id ]

  enable_deletion_protection = false
}