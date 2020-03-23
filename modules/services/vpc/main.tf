resource "aws_vpc" "standard_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "Dev-VPC"
    Environment = "Development"
    Cost-Center = "PackVsPride"
  }
}


###### Subnet Setup ######

resource "aws_subnet" "pub_sub" {
  vpc_id = aws_vpc.standard_vpc.id

  availability_zone = "us-east-1b"
  cidr_block        = cidrsubnet(aws_vpc.standard_vpc.cidr_block, 4, 1)

  tags = {
    Name        = "pub-sub-1"
    Environment = "Development"
    Cost-Center = "PackVsPride"
  }
}

resource "aws_subnet" "pri_sub" {
  vpc_id = aws_vpc.standard_vpc.id

  availability_zone = "us-east-1b"
  cidr_block        = cidrsubnet(aws_vpc.standard_vpc.cidr_block, 4, 2)

  tags = {
    Name        = "pri-sub-1"
    Environment = "Development"
    Cost-Center = "PackVsPride"
  }
}


###### Security Group Setup ######

###### SSH to Bastion Host Specific ######
resource "aws_security_group" "allow_ssh_to_bastion" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic to Bastion Host"
  vpc_id      = aws_vpc.standard_vpc.id

  ingress {
    description = "SSH from Specified IP Range"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.local_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "allow_ssh_bastion"
    Environment = "Development"
    Cost-Center = "PackVsPride"
  }
}
