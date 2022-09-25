terraform {
    backend "s3" {
        bucket = "terraform-anhgrew"
        key    = "development/terraform_state"
        region = "ap-southeast-1"
    }
}