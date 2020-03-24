resource "aws_vpc" "standard_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "Dev-VPC"
    Environment = "Development"
    Cost-Center = "PackVsPride"
  }
}

###### Internet Gateway ######

resource "aws_internet_gateway" "dev_vpc_igw" {
  vpc_id = aws_vpc.standard_vpc.id

  tags = {
    Name        = "Dev-VPC-IGW"
    Environment = "Development"
    Cost-Center = "PackVsPride"
  }
}

###### Route Tables and Route Table Associations ########

resource "aws_route_table" "internet_route" {
  vpc_id = aws_vpc.standard_vpc.id

  ##### Route to the internet via the attached gateway ######
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_vpc_igw.id
  }

  tags = {
    Name        = "Dev-VPC-Default-Route"
    Environment = "Development"
    Cost-Center = "PackVsPride"
  }
}

###### Subnet Setup ######

###### Availability Zone 1 ######

###### Public Subnets ######

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
resource "aws_subnet" "pub_sub_2" {
  vpc_id = aws_vpc.standard_vpc.id

  availability_zone = "us-east-1b"
  cidr_block        = cidrsubnet(aws_vpc.standard_vpc.cidr_block, 4, 3)

  tags = {
    Name        = "pub-sub-2"
    Environment = "Development"
    Cost-Center = "PackVsPride"
  }
}

###### Private Subnets #######

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

resource "aws_subnet" "pri_sub_2" {
  vpc_id = aws_vpc.standard_vpc.id

  availability_zone = "us-east-1b"
  cidr_block        = cidrsubnet(aws_vpc.standard_vpc.cidr_block, 4, 4)

  tags = {
    Name        = "pri-sub-2"
    Environment = "Development"
    Cost-Center = "PackVsPride"
  }
}

######## End of AZ1 #######

######## Availability Zone 2 #########

###### Public Subnets ######

resource "aws_subnet" "az2_pub_sub" {
  vpc_id = aws_vpc.standard_vpc.id

  availability_zone = "us-east-1c"
  cidr_block        = cidrsubnet(aws_vpc.standard_vpc.cidr_block, 4, 5)

  tags = {
    Name        = "az2_pub-sub-1"
    Environment = "Development"
    Cost-Center = "PackVsPride"
  }
}
resource "aws_subnet" "az2_pub_sub_2" {
  vpc_id = aws_vpc.standard_vpc.id

  availability_zone = "us-east-1c"
  cidr_block        = cidrsubnet(aws_vpc.standard_vpc.cidr_block, 4, 7)

  tags = {
    Name        = "az2-pub-sub-2"
    Environment = "Development"
    Cost-Center = "PackVsPride"
  }
}

###### Private Subnets #######

resource "aws_subnet" "az2_pri_sub" {
  vpc_id = aws_vpc.standard_vpc.id

  availability_zone = "us-east-1c"
  cidr_block        = cidrsubnet(aws_vpc.standard_vpc.cidr_block, 4, 6)

  tags = {
    Name        = "az2_pri-sub-1"
    Environment = "Development"
    Cost-Center = "PackVsPride"
  }
}

resource "aws_subnet" "az2_pri_sub_2" {
  vpc_id = aws_vpc.standard_vpc.id

  availability_zone = "us-east-1c"
  cidr_block        = cidrsubnet(aws_vpc.standard_vpc.cidr_block, 4, 8)

  tags = {
    Name        = "az2_pri-sub-2"
    Environment = "Development"
    Cost-Center = "PackVsPride"
  }
}

###### End of AZ2 #######




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


###### Allow HTTP Connections to WWW Server ########

###### Insecure and needs to be HTTPS ######
resource "aws_security_group" "allow_http_www" {
  name        = "allow_http_www"
  description = "Allow WWW-HTTP inbound traffic"
  vpc_id      = aws_vpc.standard_vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.standard_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_www"
  }
}
