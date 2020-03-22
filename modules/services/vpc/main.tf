resource "aws_vpc" "standard_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "Dev-VPC"
    Environment = "Development"
    Cost-Center = "PackVsPride"
  }
}

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
