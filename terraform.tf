variable "AWS_REGION" {    
    default = "eu-east-1"
}


provider "aws" {
    region = "${var.AWS_REGION}"
}


resource “aws_vpc” “PRUDHVI-VPC” {
    cidr_block = “10.0.0.0/16”
    enable_dns_support = “true” 
    enable_dns_hostnames = “true” 
    enable_classiclink = “false”
    instance_tenancy = “default”    
    
    tags {
        Name = “prudhvi-vpc”
    }
}

resource “aws_subnet” “PRUDHVI-subnet-public-1” {
    vpc_id = “${aws_vpc.PRUDHVI-VPC.id}”
    cidr_block = “10.0.1.0/24”
    map_public_ip_on_launch = “true”
    availability_zone = “eu-east-1”
    tags {
        Name = “PRUDHVI-subnet-public-1”
    }
}
resource “aws_subnet” “PRUDHVI-subnet-public-2” {
    vpc_id = “${aws_vpc.PRUDHVI-VPC.id}”
    cidr_block = “10.0.2.0/24”
    map_public_ip_on_launch = “true”
    availability_zone = “eu-east-1”
    tags {
        Name = “PRUDHVI-subnet-public-2”
    }
}

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

resource "aws_instance" "web1" {
    ami = "${lookup(var.AMI, var.AWS_REGION)}"
    instance_type = "t2.micro"
    # VPC
    subnet_id = "${aws_subnet.PRUDHVI-subnet-public-1}"
    # Security Group
    vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
    # the Public SSH key
    key_name = "${aws_key_pair.us-east-region-key-pair.id}"
    # nginx installation
    provisioner "file" {
        source = "nginx.sh"
        destination = "/tmp/nginx.sh"
    }
    provisioner "remote-exec" {
        inline = [
             "chmod +x /tmp/nginx.sh",
             "sudo /tmp/nginx.sh"
        ]
    }
    connection {
        user = "${var.EC2_USER01}"
        private_key = "${file("${var.PRIVATE_KEY_PATH}")}"
    }
}

resource "aws_key_pair" "us-east-region-key-pair" {
    key_name = "us-east-region-key-pair"
    public_key = "${file(var.PUBLIC_KEY_PATH)}"
}



