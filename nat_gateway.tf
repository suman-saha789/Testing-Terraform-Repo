# NAT Gateway to allow private subnet to connect out the way
resource "aws_eip" "Natgw1" {
  depends_on = [
    aws_route_table_association.publicRTassociation1
  ]
    vpc = true
}

resource "aws_eip" "Natgw2" {
  depends_on = [
    aws_route_table_association.publicRTassociation2
  ]
    vpc = true
}

# Create NAT gateway
resource "aws_nat_gateway" "Natgw1" {
  depends_on = [
    aws_eip.Natgw1
  ]

  allocation_id = aws_eip.eipnat1.id
  subnet_id     = aws_subnet.public-subnet1.id
}

resource "aws_nat_gateway" "Natgw2" {
depends_on = [
    aws_eip.Natgw2
  ]

  allocation_id = aws_eip.eipnat2.id
  subnet_id = aws_subnet.public-subnet2.id
}

 