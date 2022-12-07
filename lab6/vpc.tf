provider aws {
    region = "us-east-1"
}


resource "aws_vpc" "main" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
        "Name" = "VPC"
    }
}

resource "aws_subnet" "subnet1" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.0.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "Subnet1"
    }
}

resource "aws_subnet" "subnet2" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = true

    tags = {
        Name = "Subnet2"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "InternetGateway"
    }
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    tags = {
        Name = "RouteTable"
    }
}

resource "aws_route_table_association" "sub1" {
    subnet_id      = aws_subnet.subnet1.id
    route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "sub2" {
    subnet_id      = aws_subnet.subnet2.id
    route_table_id = aws_route_table.rt.id
}

resource "aws_network_acl" "acl" {
    vpc_id = aws_vpc.main.id

    ingress {
        protocol   = -1
        rule_no    = 100
        action     = "deny"
        cidr_block = "50.31.252.0/24"
        from_port  = 0
        to_port    = 0
    }
}

resource "aws_security_group" "sg" {
    name   = "RDS_SG"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "RDSSG"
    }
}

resource "aws_db_subnet_group" "db_sg" {
    name       = "subnet_group1"
    subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

    tags = {
        Name = "DBSubnetGroup"
    }
}

resource "aws_db_instance" "rds_db" {
    allocated_storage      = 20
    storage_type           = "gp2"
    engine                 = "mysql"
    engine_version         = "5.7"
    instance_class         = "db.t2.micro"
    name                   = "dbtest"
    username               = "testuser"
    password               = "Lgfd!53Kjst34"
    parameter_group_name   = "default.mysql5.7"
    vpc_security_group_ids = [aws_security_group.sg.id]
    db_subnet_group_name   = aws_db_subnet_group.db_sg.id
    publicly_accessible    = true
    skip_final_snapshot    = true
}