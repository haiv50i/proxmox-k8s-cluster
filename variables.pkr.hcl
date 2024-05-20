variable "api_url" {
  type = string
  default = "https://192.168.10.5:8006/api2/json/"
}

variable "api_token_id" {
    type = string
}

variable "api_token_secret" {
    type = string
    sensitive = true
}

variable "private_key" {
  type = string
  sensitive = true
}
