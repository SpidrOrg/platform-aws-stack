region     = "ap-south-1"
vpc_id     = "vpc-051911f4f1d6611fa"

endpoints = [
  {
    service_name        = "com.amazonaws.ap-south-1.s3"
    type   = "Gateway"
    private_dns_enabled = true
    tags = {
      Name = "s3"
    }
  },

]

route_table_id = "rtb-014152415261b69f1"