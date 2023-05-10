  #1 Create VPC
resource "aws_vpc" "tf-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = "true"

  tags       = {
    Name     = "terraform-created-vpc"
  }
}
  
#2 Create public subnet 1 and 2
resource "aws_subnet" "public-subnet1" {
  vpc_id            = aws_vpc.tf-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "public-subnet1"
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id     = aws_vpc.tf-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-1b"
  

  tags       = {
    Name     = "public-subnet2"
  }
}


  
#3 Create Internet gateway
resource "aws_internet_gateway" "tf-igw" {
  depends_on = [
    aws_vpc.tf-vpc,
    aws_subnet.public-subnet1,
    aws_subnet.public-subnet2
  ]
  vpc_id = aws_vpc.tf-vpc.id

  tags       = {
    Name     = "tf-igw"
  }
}


#4 Create Public Route Table
resource "aws_route_table" "publicRT" {
  vpc_id     = aws_vpc.tf-vpc.id
  
  route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.tf-igw.id
  }
  tags            = {
  Name            = "public-routetable"
  }
 }
  
#5 Subnet Association
resource "aws_route_table_association" "publicRTassociation1" {
  subnet_id          = aws_subnet.public-subnet1.id
  route_table_id     = aws_route_table.publicRT.id
  }

resource "aws_route_table_association" "publicRTassociation2" {
    subnet_id         = aws_subnet.public-subnet2.id
    route_table_id    = aws_route_table.publicRT.id
  }

# Create Private subnet 1 and 2
resource "aws_subnet" "private-subnet1" {
  vpc_id     = aws_vpc.tf-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-southeast-1a"
  
  tags       = {
  Name       = "private-subnet1"
    }
  }
  
resource "aws_subnet" "private-subnet2" {
  vpc_id     = aws_vpc.tf-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-southeast-1b"

  tags       = {
  Name       = "private-subnet2"
  }
}  
  

  # Create Private route Table

 resource "aws_route_table" "privaateRT1" {
   vpc_id = aws_vpc.tf-vpc.id
   route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.Natgw1.id
    }
  tags            = {
  Name            = "Private-route-table1"
  }
 }
	
	resource "aws_route_table" "privaateRT2" {
    vpc_id = aws_vpc.tf-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.Natgw2.id
	}
  tags            = {
  Name            = "Private-route-table2"
    }
  }
	
# Private Route table association
resource "aws_route_table_association" "privateRT-subnet-1"{
  subnet_id = aws_subnet.private-subnet1.id
  route_table_id = aws_route_table.privaateRT1.id
}


resource "aws_route_table_association" "privateRT-subnet-2"{
    subnet_id = aws_subnet.private-subnet2.id
    route_table_id = aws_route_table.privaateRT2.id
}


#6 Security Group
resource "aws_security_group" "ec2-tf-sg1a" {
  name        = "ec2-tf-sg1a"
  vpc_id      = aws_vpc.tf-vpc.id


  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
}


#7 Security group2
resource "aws_security_group" "ec2-tf-sg1b" {
  name        = "ec2-tf-sg1b"
  vpc_id      = aws_vpc.tf-vpc.id


  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
}
