variable "AWS_REGION" {
default = "ap-southeast-1"
}

provider "aws" {
  region     = "ap-southeast-1"
}

variable "AMIS" {
    type = map
    default = {
        us-east-1 = "ami-0f40c8f97004632f9"
        us-east-2 = "ami-05edbb8e25e281608"
        us-west-2 = "ami-0352d5a37fb4f603f"
        us-west-1 = "ami-0f40c8f97004632f9"
        ap-south-1 = "ami-0fd48e51ec5606ac1"
        ap-southeast-1 = "ami-00e912d13fbb4f225"

    }
}

variable "PATH_TO_PUBLIC_KEY" {
  description = "Public key path"
  default = "~/.ssh/id_rsa.pub"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "~/.ssh/id_rsa"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}