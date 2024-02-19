variable "vm_image" {

  type = map(string)

  default = {
    "architecture" : "x64",
    "offer" : "nginx-14-05-2021",
    "publisher" : "nilespartnersinc1617691698386",
    "sku" : "nginx",
    "urn" : "nilespartnersinc1617691698386:nginx-14-05-2021:nginx:1.1.1",
    "version" : "latest"

    plan_id : "nginx"
    product_id : "nginx-14-05-2021"
  }
}
