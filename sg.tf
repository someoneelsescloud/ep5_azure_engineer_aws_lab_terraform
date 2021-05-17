# Allow WinRM to set adminstrator password
resource "aws_security_group" "allow_winrm" {
  name        = "allow_winrm"
  description = "Allow access the instances via WinRM over HTTP and HTTPS"
  vpc_id      = aws_vpc.vpc_1.id

  ingress {
    description = "Access the instances via WinRM over HTTP and HTTPS"
    from_port   = 5985
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name}-allow-winrm"
  }
}

# Allow RDP connectvity to EC2 instances
resource "aws_security_group" "allow_rdp" {
  name        = "allow_rdp"
  description = "Allow access the instances via RDP"
  vpc_id      = aws_vpc.vpc_1.id

  ingress {
    description = "Allow access the instances via RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name}-allow-rdp"
  }
}