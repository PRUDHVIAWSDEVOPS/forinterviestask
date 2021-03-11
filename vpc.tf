

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
