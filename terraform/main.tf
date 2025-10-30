#vpc
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "main-vpc"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    
    tags = {
        Name = "main-igw"
    }
}


#subnet publica
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "${var.aws_region}a"
    map_public_ip_on_launch = true
    
    tags = {
        Name = "public-subnet"
    }
}

#route table

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "public-rt"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id

}

resource "aws_security_group" "web_sg" {
    name = "web-sg"
    description = "Grupos de seguridad para servidores web"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8081
        to_port = 8081
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

     egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#Instancia apache

resource "aws_instance" "apache" {
    ami = var.apache_ami
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    associate_public_ip_address = true

    user_data = file("${path.module}/scripts/apache.sh")

    tags = {
        Name = "apache-examen"
    }
}
