data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

locals {
  bastion_ami_id = var.bastion_ami_id != "" ? var.bastion_ami_id : data.aws_ami.amazon_linux_2023.id

  cloudwatch_log_group_name      = var.cloudwatch_log_group_name != "" ? var.cloudwatch_log_group_name : "/aws/ec2/${var.name_prefix}-bastion"
  session_manager_log_group_name = var.session_manager_log_group_name != "" ? var.session_manager_log_group_name : "/aws/ssm/${var.name_prefix}-sessions"
}
