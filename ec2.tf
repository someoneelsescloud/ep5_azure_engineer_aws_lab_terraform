# Get the latest Windows 2019 image made by Amazon
data "aws_ami" "windows_2019" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create a key pair to manage the servers
resource "aws_key_pair" "demo_key" {
  key_name   = "demo_key"
  public_key = local.public_key
}

# Create network inferface for EC2 instance and assign secruity groups
resource "aws_network_interface" "vm_nic_1" {
  subnet_id   = aws_subnet.subnet_1.id
  private_ips = ["10.0.0.100"]

  tags = {
    Name = "${local.name}-nic-1"
  }

  security_groups = [
    aws_security_group.allow_rdp.id,
    aws_security_group.allow_winrm.id,
  ]
}

# Add elastic IP addresss for public connectivity
resource "aws_eip" "vm_eip_1" {
  vpc = true

  instance                  = aws_instance.virtualmachine_1.id
  associate_with_private_ip = "10.0.0.100"
  depends_on                = [aws_internet_gateway.gw_1]

  tags = {
    Name = "${local.name}-eip-1"
  }

}

# Deploy new virtual machine using Windows 2019 latest ami
resource "aws_instance" "virtualmachine_1" {
  ami           = data.aws_ami.windows_2019.id
  instance_type = "t2.micro"

  key_name = aws_key_pair.demo_key.id

  #retrieve the Administrator password
  get_password_data = true

  connection {
    type     = "winrm"
    port     = 5986
    password = rsadecrypt(self.password_data, file("id_rsa"))
    https    = true
    insecure = true
    timeout  = "10m"
  }

  network_interface {
    network_interface_id = aws_network_interface.vm_nic_1.id
    device_index         = 0
  }

  user_data = file("./scripts/install-cwagent.ps1")

  tags = {
    Name = "${local.name}-vm-1"
  }

}
