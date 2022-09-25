# String variable
variable "AWS_REGION" {
  type        = string
  default     = "ap-southeast-1"
  description = "The AWS Region to deploy resources"
}

variable "AWS_ACCESS_KEY" {
  type        = string
  description = "The AWS ACCESS KEY to deploy resources"
}

variable "AWS_SECRET_KEY" {
  type        = string
  description = "The AWS SECRET Key to deploy resources"
}


# String variable with validation
variable "environment" {
  type        = string
  default     = "dev"
  description = "The environment to deploy resources"
  validation {
    condition     = contains(["production", "staging", "dev"], lower(var.environment))
    error_message = "Unsupported environments specified. Supported environment include: production, staging, dev"
  }
}




# Map region with AMI variable
variable "AMIS" {
  type = map(any)
  default = {
    ap-southeast-1 = "ami-04ff9e9b51c1f62ca"
    ap-northeast-1 = "ami-0f8048fa3e3b9e8ff"
  }
}

# List Security group
variable "Security_Groups" {
  type    = list(any)
  default = ["sg-24076", "sg-90890", "sg-456789"]
}


variable "PATH_TO_PRIVATE_KEY" {
  default = "my-key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "my-key.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}
