# NAT Gateway to allow private subnet to connect out the way
resource "aws_eip" "Natgw1" {
    vpc = true
}
resource "aws_eip" "Natgw2" {
   vpc = true
}

# Create NAT gateway
resource "aws_nat_gateway" "Natgw1" {
  allocation_id = aws_eip.Natgw1.id
  subnet_id     = aws_subnet.public-subnet1.id
  tags = {
    Name = "Natgateway1"
  }
}

resource "aws_nat_gateway" "Natgw2" {
  allocation_id = aws_eip.Natgw2.id
  subnet_id = aws_subnet.public-subnet2.id
  tags = {
    Name = "Natgateway2"
  }
}

 