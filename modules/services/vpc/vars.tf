###### Variables ######

###### Pass Local IP #######
variable "local_ip" {
  type        = string
  description = "Access to Bastion provided from this IP"
  default     = "96.241.156.116/32"
}
