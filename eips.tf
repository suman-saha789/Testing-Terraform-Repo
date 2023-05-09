resource "aws_eip" "eipnat1" {
  depends_on = [aws_internet_gateway.tf-igw]
  tags       = {
  Name = "eipnat1"  
    }
}

resource "aws_eip" "eipnat2" {
  depends_on = [aws_internet_gateway.tf-igw]
  tags       = {
  Name = "eipnat2"  
    }
}