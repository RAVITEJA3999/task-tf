provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_east_2"
  region = "us-east-2"
}


# Create VPC in us-east-1
resource "aws_vpc" "task_vpc_us_east_1" {
  provider    = aws.us_east_1
  cidr_block  = "10.0.0.0/16"
  tags = {
    Name = "task-vpc"
  }
}

# Create VPC in us-east-2
resource "aws_vpc" "task_vpc_us_east_2" {
  provider    = aws.us_east_2
  cidr_block  = "10.1.0.0/16"
  tags = {
    Name = "task-vpc"
  }
}

# Create Subnet in us-east-1
resource "aws_subnet" "task_subnet_us_east_1" {
  provider          = aws.us_east_1
  vpc_id            = aws_vpc.task_vpc_us_east_1.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "task-sb"
  }
}

# Create Subnet in us-east-2
resource "aws_subnet" "task_subnet_us_east_2" {
  provider          = aws.us_east_2
  vpc_id            = aws_vpc.task_vpc_us_east_2.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "task-sb"
  }
}

# Create Internet Gateway in us-east-1
resource "aws_internet_gateway" "task_igw_us_east_1" {
  provider = aws.us_east_1
  vpc_id   = aws_vpc.task_vpc_us_east_1.id
  tags = {
    Name = "task-igw"
  }
}

# Create Internet Gateway in us-east-2
resource "aws_internet_gateway" "task_igw_us_east_2" {
  provider = aws.us_east_2
  vpc_id   = aws_vpc.task_vpc_us_east_2.id
  tags = {
    Name = "task-igw"
  }
}

# Create Network ACL in us-east-1
resource "aws_network_acl" "task_nacl_us_east_1" {
  provider = aws.us_east_1
  vpc_id   = aws_vpc.task_vpc_us_east_1.id
  tags = {
    Name = "task-nacl"
  }
}

# Create Network ACL in us-east-2
resource "aws_network_acl" "task_nacl_us_east_2" {
  provider = aws.us_east_2
  vpc_id   = aws_vpc.task_vpc_us_east_2.id
  tags = {
    Name = "task-nacl"
  }
}

# Create Security Group in us-east-1
resource "aws_security_group" "task_sg_us_east_1" {
  provider = aws.us_east_1
  vpc_id   = aws_vpc.task_vpc_us_east_1.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "task-sg"
  }
}

# Create Security Group in us-east-2
resource "aws_security_group" "task_sg_us_east_2" {
  provider = aws.us_east_2
  vpc_id   = aws_vpc.task_vpc_us_east_2.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "task-sg"
  }
}


# Create EC2 instance in us-east-1
resource "aws_instance" "task_instance_us_east_1" {
  provider                = aws.us_east_1
  ami                     = "ami-0d5eff06f840b45e9"  # Ubuntu Server 20.04 LTS AMI ID for us-east-1
  instance_type           = "t2.micro"
  subnet_id               = aws_subnet.task_subnet_us_east_1.id
  vpc_security_group_ids  = [aws_security_group.task_sg_us_east_1.id]

  tags = {
    Name = "task1-instance"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }
}

# Create EC2 instance in us-east-2
resource "aws_instance" "task_instance_us_east_2" {
  provider                = aws.us_east_2
  ami                     = "ami-0f30a9c3a48f3fa79"  # Ubuntu Server 20.04 LTS AMI ID for us-east-2
  instance_type           = "t2.micro"
  subnet_id               = aws_subnet.task_subnet_us_east_2.id
  vpc_security_group_ids  = [aws_security_group.task_sg_us_east_2.id]

  tags = {
    Name = "task2-instance"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }
}

