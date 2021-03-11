

resource "aws_internet_gateway" "PRUDHVI-VPC-igw" {
    vpc_id = “${aws_vpc.PRUDHVI-VPC.id}”
    tags {
        Name = "prudhvi-igw"
    }
}
resource "aws_route_table" "PRUDHVI-public-crt" {
    vpc_id = "${aws_vpc.PRUDHVI-VPC.id}"
    
    route {
       
        cidr_block = "0.0.0.0/0" 
        
        gateway_id = "${aws_internet_gateway.PRUDHVI-VPC-igw}" 
    }
    
    tags {
        Name = "prudhvi-public-crt"
    }
resource "aws_route_table_association" "prudhvi-crta-public-subnet-1"{
    subnet_id = "${aws_subnet.prudhvi-subnet-public-1.id}"
    route_table_id = "${aws_route_table.prudhvi-public-crt.id}"
}

resource "aws_security_group" "ssh-allowed" {
    vpc_id = "${aws_vpc.PRUDHVI-VPC.id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
 {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "ssh-allowed"
    }
}
