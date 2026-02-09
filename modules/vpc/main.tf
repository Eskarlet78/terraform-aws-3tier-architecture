resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

# -----------------------
# PUBLIC SUBNETS
# -----------------------
resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.project_name}-public-${count.index}"
  }
}

# -----------------------
# PRIVATE APP SUBNETS
# -----------------------
resource "aws_subnet" "private_app" {
  count             = 2
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.${count.index + 11}.0/24"
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.project_name}-app-${count.index}"
  }
}

# -----------------------
# PRIVATE DB SUBNETS
# -----------------------
resource "aws_subnet" "private_db" {
  count             = 2
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.${count.index + 21}.0/24"
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.project_name}-db-${count.index}"
  }
}

# -----------------------
# NAT GATEWAY
# -----------------------
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.project_name}-nat"
  }
}

# -----------------------
# PUBLIC ROUTE TABLE
# -----------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# -----------------------
# PRIVATE APP ROUTE TABLE (USES NAT)
# -----------------------
resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.project_name}-app-rt"
  }
}

resource "aws_route_table_association" "app_assoc" {
  count          = 2
  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private_app.id
}

# -----------------------
# PRIVATE DB ROUTE TABLE (NO INTERNET)
# -----------------------
resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-db-rt"
  }
}

resource "aws_route_table_association" "db_assoc" {
  count          = 2
  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private_db.id
}
