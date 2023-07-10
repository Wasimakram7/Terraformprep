variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "Region to create resources"
}
variable "ntier_vpc_info" {
  type = object({
    vpc_cidr     = string,
    public_subnet_azs   = list(string),
    private_subnet_azs   = list(string),
    public_subnet_names = list(string),
    private_subnet_names = list(string)
  })
  default = {
    public_subnet_azs   = ["a", "b"]
    private_subnet_azs   = ["a", "b", "a", "b"]
    public_subnet_names = ["web1", "web2"]
    private_subnet_names = ["app1", "app2", "db1", "db2"]
    vpc_cidr     = "192.168.0.0/16"
  }
}