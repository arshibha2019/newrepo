terraform{
    required_providers {
      aws = {
        source = "harshicorp/aws"
        version = "~> 4.0"
      }
    }
    
}

provider "aws"{
    region = "us-east-1"
    access_key = "AKIAW2EEW3ZVHJ2YVMD"
    secret_key = "9Ne6d7ermvg6ueymY3KoNfZynfrB9Pn3ls9sxY8"

    git 
}

resource "aws_s3_bucket" "mybucket"{
    bucket = "arushisnewbucket"
    tags = {
        Name = "s3bucket"
    }
}

resource "aws_s3_bucket_object" "newfile"{
    bucket = aws_s3_bucket.mybucket.id
    key = "hello.txt"
    source = "hello.txt"
    
}