# Output the local administrator password - also available through console
output "localadmin" {
  value = [rsadecrypt(aws_instance.virtualmachine_1.password_data, file("id_rsa"))
  ]
}