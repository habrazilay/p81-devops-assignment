variable "aws_region" {
  description = "The AWS region to use to create resources."
  default     = "eu-north-1"
}
variable "bucket_prefix" {
    type        = string
    description = "(required since we are not using 'bucket') Creates a unique bucket name beginning with the specified prefix"
    default     = "daniels-s3bucket"
}

variable "tags" {
    type        = map
    description = "(Optional) A mapping of tags to assign to the bucket."
    default     = {
        environment = "DEV"
        terraform   = "true"
        owner = "Daniel Schmidt"
    }   
}

variable "acl" {
    type        = string
    description = " Defaults to private "
    default     = "private"
}