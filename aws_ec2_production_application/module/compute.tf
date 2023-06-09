locals {
  instances = {
    0 : {
      az_index : "0",
    },
    1 : {
      az_index : "1",
    }
  }
}

resource "aws_instance" "ec2_instances" {
  for_each = local.instances

  ami               = var.ami
  instance_type     = var.instance_type
  security_groups   = [aws_security_group.ec2_security_group.name]
  availability_zone = data.aws_availability_zones.availability_zone.names[each.value.az_index]
  user_data         = <<-EOF
              #!/bin/bash
              echo "<h1>Hello, World ${each.key}</h1>" > index.html
              python3 -m http.server 3000 &
              EOF

  tags = {
    Name = "${var.app_name}-${var.environment}-instance-${each.key}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_availability_zones" "availability_zone" {
  state = "available"
}

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   }

#   owners = ["099720109477"] # Canonical

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }
