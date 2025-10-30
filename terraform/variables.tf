#region aws
variable "aws_region" {
    description = "Region donde se crean los recursos"
    type = string
    default = "us-east-1"
}

#ami para la instancia debian
variable "apache_ami" {
    description = "Ami para debian"
    type = string
    default = "ami-0b0012dad04fbe3d7"

}

variable "instance_type" {
    description = "tipo de instancia ec2"
    type = string
    default = "t2.micro"
}

variable "key_name" {
    description = "nombre keypair para ssh"
    type = string
    default = "examen"
}