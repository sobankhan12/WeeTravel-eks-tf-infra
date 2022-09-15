#------------------------------------------------#-----------------------------------------------------------------


########################    VPC        ###############################

#--------------------------------------------------#----------------------------------------------------------------

#Creating VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames=true
  enable_dns_support = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}
resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "eip-nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-1a.id

  tags = {
    Name = " NatGateway_EKS_Demo"
  }

  depends_on = [aws_internet_gateway.igw]
}



resource "aws_subnet" "private-1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.region}a"

  tags = {
    "Name"                            = "private-${var.region}a"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/tf-eks-wetravel"      = "owned"
  }
}

resource "aws_subnet" "private-1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.region}b"
  tags = {
    "Name"                            = "private-${var.region}b"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/tf-eks-wetravel"      = "owned"
  }
}

resource "aws_subnet" "private-1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "${var.region}c"
  tags = {
    "Name"                            = "private-${var.region}c"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/tf-eks-wetravel"      = "owned"
  }
}

resource "aws_subnet" "public-1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                       = "public-${var.region}a"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/tf-eks-wetravel" = "shared"
  }
}

resource "aws_subnet" "public-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                       = "public-${var.region}b"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/tf-eks-wetravel" = "shared"
  }
}

resource "aws_subnet" "public-1c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.region}c"
  map_public_ip_on_launch = true

  tags = {
    "Name"                       = "public-${var.region}c"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/tf-eks-wetravel" = "shared"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat.id
  }

  

  tags = {
    Name = "private"
  }
}


resource "aws_route_table" "public" {
  

  vpc_id = aws_vpc.main.id
    route {

        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "private-1a" {
  subnet_id      = aws_subnet.private-1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-1b" {
  subnet_id      = aws_subnet.private-1b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-1c" {
  subnet_id      = aws_subnet.private-1c.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public-1a" {
  subnet_id      = aws_subnet.public-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-1b" {
  subnet_id      = aws_subnet.public-1b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-1c" {
  subnet_id      = aws_subnet.public-1c.id
  route_table_id = aws_route_table.public.id
}


