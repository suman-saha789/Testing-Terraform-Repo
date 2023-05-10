#IAM Role
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
        "Service" : [
          "ec2.amazonaws.com"
        ]
        }        
      }
    ]
  })
}

# Create Role policy to attach ec2
resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy" 
  role = aws_iam_role.ec2_role.id
  policy = file("iampolicyfile1.json")
}

#IAM Policy attachment
/*resource "aws_iam_role_policy_attachment" "ec2-policy-attachment" {
  role      = aws_iam_role.ec2_role.name 
  policy_arn = aws_iam_policy.ec2_policy.arn
  
}*/

#instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.id
}


