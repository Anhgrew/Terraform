## Provider's Example

# Configure the AWS Provider
provider "aws" {
    version = "3.53.0"
    access_key = "AKIARSQNDZ2RWHWTAUFV"
    secret_key = "KVNy8R2XsrEOCOfrcz+iYhrhJy6YrbnW4sdktjrF"
    region     = "ap-southeast-1"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
    version = "2.72.0"
    features {}
}