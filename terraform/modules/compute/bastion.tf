resource "aws_security_group" "bastion" {
  count = var.enable_bastion ? 1 : 0

  name        = "${var.name_prefix}-bastion-sg"
  description = "Security group for bastion host - SSM access only"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow all outbound traffic for SSM and package updates"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-bastion-sg"
  })
}

data "aws_iam_policy_document" "bastion_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "bastion" {
  count = var.enable_bastion ? 1 : 0

  name               = "${var.name_prefix}-bastion-role"
  assume_role_policy = data.aws_iam_policy_document.bastion_assume_role.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-bastion-role"
  })
}

resource "aws_iam_role_policy_attachment" "bastion_ssm" {
  count = var.enable_bastion ? 1 : 0

  role       = aws_iam_role.bastion[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "bastion_cloudwatch" {
  count = var.enable_bastion && var.enable_cloudwatch_agent ? 1 : 0

  role       = aws_iam_role.bastion[0].name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "bastion_additional" {
  count = var.enable_bastion ? length(var.additional_iam_policies) : 0

  role       = aws_iam_role.bastion[0].name
  policy_arn = var.additional_iam_policies[count.index]
}

resource "aws_iam_instance_profile" "bastion" {
  count = var.enable_bastion ? 1 : 0

  name = "${var.name_prefix}-bastion-profile"
  role = aws_iam_role.bastion[0].name

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-bastion-profile"
  })
}

resource "aws_cloudwatch_log_group" "bastion" {
  count = var.enable_bastion && var.enable_cloudwatch_agent ? 1 : 0

  name              = local.cloudwatch_log_group_name
  retention_in_days = var.cloudwatch_log_retention_days

  tags = merge(var.tags, {
    Name = local.cloudwatch_log_group_name
  })
}

resource "aws_cloudwatch_log_group" "session_manager" {
  count = var.enable_bastion && var.enable_session_manager_logging ? 1 : 0

  name              = local.session_manager_log_group_name
  retention_in_days = var.cloudwatch_log_retention_days

  tags = merge(var.tags, {
    Name = local.session_manager_log_group_name
  })
}

resource "aws_instance" "bastion" {
  count = var.enable_bastion && !var.enable_bastion_auto_scaling ? 1 : 0

  ami                    = local.bastion_ami_id
  instance_type          = var.bastion_instance_type
  subnet_id              = var.subnet_ids[0]
  iam_instance_profile   = aws_iam_instance_profile.bastion[0].name
  vpc_security_group_ids = concat([aws_security_group.bastion[0].id], var.additional_security_group_ids)

  associate_public_ip_address = var.associate_public_ip
  monitoring                  = var.enable_detailed_monitoring

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = var.enable_imdsv2 ? "required" : "optional"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  root_block_device {
    volume_size           = var.bastion_root_volume_size
    volume_type           = var.bastion_root_volume_type
    encrypted             = var.bastion_root_volume_encrypted
    kms_key_id            = var.bastion_root_volume_kms_key_id != "" ? var.bastion_root_volume_kms_key_id : null
    delete_on_termination = true
  }

  user_data = var.user_data != "" ? var.user_data : null

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-bastion"
  })

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_launch_template" "bastion" {
  count = var.enable_bastion && var.enable_bastion_auto_scaling ? 1 : 0

  name_prefix   = "${var.name_prefix}-bastion-"
  image_id      = local.bastion_ami_id
  instance_type = var.bastion_instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.bastion[0].name
  }

  vpc_security_group_ids = concat([aws_security_group.bastion[0].id], var.additional_security_group_ids)

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = var.enable_imdsv2 ? "required" : "optional"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.bastion_root_volume_size
      volume_type           = var.bastion_root_volume_type
      encrypted             = var.bastion_root_volume_encrypted
      kms_key_id            = var.bastion_root_volume_kms_key_id != "" ? var.bastion_root_volume_kms_key_id : null
      delete_on_termination = true
    }
  }

  monitoring {
    enabled = var.enable_detailed_monitoring
  }

  user_data = var.user_data != "" ? base64encode(var.user_data) : null

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, {
      Name = "${var.name_prefix}-bastion"
    })
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-bastion-lt"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  count = var.enable_bastion && var.enable_bastion_auto_scaling ? 1 : 0

  name                = "${var.name_prefix}-bastion-asg"
  vpc_zone_identifier = var.subnet_ids
  desired_capacity    = var.bastion_desired_capacity
  min_size            = var.bastion_min_size
  max_size            = var.bastion_max_size

  launch_template {
    id      = aws_launch_template.bastion[0].id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-bastion"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
