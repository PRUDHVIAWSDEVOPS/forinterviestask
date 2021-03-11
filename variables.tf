variable "AWS_REGION" {    
    default = "eu-east-1"
}
variable "AMI" {
    type = "map"
    
    default {
        eu-west-1 = "ami-017329b75bfa6772b"
        us-east-1 = "ami-09943f9da1f1b7899"
    }
}