region = "ap-south-1"
ntier_vpc_info = {
  public_subnet_azs   = ["a", "b"]
  private_subnet_azs   = ["a", "b", "a", "b"]
  public_subnet_names = ["web1", "web2"]
  private_subnet_names = ["app1", "app2", "db1", "db2"]
  vpc_cidr     = "192.168.0.0/16"
}